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
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
    required int numberOfDeals,
  }) async {
    await _database.manchesDao.initializeDealPoints(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      mancheId: mancheId,
      numberOfDeals: numberOfDeals,
    );
  }

  @override
  Future<List<DealPoints>> findDealPointsForTableDoublette({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
  }) async {
    final rows = await _database.manchesDao.findDealPointsForTableDoublette(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      mancheId: mancheId,
    );

    return rows
        .map(
          (row) => DealPoints(
            tableId: row.tableId,
            concoursId: row.concoursId,
            doubletteId: row.doubletteId,
            mancheId: row.mancheId,
            dealNumber: row.dealNumber,
            points: row.points,
          ),
        )
        .toList();
  }

  @override
  Future<void> updateDealPoints({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
    required int dealNumber,
    required int points,
  }) async {
    await _database.manchesDao.updateDealPoints(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      mancheId: mancheId,
      dealNumber: dealNumber,
      points: points,
    );
  }

  @override
  Future<int> calculateTotalPointsFromDeals({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
  }) async {
    return _database.manchesDao.calculateTotalPointsFromDeals(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      mancheId: mancheId,
    );
  }
}
