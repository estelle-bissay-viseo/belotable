import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/doublettes/create_doublette_use_case.dart';
import 'package:belotable/domain/manches/create_next_manche_use_case.dart';
import 'package:belotable/domain/manches/manche_statut.dart';
import 'package:belotable/domain/manches/table_doublette.dart';
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
  group('CreateNextMancheUseCase', () {
    // Create a new manche beyond first, with blocking check if previous
    // manche is not finished.
    useCaseTest<_Deps, CreateNextMancheUseCase>(
      'Creates manche 2 when manche 1 is terminée',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateNextMancheUseCase(
        deps.doubletteRepository,
        deps.mancheRepository,
        deps.concoursRepository,
      ),
      body: (deps, useCase) async {
        final createDoublette = CreateDoubletteUseCase(
          deps.doubletteRepository,
        );

        // Create concours
        final concours = Concours(
          id: 'c-1',
          date: DateTime.now(),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          nombreDoublettes: 2,
          reglesJeu: 'Règles A',
        );
        await deps.concoursRepository.save(concours);

        // Create 2 doublettes
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

        // Create manche 1
        final manche1 = await useCase('c-1');
        expect(manche1.numero, 1);

        // Mark manche 1 as terminée by moving tables to finished state
        final tables1 = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche1.id,
        );
        for (final table in tables1) {
          for (final doublette in table.doublettes) {
            await deps.mancheRepository.updateStatut(
              tableId: table.id,
              concoursId: 'c-1',
              doubletteId: doublette.doubletteId,
              statut: TableDoubletteStatut.gagne,
            );
          }
        }

        // Verify manche 1 is now terminée
        final latestAfterUpdate = await deps.mancheRepository.findLatestManche(
          'c-1',
        );
        expect(latestAfterUpdate?.statut, MancheStatut.termine);

        // Create manche 2
        final manche2 = await useCase('c-1');
        expect(manche2.numero, 2);
        expect(manche2.id, isNot(manche1.id));
      },
    );

    // Block creation if previous manche is not finished.
    useCaseTest<_Deps, CreateNextMancheUseCase>(
      'Blocks creation of manche 2 if manche 1 is en cours',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateNextMancheUseCase(
        deps.doubletteRepository,
        deps.mancheRepository,
        deps.concoursRepository,
      ),
      body: (deps, useCase) async {
        final createDoublette = CreateDoubletteUseCase(
          deps.doubletteRepository,
        );

        // Create concours and doublettes
        final concours = Concours(
          id: 'c-1',
          date: DateTime.now(),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          nombreDoublettes: 2,
          reglesJeu: 'Règles A',
        );
        await deps.concoursRepository.save(concours);

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

        // Create manche 1 (stays in en cours state)
        final manche1 = await useCase('c-1');
        expect(manche1.statut, MancheStatut.enCours);

        // Try to create manche 2 — should throw
        await expectLater(
          () => useCase('c-1'),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('précédente'),
            ),
          ),
        );
      },
    );

    // Deterministic distribution by total points desc, then creation
    // date asc, excluding doublettes with Abandon history.
    useCaseTest<_Deps, CreateNextMancheUseCase>(
      'Distributes doublettes sorted by points desc, then date asc',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateNextMancheUseCase(
        deps.doubletteRepository,
        deps.mancheRepository,
        deps.concoursRepository,
      ),
      body: (deps, useCase) async {
        // Create concours
        final concours = Concours(
          id: 'c-1',
          date: DateTime.now(),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          nombreDoublettes: 4,
          reglesJeu: 'Règles A',
        );
        await deps.concoursRepository.save(concours);

        final createDoublette = CreateDoubletteUseCase(
          deps.doubletteRepository,
        );

        // Create doublettes (registration order: D1, D2, D3, D4)
        await createDoublette(
          concoursId: 'c-1',
          joueurA: 'A1',
          joueurB: 'B1',
          nomEquipe: 'D1',
        );
        await createDoublette(
          concoursId: 'c-1',
          joueurA: 'A2',
          joueurB: 'B2',
          nomEquipe: 'D2',
        );
        await createDoublette(
          concoursId: 'c-1',
          joueurA: 'A3',
          joueurB: 'B3',
          nomEquipe: 'D3',
        );
        await createDoublette(
          concoursId: 'c-1',
          joueurA: 'A4',
          joueurB: 'B4',
          nomEquipe: 'D4',
        );

        // Create manche 1 (distributes by registration order)
        final manche1 = await useCase('c-1');

        // Manually update doublette totalPoints to test sorting:
        // D1=100, D2=50, D3=100, D4=50
        // Expected distribution order for manche 2:
        // [D1 (100, id=1), D3 (100, id=3), D2 (50, id=2), D4 (50, id=4)]
        await deps.doubletteRepository.updateTotalPoints(1, 100);
        await deps.doubletteRepository.updateTotalPoints(2, 50);
        await deps.doubletteRepository.updateTotalPoints(3, 100);
        await deps.doubletteRepository.updateTotalPoints(4, 50);

        // Mark all doublettes in manche 1 as finished
        final tables1 = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche1.id,
        );
        for (final table in tables1) {
          for (final doublette in table.doublettes) {
            await deps.mancheRepository.updateStatut(
              tableId: table.id,
              concoursId: 'c-1',
              doubletteId: doublette.doubletteId,
              statut: TableDoubletteStatut.gagne,
            );
          }
        }

        // Create manche 2 — should distribute in sorted order
        final manche2 = await useCase('c-1');
        final tables2 = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche2.id,
        );

        // Verify distribution order by table + doublette position
        final allInManche2 = <int>[];
        for (final table in tables2) {
          allInManche2.addAll(table.doublettes.map((d) => d.doubletteId));
        }

        // Expected: [D1, D3, D2, D4] (sorted by points desc, id asc)
        expect(allInManche2, [1, 3, 2, 4]);
      },
    );

    // Exclude doublettes with Abandon history from distribution.
    useCaseTest<_Deps, CreateNextMancheUseCase>(
      'Excludes doublettes with Abandon history',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => CreateNextMancheUseCase(
        deps.doubletteRepository,
        deps.mancheRepository,
        deps.concoursRepository,
      ),
      body: (deps, useCase) async {
        // Create concours
        final concours = Concours(
          id: 'c-1',
          date: DateTime.now(),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          nombreDoublettes: 3,
          reglesJeu: 'Règles A',
        );
        await deps.concoursRepository.save(concours);

        // Create 3 doublettes
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

        // Create manche 1
        final manche1 = await useCase('c-1');
        final tables1 = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche1.id,
        );

        // Mark doublette 1 as abandoned
        final table1 = tables1.first;
        final d1 = table1.doublettes.firstWhere((d) => d.doubletteId == 1);
        await deps.mancheRepository.updateStatut(
          tableId: table1.id,
          concoursId: 'c-1',
          doubletteId: d1.doubletteId,
          statut: TableDoubletteStatut.abandon,
        );

        // Mark other doublettes as finished
        for (final table in tables1) {
          for (final doublette in table.doublettes) {
            if (doublette.doubletteId != 1) {
              await deps.mancheRepository.updateStatut(
                tableId: table.id,
                concoursId: 'c-1',
                doubletteId: doublette.doubletteId,
                statut: TableDoubletteStatut.gagne,
              );
            }
          }
        }

        // Create manche 2 — should exclude D1 (abandoned)
        final manche2 = await useCase('c-1');
        final tables2 = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche2.id,
        );

        final allInManche2 = <int>[];
        for (final table in tables2) {
          allInManche2.addAll(table.doublettes.map((d) => d.doubletteId));
        }

        expect(allInManche2, isNot(contains(1)));
        expect(allInManche2, contains(2));
        expect(allInManche2, contains(3));
      },
    );
  });
}
