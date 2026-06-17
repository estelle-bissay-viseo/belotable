import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/concours/default_game_rules.dart';
import 'package:uuid/uuid.dart';

/// Use case for creating new Concours entities in the repository.
class CreateConcoursUseCase {
  /// Creates a new use case with the given repository.
  CreateConcoursUseCase(this._concoursRepository);

  final ConcoursRepository _concoursRepository;
  final Uuid _uuid = const Uuid();

  /// Creates a new Concours with the provided details,
  /// saves it to the repository, and returns the created entity.
  Future<Concours> call({
    required DateTime date,
    required String lieu,
    required String organisateur,
    int nombreDonnesParManche = 10,
    int nombreMaxPointsParDonne = 162,
    String? reglesJeu,
  }) async {
    final trimmedLieu = lieu.trim();
    final trimmedOrganisateur = organisateur.trim();

    if (trimmedLieu.isEmpty) {
      throw ArgumentError.value(lieu, 'lieu', 'Lieu must not be empty');
    }

    if (trimmedOrganisateur.isEmpty) {
      throw ArgumentError.value(
        organisateur,
        'organisateur',
        'Organisateur must not be empty',
      );
    }

    if (nombreDonnesParManche < 1) {
      throw ArgumentError.value(
        nombreDonnesParManche,
        'nombreDonnesParManche',
        'Must be at least 1',
      );
    }

    if (nombreMaxPointsParDonne < 0) {
      throw ArgumentError.value(
        nombreMaxPointsParDonne,
        'nombreMaxPointsParDonne',
        'Must be at least 0',
      );
    }

    final concours = Concours(
      id: _uuid.v4(),
      date: DateTime(date.year, date.month, date.day),
      lieu: trimmedLieu,
      organisateur: trimmedOrganisateur,
      nombreDonnesParManche: nombreDonnesParManche,
      nombreMaxPointsParDonne: nombreMaxPointsParDonne,
      reglesJeu: reglesJeu?.trim() ?? defaultGameRules,
    );

    await _concoursRepository.save(concours);

    return concours;
  }
}
