import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/doublettes/create_doublette_use_case.dart';
import 'package:belotable/domain/manches/create_premiere_manche_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_concours_repository.dart';
import '../../helpers/in_memory_doublette_repository.dart';
import '../../helpers/in_memory_manche_repository.dart';
import '../../helpers/test_utils.dart';

typedef _Deps = ({
  InMemoryDoubletteRepository doubletteRepository,
  InMemoryMancheRepository mancheRepository,
  InMemoryConcoursRepository concoursRepository,
});

void main() {
  group('CreatePremiereMancheUseCase', () {
    useCaseTest<_Deps, CreatePremiereMancheUseCase>(
      'creates first manche and distributes doublettes by registration order',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreatePremiereMancheUseCase(
        deps.doubletteRepository,
        deps.mancheRepository,
        deps.concoursRepository,
      ),
      body: (deps, useCase) async {
        final createDoublette = CreateDoubletteUseCase(
          deps.doubletteRepository,
        );
        await createDoublette(
          concoursId: 'c-1',
          joueurA: 'A1',
          joueurB: 'B1',
          nomEquipe: 'E1',
        );
        await createDoublette(
          concoursId: 'c-1',
          joueurA: 'A2',
          joueurB: 'B2',
          nomEquipe: 'E2',
        );
        await createDoublette(
          concoursId: 'c-1',
          joueurA: 'A3',
          joueurB: 'B3',
          nomEquipe: 'E3',
        );

        final manche = await useCase('c-1');
        final tables = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche.id,
        );

        expect(manche.numero, 1);
        expect(tables, hasLength(2));
        expect(tables[0].doublettes.map((d) => d.doubletteId).toList(), [1, 2]);
        expect(tables[1].doublettes.map((d) => d.doubletteId).toList(), [3]);
      },
    );

    useCaseTest<_Deps, CreatePremiereMancheUseCase>(
      'throws when no doublette registered',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreatePremiereMancheUseCase(
        deps.doubletteRepository,
        deps.mancheRepository,
        deps.concoursRepository,
      ),
      body: (_, useCase) async {
        await expectLater(
          () => useCase('c-1'),
          throwsA(isA<Exception>()),
        );
      },
    );

    useCaseTest<_Deps, CreatePremiereMancheUseCase>(
      'updates concours status to EnCours after creating first manche',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreatePremiereMancheUseCase(
        deps.doubletteRepository,
        deps.mancheRepository,
        deps.concoursRepository,
      ),
      body: (deps, useCase) async {
        // Create initial concours in repository
        await deps.concoursRepository.save(
          Concours(
            id: 'c-status',
            date: DateTime(2026, 6, 8),
            lieu: 'Salle',
            organisateur: 'Club',
          ),
        );

        // Verify initial status is Initialisation
        var concours = await deps.concoursRepository.findById('c-status');
        expect(
          concours?.statutConcours.toString(),
          equalsIgnoringCase('ConcoursStatut.initialisation'),
        );

        // Create doublettes
        final createDoublette = CreateDoubletteUseCase(
          deps.doubletteRepository,
        );
        await createDoublette(
          concoursId: 'c-status',
          joueurA: 'A1',
          joueurB: 'B1',
          nomEquipe: 'E1',
        );

        // Create first manche
        await useCase('c-status');

        // Verify status changed to EnCours
        concours = await deps.concoursRepository.findById('c-status');
        expect(
          concours?.statutConcours.toString(),
          equalsIgnoringCase('ConcoursStatut.enCours'),
        );
      },
    );
  });
}
