import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/manche_repository.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';

class InMemoryMancheRepository implements MancheRepository {
  final manches = <Manche>[];
  final _tablesByManche = <int, List<TableDeJeu>>{};

  @override
  Future<Manche> createPremiereManche({
    required String concoursId,
    required List<Doublette> doublettes,
  }) async {
    final manche = Manche(
      id: manches.length + 1,
      concoursId: concoursId,
      numero: 1,
    );
    manches.add(manche);

    final tables = <TableDeJeu>[];
    var tableNumero = 1;
    for (var i = 0; i < doublettes.length; i += 2) {
      final first = doublettes[i];
      final second = i + 1 < doublettes.length ? doublettes[i + 1] : null;

      final tableId = tables.length + 1;
      final participants = <TableDoublette>[
        TableDoublette(
          tableId: tableId,
          concoursId: concoursId,
          doubletteId: first.doubletteId,
          score: 0,
          statut: TableDoubletteStatut.enAttente,
          nomEquipe: first.nomEquipe,
        ),
        if (second != null)
          TableDoublette(
            tableId: tableId,
            concoursId: concoursId,
            doubletteId: second.doubletteId,
            score: 0,
            statut: TableDoubletteStatut.enAttente,
            nomEquipe: second.nomEquipe,
          ),
      ];

      tables.add(
        TableDeJeu(
          id: tableId,
          mancheId: manche.id,
          numero: tableNumero++,
          statut: TableDeJeuStatut.fromDoublettes(participants),
          doublettes: participants,
        ),
      );
    }

    _tablesByManche[manche.id] = tables;
    return manche;
  }

  @override
  Future<void> addDoubletteToTable({
    required int tableId,
    required String concoursId,
    required int doubletteId,
  }) async {
    for (final entry in _tablesByManche.entries) {
      final tableIndex = entry.value.indexWhere((t) => t.id == tableId);
      if (tableIndex == -1) {
        continue;
      }

      final alreadyAssignedInManche = entry.value.any(
        (t) => t.doublettes.any(
          (td) => td.concoursId == concoursId && td.doubletteId == doubletteId,
        ),
      );
      if (alreadyAssignedInManche) {
        return;
      }

      final table = entry.value[tableIndex];
      if (table.doublettes.length >= 2) {
        return;
      }

      final updated = [
        ...table.doublettes,
        TableDoublette(
          tableId: tableId,
          concoursId: concoursId,
          doubletteId: doubletteId,
          score: 0,
          statut: TableDoubletteStatut.enAttente,
          nomEquipe: 'Equipe $doubletteId',
        ),
      ];
      entry.value[tableIndex] = TableDeJeu(
        id: table.id,
        mancheId: table.mancheId,
        numero: table.numero,
        statut: TableDeJeuStatut.fromDoublettes(updated),
        doublettes: updated,
      );
      return;
    }
  }

  @override
  Future<void> assignDoubletteToLatestManche({
    required String concoursId,
    required int doubletteId,
  }) async {
    final concoursManches =
        manches.where((m) => m.concoursId == concoursId).toList(growable: false)
          ..sort((a, b) => b.numero.compareTo(a.numero));

    if (concoursManches.isEmpty) {
      return;
    }

    final latestManche = concoursManches.first;
    final tables = _tablesByManche[latestManche.id] ?? <TableDeJeu>[];

    final alreadyAssigned = tables.any(
      (t) => t.doublettes.any(
        (td) => td.concoursId == concoursId && td.doubletteId == doubletteId,
      ),
    );
    if (alreadyAssigned) {
      return;
    }

    final availableIndex = tables.indexWhere((t) => t.doublettes.length < 2);
    if (availableIndex != -1) {
      await addDoubletteToTable(
        tableId: tables[availableIndex].id,
        concoursId: concoursId,
        doubletteId: doubletteId,
      );
      return;
    }

    final nextTableId = tables.isEmpty
        ? 1
        : tables.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    final nextNumero = tables.isEmpty
        ? 1
        : tables.map((t) => t.numero).reduce((a, b) => a > b ? a : b) + 1;

    final newDoublette = TableDoublette(
      tableId: nextTableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      score: 0,
      statut: TableDoubletteStatut.enAttente,
      nomEquipe: 'Equipe $doubletteId',
    );
    final participants = <TableDoublette>[newDoublette];

    tables.add(
      TableDeJeu(
        id: nextTableId,
        mancheId: latestManche.id,
        numero: nextNumero,
        statut: TableDeJeuStatut.fromDoublettes(participants),
        doublettes: participants,
      ),
    );
    _tablesByManche[latestManche.id] = tables;
  }

  @override
  Future<int?> findFirstAvailableTableId(String concoursId) async {
    for (final tables in _tablesByManche.values) {
      for (final table in tables) {
        if (table.doublettes.length < 2) {
          return table.id;
        }
      }
    }
    return null;
  }

  @override
  Future<List<Manche>> findManchesByConcoursId(String concoursId) async {
    return manches
        .where((m) => m.concoursId == concoursId)
        .toList(growable: false)
      ..sort((a, b) => a.numero.compareTo(b.numero));
  }

