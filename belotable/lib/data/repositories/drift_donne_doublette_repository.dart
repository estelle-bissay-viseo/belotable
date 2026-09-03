import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/domain/manches/donne_doublette.dart';
import 'package:belotable/domain/manches/donne_doublette_repository.dart';

/// Drift-backed implementation of DonneDoubletteRepository.
class DriftDonneDoubletteRepository implements DonneDoubletteRepository {
  /// Creates repository with database accessor.
  DriftDonneDoubletteRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> initializeDonneDoublettes({
    required int tableDoubletteId,
    required int numberOfDeals,
  }) async {
    await _database.manchesDao.initializeDonneDoublettes(
      tableDoubletteId: tableDoubletteId,
      numberOfDeals: numberOfDeals,
    );
  }

  @override
  Future<List<DonneDoublette>> findDonneDoublettesForTableDoublette({
    required int tableDoubletteId,
  }) async {
    final rows = await _database.manchesDao
        .findDonneDoublettesForTableDoublette(
          tableDoubletteId: tableDoubletteId,
        );

    return rows
        .map(
          (row) => DonneDoublette(
            tableDoubletteId: row.tableDoubletteId,
            donneNumero: row.donneNumero,
            points: row.points,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateDonneDoublette({
    required int tableDoubletteId,
    required int donneNumero,
    required int points,
  }) async {
    await _database.manchesDao.updateDonneDoublette(
      tableDoubletteId: tableDoubletteId,
      donneNumero: donneNumero,
      points: points,
    );
  }

  @override
  Future<int> calculateTotalPointsFromDeals({
    required int tableDoubletteId,
  }) async {
    return _database.manchesDao.calculateTotalPointsFromDeals(
      tableDoubletteId: tableDoubletteId,
    );
  }

  @override
  Future<void> resetDonneDoublettes({
    required int tableDoubletteId,
  }) async {
    await _database.manchesDao.resetDonneDoublettes(
      tableDoubletteId: tableDoubletteId,
    );
  }
}
