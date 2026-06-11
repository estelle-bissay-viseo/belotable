import 'package:belotable/domain/concours/concours_repository.dart';

/// Use case for deleting Concours entities from the repository.
class DeleteConcoursUseCase {
  /// Creates a new use case with the given repository.
  DeleteConcoursUseCase(this._concoursRepository);

  final ConcoursRepository _concoursRepository;

  /// Deletes a Concours with the provided id.
  /// Returns true if deletion was successful, false if concours not found.
  /// Throws exception if deletion fails due to database error.
  Future<bool> call(String id) async {
    if (id.isEmpty) {
      throw ArgumentError.value(id, 'id', 'id must not be empty');
    }

    return _concoursRepository.delete(id);
  }
}
