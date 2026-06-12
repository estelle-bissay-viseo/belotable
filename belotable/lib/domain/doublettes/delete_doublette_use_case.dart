import 'package:belotable/domain/doublettes/doublette_repository.dart';

/// Deletes one doublette from a contest.
class DeleteDoubletteUseCase {
  /// Creates use case with repository dependency.
  DeleteDoubletteUseCase(this._repository);

  final DoubletteRepository _repository;

  /// Deletes one row by composite key.
  Future<bool> call({required String concoursId, required int doubletteId}) {
    final trimmedConcoursId = concoursId.trim();
    if (trimmedConcoursId.isEmpty) {
      throw ArgumentError.value(
        concoursId,
        'concoursId',
        'concoursId required',
      );
    }
    if (doubletteId <= 0) {
      throw ArgumentError.value(doubletteId, 'doubletteId', 'doubletteId > 0');
    }

    return _repository.delete(
      concoursId: trimmedConcoursId,
      doubletteId: doubletteId,
    );
  }
}
