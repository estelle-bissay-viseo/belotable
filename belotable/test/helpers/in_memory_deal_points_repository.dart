import 'package:belotable/domain/manches/deal_points.dart';
import 'package:belotable/domain/manches/deal_points_repository.dart';

/// In-memory implementation of DealPointsRepository for testing.
class InMemoryDealPointsRepository implements DealPointsRepository {
  final _dealPoints =
      <
        ({
          int tableId,
          String concoursId,
          int doubletteId,
          int mancheId,
          int dealNumber,
        }),
        int
      >{};

  @override
  Future<void> initializeDealPoints({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
    required int numberOfDeals,
  }) async {
    for (var dealNumber = 1; dealNumber <= numberOfDeals; dealNumber++) {
      _dealPoints[(
            tableId: tableId,
            concoursId: concoursId,
            doubletteId: doubletteId,
            mancheId: mancheId,
            dealNumber: dealNumber,
          )] =
          0;
    }
  }

  @override
  Future<List<DealPoints>> findDealPointsForTableDoublette({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
  }) async {
    final result = <DealPoints>[];
    for (final entry in _dealPoints.entries) {
      if (entry.key.tableId == tableId &&
          entry.key.concoursId == concoursId &&
          entry.key.doubletteId == doubletteId &&
          entry.key.mancheId == mancheId) {
        result.add(
          DealPoints(
            tableId: entry.key.tableId,
            concoursId: entry.key.concoursId,
            doubletteId: entry.key.doubletteId,
            mancheId: entry.key.mancheId,
            dealNumber: entry.key.dealNumber,
            points: entry.value,
          ),
        );
      }
    }
    result.sort((a, b) => a.dealNumber.compareTo(b.dealNumber));
    return result;
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
    _dealPoints[(
          tableId: tableId,
          concoursId: concoursId,
          doubletteId: doubletteId,
          mancheId: mancheId,
          dealNumber: dealNumber,
        )] =
        points;
  }

  @override
  Future<int> calculateTotalPointsFromDeals({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
  }) async {
    var total = 0;
    for (final entry in _dealPoints.entries) {
      if (entry.key.tableId == tableId &&
          entry.key.concoursId == concoursId &&
          entry.key.doubletteId == doubletteId &&
          entry.key.mancheId == mancheId) {
        total += entry.value;
      }
    }
    return total;
  }
}
