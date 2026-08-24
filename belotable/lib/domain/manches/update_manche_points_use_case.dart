import 'package:belotable/domain/manches/donne_doublette_repository.dart';
import 'package:belotable/domain/manches/manche_repository.dart';

/// Updates deal points for a table-doublette
/// and recalculates total points.
class UpdateManchePointsUseCase {
  /// Creates use case with repository dependencies.
  UpdateManchePointsUseCase(
    this._mancheRepository,
    this._donneDoubletteRepository,
  );

  final MancheRepository _mancheRepository;
  final DonneDoubletteRepository _donneDoubletteRepository;

  /// Updates deal points and recalculates doublette total.
  Future<void> call({
    required int tableDoubletteId,
    required int donneNumero,
    required int points,
  }) async {
    // Validate points >= 0
    if (points < 0) {
      throw ArgumentError.value(
        points,
        'points',
        'Points must be >= 0',
      );
    }

    // Update deal points
    await _donneDoubletteRepository.updateDonneDoublette(
      tableDoubletteId: tableDoubletteId,
      donneNumero: donneNumero,
      points: points,
    );

    // Calculate total from all deals for this doublette in this table
    final totalPoints = await _donneDoubletteRepository
        .calculateTotalPointsFromDeals(tableDoubletteId: tableDoubletteId);

    // Update stored points on table_doublettes (for compatibility/display)
    await _mancheRepository.updatePoints(
      tableDoubletteId: tableDoubletteId,
      points: totalPoints,
    );

    // Recalculate and persist total points for doublette across all tables/manches
    await _mancheRepository.recalculateDoubletteTotalPoints(tableDoubletteId);
  }
}
