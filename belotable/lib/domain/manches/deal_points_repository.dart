import 'package:belotable/domain/manches/deal_points.dart';

/// Repository for managing deal-level points.
abstract class DealPointsRepository {
  /// Initializes all deals with 0 points for a doublette.
  Future<void> initializeDealPoints({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
    required int numberOfDeals,
  });

  /// Retrieves all deal points for a specific table-doublette.
  Future<List<DealPoints>> findDealPointsForTableDoublette({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
  });

  /// Updates points for a specific deal.
  Future<void> updateDealPoints({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
    required int dealNumber,
    required int points,
  });

  /// Calculates total points for a doublette from all deals.
  Future<int> calculateTotalPointsFromDeals({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
  });
}
