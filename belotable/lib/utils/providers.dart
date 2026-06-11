import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/data/repositories/drift_concours_repository.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/concours/create_concours_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dependency injection providers for database, repositories, and use cases.

/// Provides singleton Drift database instance.
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provides ConcoursRepository bound to database.
final concoursRepositoryProvider = Provider<ConcoursRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return DriftConcoursRepository(db);
});

/// Provides CreateConcoursUseCase with repository dependency.
final createConcoursUseCaseProvider = Provider<CreateConcoursUseCase>((ref) {
  final repo = ref.watch(concoursRepositoryProvider);
  return CreateConcoursUseCase(repo);
});

/// Provides concours list sorted by date desc for list screen.
/// autoDispose: disposes when list page leaves stack, re-fetches on re-entry.
// ignore: specify_nonobvious_property_types
final concoursListProvider = FutureProvider.autoDispose<List<Concours>>((ref) {
  final repo = ref.watch(concoursRepositoryProvider);
  return repo.findAllByDateDesc();
});
