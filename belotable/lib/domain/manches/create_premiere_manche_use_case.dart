import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/concours/concours_statut.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/manche_repository.dart';

/// Creates the first round for a concours from registered doublettes.
class CreatePremiereMancheUseCase {
  /// Creates use case with required dependencies.
  CreatePremiereMancheUseCase(
    this._doubletteRepository,
    this._mancheRepository,
    this._concoursRepository,
  );

  final DoubletteRepository _doubletteRepository;
  final MancheRepository _mancheRepository;
  final ConcoursRepository _concoursRepository;

  /// Validates preconditions and creates the first manche.
  ///
  /// Also updates concours status from Initialisation to EnCours.
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

    // Create manche
    final manche = await _mancheRepository.createPremiereManche(
      concoursId: trimmedId,
      doublettes: doublettes,
    );

    // Update concours status to EnCours
    final concours = await _concoursRepository.findById(trimmedId);
    if (concours != null &&
        concours.statutConcours == ConcoursStatut.initialisation) {
      final updatedConcours = Concours(
        id: concours.id,
        date: concours.date,
        lieu: concours.lieu,
        organisateur: concours.organisateur,
        nombreDonnesParManche: concours.nombreDonnesParManche,
        nombreDoublettes: concours.nombreDoublettes,
        reglesJeu: concours.reglesJeu,
        statutConcours: ConcoursStatut.enCours,
      );
      await _concoursRepository.save(updatedConcours);
    }

    return manche;
  }
}
