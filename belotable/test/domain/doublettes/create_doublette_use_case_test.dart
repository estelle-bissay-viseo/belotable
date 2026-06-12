import 'package:belotable/domain/doublettes/create_doublette_use_case.dart';
import 'package:belotable/domain/doublettes/doublette_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_doublette_repository.dart';
import '../../helpers/test_utils.dart';

typedef _CreateDoubletteDeps = ({
  InMemoryDoubletteRepository repository,
});

void main() {
  group('CreateDoubletteUseCase', () {
    useCaseTest<_CreateDoubletteDeps, CreateDoubletteUseCase>(
      'creates doublette with trimmed values',
      dependenciesFactory: () => (
        repository: InMemoryDoubletteRepository(),
      ),
      useCaseFactory: (deps) => CreateDoubletteUseCase(deps.repository),
      body: (deps, useCase) async {
        final created = await useCase(
          concoursId: 'concours-1',
          joueurA: '  Alice  ',
          joueurB: '  Bob  ',
          nomEquipe: '  Les As  ',
        );

        expect(created.doubletteId, 1);
        expect(created.joueurA, 'Alice');
        expect(created.joueurB, 'Bob');
        expect(created.nomEquipe, 'Les As');
      },
    );

    useCaseTest<_CreateDoubletteDeps, CreateDoubletteUseCase>(
      'throws when team name already exists in same concours',
      dependenciesFactory: () => (
        repository: InMemoryDoubletteRepository(),
      ),
      useCaseFactory: (deps) => CreateDoubletteUseCase(deps.repository),
      body: (deps, useCase) async {
        await useCase(
          concoursId: 'concours-1',
          joueurA: 'Alice',
          joueurB: 'Bob',
          nomEquipe: 'Les As',
        );

        await expectLater(
          () => useCase(
            concoursId: 'concours-1',
            joueurA: 'Eve',
            joueurB: 'Max',
            nomEquipe: 'Les As',
          ),
          throwsA(isA<DuplicateTeamNameException>()),
        );
      },
    );

    useCaseTest<_CreateDoubletteDeps, CreateDoubletteUseCase>(
      'throws when team name differs only by case in same concours',
      dependenciesFactory: () => (
        repository: InMemoryDoubletteRepository(),
      ),
      useCaseFactory: (deps) => CreateDoubletteUseCase(deps.repository),
      body: (deps, useCase) async {
        await useCase(
          concoursId: 'concours-1',
          joueurA: 'Alice',
          joueurB: 'Bob',
          nomEquipe: 'Les As',
        );

        await expectLater(
          () => useCase(
            concoursId: 'concours-1',
            joueurA: 'Eve',
            joueurB: 'Max',
            nomEquipe: 'les as',
          ),
          throwsA(isA<DuplicateTeamNameException>()),
        );
      },
    );
  });
}
