import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
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

    final concours = Concours(
      id: _uuid.v4(),
      date: DateTime(date.year, date.month, date.day),
      lieu: trimmedLieu,
      organisateur: trimmedOrganisateur,
    );

    await _concoursRepository.save(concours);

    return concours;
  }
}
