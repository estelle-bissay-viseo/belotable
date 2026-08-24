import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/manche_repository.dart';
import 'package:belotable/domain/manches/manche_statut.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';

import 'in_memory_doublette_repository.dart';

class InMemoryMancheRepository implements MancheRepository {
  InMemoryMancheRepository(this._doubletteRepository);

  final InMemoryDoubletteRepository _doubletteRepository;
  final manches = <Manche>[];
  final _tablesByManche = <int, List<TableDeJeu>>{};
  final _doubletteRowIdByTableDoubletteId = <int, int>{};
  var _nextTableDoubletteId = 1;

  TableDoublette _buildTableDoublette({
    required int tableId,
    required int doubletteRowId,
    int points = 0,
    TableDoubletteStatut statut = TableDoubletteStatut.enAttente,
  }) {
    final id = _nextTableDoubletteId++;
    _doubletteRowIdByTableDoubletteId[id] = doubletteRowId;
    final doublette = _doubletteRepository.findByRowId(doubletteRowId);
    return TableDoublette(
      id: id,
      tableId: tableId,
      concoursId: doublette?.concoursId ?? '',
      doubletteId: doublette?.doubletteId ?? doubletteRowId,
      points: points,
      statut: statut,
      nomEquipe: doublette?.nomEquipe ?? 'Equipe $doubletteRowId',
    );
  }

