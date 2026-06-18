import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/concours/concours_statut.dart';

/// Use case for updating an existing concours.
class UpdateConcoursUseCase {
  /// Creates use case with repository dependency.
  UpdateConcoursUseCase(this._concoursRepository);

  final ConcoursRepository _concoursRepository;

  /// Updates concours fields and persists them.
  /// Only editable if status is Initialisation.
  Future<Concours> call({
    required String id,
    required DateTime date,
    required String lieu,
    required String organisateur,
    int? nombreDonnesParManche,
    int? nombreMaxPointsParDonne,
    String? reglesJeu,
  }) async {
    final trimmedId = id.trim();
    final trimmedLieu = lieu.trim();
    final trimmedOrganisateur = organisateur.trim();

    if (trimmedId.isEmpty) {
      throw ArgumentError.value(id, 'id', 'id must not be empty');
    }
    if (trimmedLieu.isEmpty) {
      throw ArgumentError.value(lieu, 'lieu', 'lieu must not be empty');
    }
    if (trimmedOrganisateur.isEmpty) {
      throw ArgumentError.value(
        organisateur,
        'organisateur',
        'organisateur must not be empty',
      );
    }

    // Load current concours to check status & preserve values
    final currentConcours = await _concoursRepository.findById(trimmedId);
    if (currentConcours == null) {
      throw StateError('Concours $trimmedId not found');
    }

    // If status != Initialisation, preserve params
    final isEditable =
        currentConcours.statutConcours == ConcoursStatut.initialisation;

    final concours = Concours(
      id: trimmedId,
      date: DateTime(date.year, date.month, date.day),
      lieu: trimmedLieu,
      organisateur: trimmedOrganisateur,
      nombreDonnesParManche: isEditable
          ? (nombreDonnesParManche ?? currentConcours.nombreDonnesParManche)
          : currentConcours.nombreDonnesParManche,
      nombreMaxPointsParDonne: isEditable
          ? (nombreMaxPointsParDonne ?? currentConcours.nombreMaxPointsParDonne)
          : currentConcours.nombreMaxPointsParDonne,
      reglesJeu: isEditable
          ? (reglesJeu?.trim() ?? currentConcours.reglesJeu)
          : currentConcours.reglesJeu,
      statutConcours: currentConcours.statutConcours,
    );

    await _concoursRepository.save(concours);

    return concours;
  }
}
