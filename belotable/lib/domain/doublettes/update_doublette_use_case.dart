import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_exceptions.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';

/// Updates an existing doublette.
class UpdateDoubletteUseCase {
  /// Creates use case with repository dependency.
  UpdateDoubletteUseCase(this._repository);

  final DoubletteRepository _repository;

  /// Validates and persists updates.
  Future<Doublette> call({
    required String concoursId,
    required int doubletteId,
    required String joueurA,
    required String joueurB,
    required String nomEquipe,
  }) async {
    final trimmedConcoursId = concoursId.trim();
    final trimmedJoueurA = joueurA.trim();
    final trimmedJoueurB = joueurB.trim();
    final trimmedNomEquipe = nomEquipe.trim();

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
    if (trimmedJoueurA.isEmpty) {
      throw ArgumentError.value(joueurA, 'joueurA', 'joueurA required');
    }
    if (trimmedJoueurB.isEmpty) {
      throw ArgumentError.value(joueurB, 'joueurB', 'joueurB required');
    }
    if (trimmedNomEquipe.isEmpty) {
      throw ArgumentError.value(
        nomEquipe,
        'nomEquipe',
        'nomEquipe required',
      );
    }

    final exists = await _repository.findById(
      concoursId: trimmedConcoursId,
      doubletteId: doubletteId,
    );
    if (exists == null) {
      throw ArgumentError.value(
        doubletteId,
        'doubletteId',
        'doublette introuvable',
      );
    }

    final duplicate = await _repository.teamNameExists(
      concoursId: trimmedConcoursId,
      nomEquipe: trimmedNomEquipe,
      excludingId: exists.id,
    );
    if (duplicate) {
      throw DuplicateTeamNameException(trimmedNomEquipe);
    }

    final doublette = Doublette(
      id: exists.id,
      concoursId: trimmedConcoursId,
      doubletteId: doubletteId,
      joueurA: trimmedJoueurA,
      joueurB: trimmedJoueurB,
      nomEquipe: trimmedNomEquipe,
    );

    return _repository.update(doublette);
  }
}
