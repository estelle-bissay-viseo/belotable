import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/manche_repository.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';

/// Drift-backed implementation of [MancheRepository].
class DriftMancheRepository implements MancheRepository {
  /// Creates repository bound to the given database.
  DriftMancheRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Manche> createPremiereManche({
    required String concoursId,
    required List<Doublette> doublettes,
  }) async {
    return _db.transaction(() async {
      final mancheRow = await _db.manchesDao.insertManche(
        ManchesTableCompanion.insert(concoursId: concoursId, numero: 1),
      );

      // Distribute doublettes into tables of 2 (last may have 3 if odd)
      final tableCount = (doublettes.length / 2).ceil();
      for (var t = 0; t < tableCount; t++) {
        final tableRow = await _db.manchesDao.insertTableDeJeu(
          TablesDeJeuTableCompanion.insert(
            mancheId: mancheRow.id,
            numero: t + 1,
          ),
        );

        final start = t * 2;
        final end = (start + 2 < doublettes.length)
            ? start + 2
            : doublettes.length;

        for (var i = start; i < end; i++) {
          await _db.manchesDao.addDoubletteToTable(
            tableId: tableRow.id,
            concoursId: concoursId,
            doubletteId: doublettes[i].doubletteId,
          );
        }
      }

      return Manche(
        id: mancheRow.id,
        concoursId: concoursId,
        numero: mancheRow.numero,
      );
    });
  }

  @override
  Future<List<Manche>> findManchesByConcoursId(String concoursId) async {
    final rows = await _db.manchesDao.findManchesByConcoursId(concoursId);
    return rows
        .map(
          (r) => Manche(id: r.id, concoursId: r.concoursId, numero: r.numero),
        )
        .toList(growable: false);
  }

  @override
  Future<List<TableDeJeu>> findTablesDeJeuByMancheId(int mancheId) {
    return _db.manchesDao.findTablesDeJeuByMancheId(mancheId);
  }

  @override
  Future<bool> mancheExistsPourConcours(String concoursId) {
    return _db.manchesDao.mancheExistsPourConcours(concoursId);
  }

  @override
  Future<int?> findFirstAvailableTableId(String concoursId) {
    return _db.manchesDao.findFirstAvailableTableId(concoursId);
  }

  @override
  Future<void> addDoubletteToTable({
    required int tableId,
    required String concoursId,
    required int doubletteId,
  }) {
    return _db.manchesDao.addDoubletteToTable(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
    );
  }

  @override
  Future<void> assignDoubletteToLatestManche({
    required String concoursId,
    required int doubletteId,
  }) {
    return _db.manchesDao.assignDoubletteToLatestManche(
      concoursId: concoursId,
      doubletteId: doubletteId,
    );
  }

  @override
  Future<void> removeDoubletteFromTable({
    required String concoursId,
    required int doubletteId,
  }) {
    return _db.manchesDao.removeDoubletteFromTable(
      concoursId: concoursId,
      doubletteId: doubletteId,
    );
  }

  @override
  Future<TableDoublette?> findTableDoublette({
    required String concoursId,
    required int doubletteId,
  }) {
    return _db.manchesDao.findTableDoublette(
      concoursId: concoursId,
      doubletteId: doubletteId,
    );
  }

  @override
  Future<void> updateScore({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int score,
  }) {
    return _db.manchesDao.updateScore(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      score: score,
    );
  }

  @override
  Future<TableDeJeu> updateStatut({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required TableDoubletteStatut statut,
  }) {
    return _db.manchesDao.updateStatutWithRules(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      statut: statut,
    );
  }

  @override
  Future<List<TableDeJeu>> findTablesDeJeuByConcoursId(String concoursId) {
    return _db.manchesDao.findTablesDeJeuByConcoursId(concoursId);
  }

  @override
  Future<void> mergeTableDoublettes({
    required int targetTableId,
    required int sourceTableId,
    required String concoursId,
  }) {
    return _db.manchesDao.mergeTableDoublettes(
      targetTableId: targetTableId,
      sourceTableId: sourceTableId,
      concoursId: concoursId,
    );
  }
}
