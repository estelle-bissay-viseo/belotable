import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/delete_concours_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_concours_repository.dart';
import '../../helpers/test_utils.dart';

typedef _DeleteConcoursTestDeps = ({
  InMemoryConcoursRepository repository,
});

void main() {
  group('DeleteConcoursUseCase', () {
    useCaseTest<_DeleteConcoursTestDeps, DeleteConcoursUseCase>(
      'deletes concours and returns true',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => DeleteConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final repository = deps.repository;
        final concours = Concours(
          id: 'test-id-1',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle des fetes',
          organisateur: 'Association',
        );

        await repository.save(concours);
        expect(repository.savedConcours, hasLength(1));

        final result = await useCase('test-id-1');

        expect(result, isTrue);
        expect(repository.savedConcours, isEmpty);
      },
    );

    useCaseTest<_DeleteConcoursTestDeps, DeleteConcoursUseCase>(
      'returns false when concours not found',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => DeleteConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final result = await useCase('nonexistent-id');

        expect(result, isFalse);
      },
    );

    useCaseTest<_DeleteConcoursTestDeps, DeleteConcoursUseCase>(
      'throws ArgumentError when id is empty',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => DeleteConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        await expectLater(
          () => useCase(''),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
