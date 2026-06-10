import 'package:belotable/domain/concours/concours.dart';

/// Abstract repository interface for managing Concours entities.
abstract interface class ConcoursRepository {
  /// Saves a Concours entity to the repository.
  Future<void> save(Concours concours);
}
