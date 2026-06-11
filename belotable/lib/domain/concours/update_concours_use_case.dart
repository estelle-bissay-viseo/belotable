import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';

/// Use case for updating an existing concours.
class UpdateConcoursUseCase {
  /// Creates use case with repository dependency.
  UpdateConcoursUseCase(this._concoursRepository);

  final ConcoursRepository _concoursRepository;

  /// Updates concours fields and persists them.
  Future<Concours> call({
    required String id,
    required DateTime date,
    required String lieu,
    required String organisateur,
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

    final concours = Concours(
      id: trimmedId,
      date: DateTime(date.year, date.month, date.day),
      lieu: trimmedLieu,
      organisateur: trimmedOrganisateur,
    );

    await _concoursRepository.save(concours);

    return concours;
  }
}
