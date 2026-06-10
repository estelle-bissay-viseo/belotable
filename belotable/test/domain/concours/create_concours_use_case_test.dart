import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/concours/create_concours_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_utils.dart';

class _InMemoryConcoursRepository implements ConcoursRepository {
  final savedConcours = <Concours>[];

  @override
  Future<void> save(Concours concours) async {
    savedConcours.add(concours);
  }
}

typedef _CreateConcoursTestDeps = ({
  _InMemoryConcoursRepository repository,
});

void main() {
  group('CreateConcoursUseCase', () {
    useCaseTest<_CreateConcoursTestDeps, CreateConcoursUseCase>(
      'creates concours and persists trimmed values',
      dependenciesFactory: () => (
        repository: _InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final repository = deps.repository;

        final concours = await useCase(
          date: DateTime(2026, 6, 8, 15, 30),
          lieu: '  Salle des fetes  ',
          organisateur: '  Association Belote  ',
        );

        expect(repository.savedConcours, hasLength(1));
        expect(concours.id, isNotEmpty);
        expect(concours.date, DateTime(2026, 6, 8));
        expect(concours.lieu, 'Salle des fetes');
        expect(concours.organisateur, 'Association Belote');
      },
    );

    useCaseTest<_CreateConcoursTestDeps, CreateConcoursUseCase>(
      'throws when lieu is empty',
      dependenciesFactory: () => (
        repository: _InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final repository = deps.repository;

        await expectLater(
          () => useCase(
            date: DateTime(2026, 6, 8),
            lieu: '   ',
            organisateur: 'Club',
          ),
          throwsA(isA<ArgumentError>()),
        );
        expect(repository.savedConcours, isEmpty);
      },
    );

    useCaseTest<_CreateConcoursTestDeps, CreateConcoursUseCase>(
      'throws when organisateur is empty',
      dependenciesFactory: () => (
        repository: _InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateConcoursUseCase(deps.repository),
      body: (deps, useCase) async {
        final repository = deps.repository;

        await expectLater(
          () => useCase(
            date: DateTime(2026, 6, 8),
            lieu: 'Salle',
            organisateur: '   ',
          ),
          throwsA(isA<ArgumentError>()),
        );
        expect(repository.savedConcours, isEmpty);
      },
    );
  });
}
