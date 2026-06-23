import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/manches/manche_exceptions.dart';
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
  /// - [TableDoubletteStatut.enAttente] on all records: removes from table,
  ///   then deletes physically.
  /// - Any record with status other than [TableDoubletteStatut.enAttente]:
  ///   throws [DoubletteDejaJoueeException].
  ///
  /// After removal, if a table is left with only one doublette and another
  /// table in the same concours also has exactly one doublette with
  /// [TableDoubletteStatut.enAttente] status, the tables are merged into one:
  /// the table with the smaller id keeps both doublettes, and the other table
  /// is deleted.
  ///
  /// Returns true when doublette is physically deleted.
  /// Throws [DoubletteDejaJoueeException] if doublette has already played.
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
      final tableDoublettes = await mancheRepo.findTableDoublettesByDoubletteId(
        concoursId: trimmedConcoursId,
        doubletteId: doubletteId,
      );

      // Check if any record has status other than enAttente
      for (final tableDoublette in tableDoublettes) {
        if (tableDoublette.statut != TableDoubletteStatut.enAttente) {
          throw DoubletteDejaJoueeException(doubletteId);
        }
      }

      // If there are any enAttente records, remove from table
      if (tableDoublettes.isNotEmpty) {
        await mancheRepo.removeDoubletteFromTable(
          concoursId: trimmedConcoursId,
          doubletteId: doubletteId,
        );

        // Try to merge tables if this deletion leaves a table
        // with only 1 doublette
        await _mergeSingleDoubletteTablesIfNeeded(
          mancheRepo,
          trimmedConcoursId,
          tableDoublettes.first.tableId,
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
