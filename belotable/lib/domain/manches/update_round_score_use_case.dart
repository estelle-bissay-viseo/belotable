import 'package:belotable/domain/manches/manche_repository.dart';

/// Updates a directly-entered round score in "par manche" entry mode.
class UpdateRoundScoreUseCase {
  /// Creates use case with repository dependency.
  UpdateRoundScoreUseCase(this._mancheRepository);

  final MancheRepository _mancheRepository;

  /// Updates round score and recalculates doublette total.
  Future<void> call({
    required int tableDoubletteId,
    required int points,
  }) async {
    if (points < 0) {
      throw ArgumentError.value(
        points,
        'points',
        'Points must be >= 0',
      );
    }

    await _mancheRepository.updatePoints(
      tableDoubletteId: tableDoubletteId,
      points: points,
    );

    await _mancheRepository.recalculateDoubletteTotalPoints(tableDoubletteId);
  }
}
