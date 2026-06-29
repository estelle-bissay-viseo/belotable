import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/domain/manches/deal_points.dart';
import 'package:belotable/domain/manches/deal_points_repository.dart';

/// Drift-backed implementation of DealPointsRepository.
class DriftDealPointsRepository implements DealPointsRepository {
  /// Creates repository with database accessor.
  DriftDealPointsRepository(this._database);

  final AppDatabase _database;

  @override
  Future<void> initializeDealPoints({
    required int tableDoubletteId,
    required int numberOfDeals,
  }) async {
    await _database.manchesDao.initializeDealPoints(
      tableDoubletteId: tableDoubletteId,
      numberOfDeals: numberOfDeals,
    );
  }

  @override
  Future<List<DealPoints>> findDealPointsForTableDoublette({
    required int tableDoubletteId,
  }) async {
    final rows = await _database.manchesDao.findDealPointsForTableDoublette(
      tableDoubletteId: tableDoubletteId,
    );

    return rows
        .map(
          (row) => DealPoints(
            tableDoubletteId: row.tableDoubletteId,
            dealNumber: row.dealNumber,
            points: row.points,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateDealPoints({
    required int tableDoubletteId,
    required int dealNumber,
    required int points,
  }) async {
    await _database.manchesDao.updateDealPoints(
      tableDoubletteId: tableDoubletteId,
      dealNumber: dealNumber,
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
}
