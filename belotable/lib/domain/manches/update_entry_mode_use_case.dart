import 'package:belotable/domain/manches/donne_doublette_repository.dart';
import 'package:belotable/domain/manches/manche_repository.dart';

/// Switches score entry mode ("par donne" / "par manche") for a table.
///
/// When switching to "par donne", the round score is recalculated from the
/// sum of deal scores (which stay authoritative in that mode).
/// When switching to "par manche", deal scores are reset to 0 and the
/// previously calculated round score is preserved.
class UpdateEntryModeUseCase {
  /// Creates use case with repository dependencies.
  UpdateEntryModeUseCase(
    this._mancheRepository,
    this._donneDoubletteRepository,
  );

  final MancheRepository _mancheRepository;
  final DonneDoubletteRepository _donneDoubletteRepository;

  /// Applies the new entry mode to every table-doublette of a table.
  Future<void> call({
    required List<int> tableDoubletteIds,
    required bool pointsParDonnes,
  }) async {
    for (final tableDoubletteId in tableDoubletteIds) {
      await _mancheRepository.updateEntryMode(
        tableDoubletteId: tableDoubletteId,
        pointsParDonnes: pointsParDonnes,
      );

      if (pointsParDonnes) {
        final totalPoints = await _donneDoubletteRepository
            .calculateTotalPointsFromDeals(tableDoubletteId: tableDoubletteId);
        await _mancheRepository.updatePoints(
          tableDoubletteId: tableDoubletteId,
          points: totalPoints,
        );
        await _mancheRepository.recalculateDoubletteTotalPoints(
          tableDoubletteId,
        );
      } else {
        await _donneDoubletteRepository.resetDonneDoublettes(
          tableDoubletteId: tableDoubletteId,
        );
      }
    }
  }
}
