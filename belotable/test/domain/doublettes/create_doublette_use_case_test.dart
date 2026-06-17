import 'package:belotable/domain/doublettes/create_doublette_use_case.dart';
import 'package:belotable/domain/doublettes/doublette_exceptions.dart';
import 'package:belotable/domain/manches/create_premiere_manche_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_concours_repository.dart';
import '../../helpers/in_memory_doublette_repository.dart';
import '../../helpers/in_memory_manche_repository.dart';
import '../../helpers/test_utils.dart';

typedef _CreateDoubletteDeps = ({
  InMemoryDoubletteRepository repository,
  InMemoryMancheRepository mancheRepository,
  InMemoryConcoursRepository concoursRepository,
});

void main() {
  group('CreateDoubletteUseCase', () {
    useCaseTest<_CreateDoubletteDeps, CreateDoubletteUseCase>(
      'creates doublette with trimmed values',
      dependenciesFactory: () => (
        repository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateDoubletteUseCase(
        deps.repository,
        mancheRepository: deps.mancheRepository,
      ),
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
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateDoubletteUseCase(
        deps.repository,
        mancheRepository: deps.mancheRepository,
      ),
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
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateDoubletteUseCase(
        deps.repository,
        mancheRepository: deps.mancheRepository,
      ),
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

    useCaseTest<_CreateDoubletteDeps, CreateDoubletteUseCase>(
      'fills existing partial table in latest manche after create',
      dependenciesFactory: () => (
        repository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateDoubletteUseCase(
        deps.repository,
        mancheRepository: deps.mancheRepository,
      ),
      body: (deps, useCase) async {
        await deps.repository.create(
          concoursId: 'concours-1',
          joueurA: 'A1',
          joueurB: 'B1',
          nomEquipe: 'E1',
        );
        await deps.repository.create(
          concoursId: 'concours-1',
          joueurA: 'A2',
          joueurB: 'B2',
          nomEquipe: 'E2',
        );
        await deps.repository.create(
          concoursId: 'concours-1',
          joueurA: 'A3',
          joueurB: 'B3',
          nomEquipe: 'E3',
        );

        final createManche = CreatePremiereMancheUseCase(
          deps.repository,
          deps.mancheRepository,
          deps.concoursRepository,
        );
        final manche = await createManche('concours-1');

        await useCase(
          concoursId: 'concours-1',
          joueurA: 'A4',
          joueurB: 'B4',
          nomEquipe: 'E4',
        );

        final tables = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche.id,
        );
        expect(tables, hasLength(2));
        expect(tables.first.doublettes, hasLength(2));
        expect(tables.last.doublettes, hasLength(2));
      },
    );

    useCaseTest<_CreateDoubletteDeps, CreateDoubletteUseCase>(
      'creates new table in latest manche when all tables are full',
      dependenciesFactory: () => (
        repository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateDoubletteUseCase(
        deps.repository,
        mancheRepository: deps.mancheRepository,
      ),
      body: (deps, useCase) async {
        await deps.repository.create(
          concoursId: 'concours-2',
          joueurA: 'A1',
          joueurB: 'B1',
          nomEquipe: 'E1',
        );
        await deps.repository.create(
          concoursId: 'concours-2',
          joueurA: 'A2',
          joueurB: 'B2',
          nomEquipe: 'E2',
        );

        final createManche = CreatePremiereMancheUseCase(
          deps.repository,
          deps.mancheRepository,
          deps.concoursRepository,
        );
        final manche = await createManche('concours-2');

        await useCase(
          concoursId: 'concours-2',
          joueurA: 'A3',
          joueurB: 'B3',
          nomEquipe: 'E3',
        );

        final tables = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche.id,
        );
        expect(tables, hasLength(2));
        expect(tables.first.doublettes, hasLength(2));
        expect(tables.last.doublettes, hasLength(1));
        expect(tables.last.doublettes.single.doubletteId, 3);
      },
    );
  });
}