  @override
  Future<TableDoublette?> findTableDoublette({
    required String concoursId,
    required int doubletteId,
  }) async {
    for (final tables in _tablesByManche.values) {
      for (final table in tables) {
        for (final td in table.doublettes) {
          if (td.concoursId == concoursId && td.doubletteId == doubletteId) {
            return td;
          }
        }
      }
    }
    return null;
  }

  @override
  Future<List<TableDeJeu>> findTablesDeJeuByMancheId(int mancheId) async {
    return _tablesByManche[mancheId] ?? const [];
  }

  @override
  Future<bool> mancheExistsPourConcours(String concoursId) async {
    return manches.any((m) => m.concoursId == concoursId);
  }

  @override
  Future<void> removeDoubletteFromTable({
    required String concoursId,
    required int doubletteId,
  }) async {
    for (final entry in _tablesByManche.entries) {
      final tables = entry.value;
      for (var i = 0; i < tables.length; i++) {
        final table = tables[i];
        final updated = table.doublettes
            .where(
              (td) =>
                  !(td.concoursId == concoursId &&
                      td.doubletteId == doubletteId),
            )
            .toList(growable: false);
        if (updated.length != table.doublettes.length) {
          if (updated.isEmpty) {
            tables.removeAt(i);
          } else {
            tables[i] = TableDeJeu(
              id: table.id,
              mancheId: table.mancheId,
              numero: table.numero,
              statut: TableDeJeuStatut.fromDoublettes(updated),
              doublettes: updated,
            );
          }
          return;
        }
      }
    }
  }

  @override
  Future<void> updateScore({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int score,
  }) async {
    await _updateTableDoublette(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      mapper: (td) => td.copyWith(score: score),
    );
  }

  @override
  Future<TableDeJeu> updateStatut({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required TableDoubletteStatut statut,
  }) async {
    late TableDeJeu updatedTable;

    await _updateTableDoublette(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      mapper: (td) => td.copyWith(statut: statut),
      afterMap: (doublettes) {
        if (statut != TableDoubletteStatut.gagne) {
          var opponentStatut = statut;
          if (statut == TableDoubletteStatut.perdu ||
              statut == TableDoubletteStatut.abandon) {
            opponentStatut = TableDoubletteStatut.gagne;
          }
          return doublettes
              .map(
                (d) => d.doubletteId == doubletteId
                    ? d
                    : d.copyWith(statut: opponentStatut),
              )
              .toList(growable: false);
        }
        return doublettes;
      },
      onTableUpdated: (table) => updatedTable = table,
    );

    return updatedTable;
  }

  Future<void> _updateTableDoublette({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required TableDoublette Function(TableDoublette) mapper,
    List<TableDoublette> Function(List<TableDoublette>)? afterMap,
    void Function(TableDeJeu table)? onTableUpdated,
  }) async {
    for (final entry in _tablesByManche.entries) {
      final tables = entry.value;
      for (var i = 0; i < tables.length; i++) {
        final table = tables[i];
        if (table.id != tableId) {
          continue;
        }

        var changed = false;
        var updatedDoublettes = table.doublettes
            .map((td) {
              if (td.concoursId == concoursId &&
                  td.doubletteId == doubletteId) {
                changed = true;
                return mapper(td);
              }
              return td;
            })
            .toList(growable: false);

        if (!changed) {
          continue;
        }

        if (afterMap != null) {
          updatedDoublettes = afterMap(updatedDoublettes);
        }

        final updatedTable = TableDeJeu(
          id: table.id,
          mancheId: table.mancheId,
          numero: table.numero,
          statut: TableDeJeuStatut.fromDoublettes(updatedDoublettes),
          doublettes: updatedDoublettes,
        );
        tables[i] = updatedTable;
        onTableUpdated?.call(updatedTable);
        return;
      }
    }
  }

  @override
  Future<List<TableDeJeu>> findTablesDeJeuByConcoursId(
    String concoursId,
  ) async {
    final result = <TableDeJeu>[];
    for (final tables in _tablesByManche.values) {
      for (final table in tables) {
        if (table.doublettes.any((td) => td.concoursId == concoursId)) {
          result.add(table);
        }
      }
    }
    return result;
  }

  @override
  Future<void> mergeTableDoublettes({
    required int targetTableId,
    required int sourceTableId,
    required String concoursId,
  }) async {
    for (final entry in _tablesByManche.entries) {
      final tables = entry.value;

      // Find target and source tables
      var targetIndex = -1;
      var sourceIndex = -1;

      for (var i = 0; i < tables.length; i++) {
        if (tables[i].id == targetTableId) {
          targetIndex = i;
        }
        if (tables[i].id == sourceTableId) {
          sourceIndex = i;
        }
      }

      // Both tables must exist in the same manche
      if (targetIndex == -1 || sourceIndex == -1) {
        continue;
      }

      final targetTable = tables[targetIndex];
      final sourceTable = tables[sourceIndex];

      // Move all doublettes from source to target
      final mergedDoublettes = [
        ...targetTable.doublettes,
        ...sourceTable.doublettes,
      ];

      // Update target table with merged doublettes
      tables[targetIndex] = TableDeJeu(
        id: targetTable.id,
        mancheId: targetTable.mancheId,
        numero: targetTable.numero,
        statut: TableDeJeuStatut.fromDoublettes(mergedDoublettes),
        doublettes: mergedDoublettes,
      );

      // Remove source table
      tables.removeAt(sourceIndex);

      return;
    }
  }
}
