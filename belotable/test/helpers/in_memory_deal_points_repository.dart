import 'package:belotable/domain/manches/deal_points.dart';
import 'package:belotable/domain/manches/deal_points_repository.dart';

/// In-memory implementation of DealPointsRepository for testing.
class InMemoryDealPointsRepository implements DealPointsRepository {
  final _dealPoints = <({int tableDoubletteId, int dealNumber}), int>{};

  @override
  Future<void> initializeDealPoints({
    required int tableDoubletteId,
    required int numberOfDeals,
  }) async {
    for (var dealNumber = 1; dealNumber <= numberOfDeals; dealNumber++) {
      _dealPoints[(
            tableDoubletteId: tableDoubletteId,
            dealNumber: dealNumber,
          )] =
          0;
    }
  }

  @override
  Future<List<DealPoints>> findDealPointsForTableDoublette({
    required int tableDoubletteId,
  }) async {
    final result = <DealPoints>[];
    for (final entry in _dealPoints.entries) {
      if (entry.key.tableDoubletteId == tableDoubletteId) {
        result.add(
          DealPoints(
            tableDoubletteId: entry.key.tableDoubletteId,
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
    required int tableDoubletteId,
    required int dealNumber,
    required int points,
  }) async {
    _dealPoints[(
          tableDoubletteId: tableDoubletteId,
          dealNumber: dealNumber,
        )] =
        points;
  }

  @override
  Future<int> calculateTotalPointsFromDeals({
    required int tableDoubletteId,
  }) async {
    var total = 0;
    for (final entry in _dealPoints.entries) {
      if (entry.key.tableDoubletteId == tableDoubletteId) {
        total += entry.value;
      }
    }
    return total;
  }
}
