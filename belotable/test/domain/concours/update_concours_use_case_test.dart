import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/update_concours_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_concours_repository.dart';
import '../../helpers/test_utils.dart';

typedef _UpdateConcoursTestDeps = ({
  InMemoryConcoursRepository repository,
});

void main() {
  group('UpdateConcoursUseCase', () {
    useCaseTest<_UpdateConcoursTestDeps, UpdateConcoursUseCase>(
      'updates concours and persists normalized values',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => UpdateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final repository = deps.repository;
        await repository.save(
          Concours(
            id: 'id-1',
            date: DateTime(2026, 6, 8),
            lieu: 'Salle A',
            organisateur: 'Club A',
          ),
        );

        final updated = await useCase(
          id: ' id-1 ',
          date: DateTime(2026, 6, 9, 12, 30),
          lieu: '  Salle B  ',
          organisateur: '  Club B  ',
        );

        expect(updated.id, 'id-1');
        expect(updated.date, DateTime(2026, 6, 9));
        expect(updated.lieu, 'Salle B');
        expect(updated.organisateur, 'Club B');

        final stored = await repository.findById('id-1');
        expect(stored, updated);
      },
    );

    useCaseTest<_UpdateConcoursTestDeps, UpdateConcoursUseCase>(
      'throws when id is empty',
      dependenciesFactory: () => (
        repository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => UpdateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        await expectLater(
          () => useCase(
            id: '   ',
            date: DateTime(2026, 6, 8),
            lieu: 'Salle',
            organisateur: 'Club',
          ),
          throwsA(isA<ArgumentError>()),
        );
      },
    );
  });
}
