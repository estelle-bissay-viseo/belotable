import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/manches/deal_points_repository.dart';
import 'package:belotable/domain/manches/manche_repository.dart';

/// Updates deal points for a doublette in a table
/// and recalculates total points.
class UpdateManchePointsUseCase {
  /// Creates use case with repository dependencies.
  UpdateManchePointsUseCase(
    this._mancheRepository,
    this._doubletteRepository,
    this._dealPointsRepository,
  );

  final MancheRepository _mancheRepository;
  final DoubletteRepository _doubletteRepository;
  final DealPointsRepository _dealPointsRepository;

  /// Updates deal points and recalculates doublette total.
  Future<void> call({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int mancheId,
    required int dealNumber,
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
    await _dealPointsRepository.updateDealPoints(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      mancheId: mancheId,
      dealNumber: dealNumber,
      points: points,
    );

    // Calculate total from all deals for this doublette in this table
    final totalPoints = await _dealPointsRepository
        .calculateTotalPointsFromDeals(
          tableId: tableId,
          concoursId: concoursId,
          doubletteId: doubletteId,
          mancheId: mancheId,
        );

    // Update stored points on table_doublettes (for compatibility/display)
    await _mancheRepository.updatePoints(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      points: totalPoints,
    );

    // Recalculate and persist total points for doublette across all tables/manches
    await _updateDoubletteTotal(
      concoursId: concoursId,
      doubletteId: doubletteId,
    );
  }

  Future<void> _updateDoubletteTotal({
    required String concoursId,
    required int doubletteId,
  }) async {
    final allTableDoublettes = await _mancheRepository
        .findTableDoublettesByDoubletteId(
          concoursId: concoursId,
          doubletteId: doubletteId,
        );
    final totalPoints = allTableDoublettes.fold<int>(
      0,
      (sum, td) => sum + td.points,
    );

    final doublette = await _doubletteRepository.findById(
      concoursId: concoursId,
      doubletteId: doubletteId,
    );
    if (doublette != null) {
      final updatedDoublette = Doublette(
        concoursId: doublette.concoursId,
        doubletteId: doublette.doubletteId,
        joueurA: doublette.joueurA,
        joueurB: doublette.joueurB,
        nomEquipe: doublette.nomEquipe,
        totalPoints: totalPoints,
      );
      await _doubletteRepository.update(updatedDoublette);
    }
  }
}
