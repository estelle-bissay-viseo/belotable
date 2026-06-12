import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/manche_repository.dart';

/// Creates the first round for a concours from registered doublettes.
class CreatePremiereMancheUseCase {
  /// Creates use case with required dependencies.
  CreatePremiereMancheUseCase(
    this._doubletteRepository,
    this._mancheRepository,
  );

  final DoubletteRepository _doubletteRepository;
  final MancheRepository _mancheRepository;

  /// Validates preconditions and creates the first manche.
  ///
  /// Throws [Exception] if no doublettes registered or manche already exists.
  Future<Manche> call(String concoursId) async {
    final trimmedId = concoursId.trim();
    if (trimmedId.isEmpty) {
      throw ArgumentError.value(
        concoursId,
        'concoursId',
        'concoursId required',
      );
    }

    final alreadyExists = await _mancheRepository.mancheExistsPourConcours(
      trimmedId,
    );
    if (alreadyExists) {
      throw Exception('Une manche existe déjà pour ce concours.');
    }

    final doublettes = await _doubletteRepository.findByConcoursId(trimmedId);
    if (doublettes.isEmpty) {
      throw Exception('Aucune doublette enregistrée pour créer une manche.');
    }

    return _mancheRepository.createPremiereManche(
      concoursId: trimmedId,
      doublettes: doublettes,
    );
  }
}