  @override
  Future<Manche> createPremiereManche({
    required String concoursId,
    required List<Doublette> doublettes,
  }) async {
    final existing = manches.where((m) => m.concoursId == concoursId).toList();
    final nextNumero = existing.isEmpty
        ? 1
        : existing.map((m) => m.numero).reduce((a, b) => a > b ? a : b) + 1;

    final manche = Manche(
      id: manches.length + 1,
      concoursId: concoursId,
      numero: nextNumero,
      statut: MancheStatut.enCours,
    );
    manches.add(manche);

    final tables = <TableDeJeu>[];
    var tableNumero = 1;
    for (var i = 0; i < doublettes.length; i += 2) {
      final first = doublettes[i];
      final second = i + 1 < doublettes.length ? doublettes[i + 1] : null;

      final tableId = tables.length + 1;
      final participants = <TableDoublette>[
        _buildTableDoublette(tableId: tableId, doubletteRowId: first.id),
        if (second != null)
          _buildTableDoublette(tableId: tableId, doubletteRowId: second.id),
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
    required int doubletteRowId,
  }) async {
    for (final entry in _tablesByManche.entries) {
      final tableIndex = entry.value.indexWhere((t) => t.id == tableId);
      if (tableIndex == -1) {
        continue;
      }

      final alreadyAssignedInManche = entry.value.any(
        (t) => t.doublettes.any(
          (td) => _doubletteRowIdByTableDoubletteId[td.id] == doubletteRowId,
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
        _buildTableDoublette(tableId: tableId, doubletteRowId: doubletteRowId),
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
    required int doubletteRowId,
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
        (td) => _doubletteRowIdByTableDoubletteId[td.id] == doubletteRowId,
      ),
    );
    if (alreadyAssigned) {
      return;
    }

    final availableIndex = tables.indexWhere((t) => t.doublettes.length < 2);
    if (availableIndex != -1) {
      await addDoubletteToTable(
        tableId: tables[availableIndex].id,
        doubletteRowId: doubletteRowId,
      );
      return;
    }

    final nextTableId = tables.isEmpty
        ? 1
        : tables.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    final nextNumero = tables.isEmpty
        ? 1
        : tables.map((t) => t.numero).reduce((a, b) => a > b ? a : b) + 1;

    final participants = <TableDoublette>[
      _buildTableDoublette(
        tableId: nextTableId,
        doubletteRowId: doubletteRowId,
      ),
    ];

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
  Future<Manche?> findLatestManche(String concoursId) async {
    final concoursManches = await findManchesByConcoursId(concoursId);
    if (concoursManches.isEmpty) {
      return null;
    }
    final latest = concoursManches.last;

    // Recompute status from current doublettes
    final tables = _tablesByManche[latest.id] ?? [];
    final allDoublettes = <TableDoublette>[];
    for (final table in tables) {
      allDoublettes.addAll(table.doublettes);
    }
    final computedStatus = MancheStatut.fromDoublettes(allDoublettes);

    if (latest.statut == computedStatus) {
      return latest;
    }
    return Manche(
      id: latest.id,
      concoursId: latest.concoursId,
      numero: latest.numero,
      statut: computedStatus,
    );
  }

  @override
  Future<List<int>> findDoublettesWithAbandonHistory(
    String concoursId,
  ) async {
    final result = <int>{};
    for (final tables in _tablesByManche.values) {
      for (final table in tables) {
        for (final td in table.doublettes) {
          if (td.concoursId == concoursId &&
              td.statut == TableDoubletteStatut.abandon) {
            final rowId = _doubletteRowIdByTableDoubletteId[td.id];
            if (rowId != null) {
              result.add(rowId);
            }
          }
        }
      }
    }
    return result.toList(growable: false);
  }

  @override
  Future<TableDoublette?> findTableDoublette({
    required int doubletteRowId,
  }) async {
    for (final tables in _tablesByManche.values) {
      for (final table in tables) {
        for (final td in table.doublettes) {
          if (_doubletteRowIdByTableDoubletteId[td.id] == doubletteRowId) {
            return td;
          }
        }
      }
    }
    return null;
  }

  @override
  Future<List<TableDoublette>> findTableDoublettesByDoubletteRowId({
    required int doubletteRowId,
  }) async {
    final result = <TableDoublette>[];
    final tablesByMancheNum = <int, List<TableDeJeu>>{};

    for (final entry in _tablesByManche.entries) {
      final manche = manches.firstWhere((m) => m.id == entry.key);
      tablesByMancheNum[manche.numero] = entry.value;
    }

    final sortedMancheNumbers = tablesByMancheNum.keys.toList()..sort();
    for (final mancheNum in sortedMancheNumbers) {
      final tables = tablesByMancheNum[mancheNum];
      if (tables == null) {
        continue;
      }
      for (final table in tables) {
        for (final td in table.doublettes) {
          if (_doubletteRowIdByTableDoubletteId[td.id] == doubletteRowId) {
            result.add(td);
          }
        }
      }
    }

    return result;
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
    required int doubletteRowId,
  }) async {
    for (final entry in _tablesByManche.entries) {
      final tables = entry.value;
      for (var i = 0; i < tables.length; i++) {
        final table = tables[i];
        final updated = table.doublettes
            .where(
              (td) =>
                  _doubletteRowIdByTableDoubletteId[td.id] != doubletteRowId,
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
  Future<void> updatePoints({
    required int tableDoubletteId,
    required int points,
  }) async {
    await _updateTableDoublette(
      tableDoubletteId: tableDoubletteId,
      mapper: (td) => td.copyWith(points: points),
    );
  }

  @override
  Future<TableDeJeu> updateStatut({
    required int tableDoubletteId,
    required TableDoubletteStatut statut,
  }) async {
    late TableDeJeu updatedTable;

    await _updateTableDoublette(
      tableDoubletteId: tableDoubletteId,
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
                (d) => d.id == tableDoubletteId
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
    required int tableDoubletteId,
    required TableDoublette Function(TableDoublette) mapper,
    List<TableDoublette> Function(List<TableDoublette>)? afterMap,
    void Function(TableDeJeu table)? onTableUpdated,
  }) async {
    for (final entry in _tablesByManche.entries) {
      final tables = entry.value;
      for (var i = 0; i < tables.length; i++) {
        final table = tables[i];
        final hasTarget = table.doublettes.any(
          (td) => td.id == tableDoubletteId,
        );
        if (!hasTarget) {
          continue;
        }

        var updatedDoublettes = table.doublettes
            .map((td) => td.id == tableDoubletteId ? mapper(td) : td)
            .toList(growable: false);

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

  @override
  Future<void> initializeDonneDoublettesForManche({
    required int mancheId,
    required int numberOfDeals,
  }) async {
    // No-op for in-memory implementation
    // Donnes doublettes are handled by InMemoryDonneDoubletteRepository
  }

  @override
  Future<int> recalculateDoubletteTotalPoints(int tableDoubletteId) async {
    final doubletteRowId = _doubletteRowIdByTableDoubletteId[tableDoubletteId];
    if (doubletteRowId == null) {
      return 0;
    }

    var total = 0;
    for (final tables in _tablesByManche.values) {
      for (final table in tables) {
        for (final td in table.doublettes) {
          if (_doubletteRowIdByTableDoubletteId[td.id] == doubletteRowId) {
            total += td.points;
          }
        }
      }
    }

    await _doubletteRepository.updateTotalPoints(doubletteRowId, total);
    return total;
  }
}
