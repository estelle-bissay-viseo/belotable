import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/manches/manche_repository.dart';

/// Updates points for a doublette in a table and recalculates total points.
class UpdateManchePointsUseCase {
  /// Creates use case with repository dependencies.
  UpdateManchePointsUseCase(this._mancheRepository, this._doubletteRepository);

  final MancheRepository _mancheRepository;
  final DoubletteRepository _doubletteRepository;

  /// Updates points and recalculates doublette total.
  Future<void> call({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int points,
  }) async {
    await _mancheRepository.updatePoints(
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      points: points,
    );

    // Recalculate and persist total points for doublette
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
