import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/manches/manche_repository.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';

/// Deletes one doublette from a contest.
class DeleteDoubletteUseCase {
  /// Creates use case with required repository and optional manche repository.
  DeleteDoubletteUseCase(this._repository, {this.mancheRepository});

  final DoubletteRepository _repository;

  /// Optional manche repository used to enforce deletion constraints.
  final MancheRepository? mancheRepository;

  /// Deletes one row by composite key.
  ///
  /// If the doublette is assigned to a manche table:
  /// - [TableDoubletteStatut.enAttente]: removes from table, then deletes.
  /// - Playing or already played: converts status to Abandon and keeps row.
  ///
  /// After removal, if a table is left with only one doublette and another
  /// table in the same concours also has exactly one doublette with
  /// [TableDoubletteStatut.enAttente] status, the tables are merged into one:
  /// the table with the smaller id keeps both doublettes, and the other table
  /// is deleted.
  ///
  /// Returns true when doublette is physically deleted, false when converted
  /// to abandon.
  Future<bool> call({
    required String concoursId,
    required int doubletteId,
  }) async {
    final trimmedConcoursId = concoursId.trim();
    if (trimmedConcoursId.isEmpty) {
      throw ArgumentError.value(
        concoursId,
        'concoursId',
        'concoursId required',
      );
    }
    if (doubletteId <= 0) {
      throw ArgumentError.value(doubletteId, 'doubletteId', 'doubletteId > 0');
    }

    final mancheRepo = mancheRepository;
    if (mancheRepo != null) {
      final tableDoublette = await mancheRepo.findTableDoublette(
        concoursId: trimmedConcoursId,
        doubletteId: doubletteId,
      );

      if (tableDoublette != null) {
        if (tableDoublette.statut != TableDoubletteStatut.enAttente) {
          await mancheRepo.updateStatut(
            tableId: tableDoublette.tableId,
            concoursId: trimmedConcoursId,
            doubletteId: doubletteId,
            statut: TableDoubletteStatut.abandon,
          );
          return false;
        }
        await mancheRepo.removeDoubletteFromTable(
          concoursId: trimmedConcoursId,
          doubletteId: doubletteId,
        );

        // Try to merge tables if this deletion leaves a table
        // with only 1 doublette
        await _mergeSingleDoubletteTablesIfNeeded(
          mancheRepo,
          trimmedConcoursId,
          tableDoublette.tableId,
        );
      }
    }

    return _repository.delete(
      concoursId: trimmedConcoursId,
      doubletteId: doubletteId,
    );
  }

  /// Merges single-doublette tables if conditions are met.
  ///
  /// If the specified table no longer exists or has more than 1 doublette,
  /// no merge happens. Otherwise, if another table in the same concours also
  /// has exactly 1 doublette with enAttente status, merges them.
  Future<void> _mergeSingleDoubletteTablesIfNeeded(
    MancheRepository mancheRepo,
    String concoursId,
    int sourceTableId,
  ) async {
    final allTables = await mancheRepo.findTablesDeJeuByConcoursId(concoursId);

    // Find the source table
    TableDeJeu? sourceTable;
    for (final table in allTables) {
      if (table.id == sourceTableId) {
        sourceTable = table;
        break;
      }
    }

    // Table doesn't exist or has moved on from single doublette
    if (sourceTable == null || sourceTable.doublettes.length != 1) {
      return;
    }

    // At this point, sourceTable is definitely not null
    final safeSourceTable = sourceTable;

    // Find another table with exactly 1 doublette and enAttente status
    final candidates = allTables
        .where(
          (t) =>
              t.id != sourceTableId &&
              t.doublettes.length == 1 &&
              t.doublettes.first.statut == TableDoubletteStatut.enAttente &&
              t.mancheId == safeSourceTable.mancheId,
        )
        .toList();

    if (candidates.isEmpty) {
      return;
    }

    // Pick the candidate with smallest ID to be the target
    candidates.sort((a, b) => a.id.compareTo(b.id));
    final targetTable = candidates.first;

    // Determine which table to delete (larger id)
    final targetId = safeSourceTable.id < targetTable.id
        ? safeSourceTable.id
        : targetTable.id;
    final sourceId = safeSourceTable.id < targetTable.id
        ? targetTable.id
        : safeSourceTable.id;

    await mancheRepo.mergeTableDoublettes(
      targetTableId: targetId,
      sourceTableId: sourceId,
      concoursId: concoursId,
    );
  }
}
