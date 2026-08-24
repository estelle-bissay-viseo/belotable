import 'package:belotable/domain/manches/donne_doublette.dart';

/// Repository for managing deal-level points (donnes doublettes).
abstract class DonneDoubletteRepository {
  /// Initializes all deals with 0 points for a table-doublette.
  Future<void> initializeDonneDoublettes({
    required int tableDoubletteId,
    required int numberOfDeals,
  });

  /// Retrieves all donnes doublettes for a specific table-doublette.
  Future<List<DonneDoublette>> findDonneDoublettesForTableDoublette({
    required int tableDoubletteId,
  });

  /// Updates points for a specific deal.
  Future<void> updateDonneDoublette({
    required int tableDoubletteId,
    required int donneNumero,
    required int points,
  });

  /// Calculates total points for a table-doublette from all deals.
  Future<int> calculateTotalPointsFromDeals({
    required int tableDoubletteId,
  });
}
