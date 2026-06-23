import 'package:belotable/domain/doublettes/create_doublette_use_case.dart';
import 'package:belotable/domain/doublettes/delete_doublette_use_case.dart';
import 'package:belotable/domain/manches/create_premiere_manche_use_case.dart';
import 'package:belotable/domain/manches/manche_exceptions.dart';
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
  group('DeleteDoubletteUseCase', () {
    useCaseTest<_Deps, DeleteDoubletteUseCase>(
      'removes pending doublette from table then deletes it',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => DeleteDoubletteUseCase(
        deps.doubletteRepository,
        mancheRepository: deps.mancheRepository,
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

        final createManche = CreatePremiereMancheUseCase(
          deps.doubletteRepository,
          deps.mancheRepository,
          deps.concoursRepository,
        );
        await createManche('c-1');

        final deleted = await useCase(concoursId: 'c-1', doubletteId: 1);
        expect(deleted, isTrue);

        final remaining = await deps.doubletteRepository.findByConcoursId(
          'c-1',
        );
        expect(remaining.map((d) => d.doubletteId).toList(), [2]);
      },
    );

    useCaseTest<_Deps, DeleteDoubletteUseCase>(
      'throws exception when doublette already in play',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => DeleteDoubletteUseCase(
        deps.doubletteRepository,
        mancheRepository: deps.mancheRepository,
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

        final createManche = CreatePremiereMancheUseCase(
          deps.doubletteRepository,
          deps.mancheRepository,
          deps.concoursRepository,
        );
        final manche = await createManche('c-1');
        final table = (await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche.id,
        )).first;

        await deps.mancheRepository.updateStatut(
          tableId: table.id,
          concoursId: 'c-1',
          doubletteId: 1,
          statut: TableDoubletteStatut.enJeu,
        );

        // Get status before delete attempt
        final tablesBefore = await deps.mancheRepository
            .findTablesDeJeuByMancheId(
              manche.id,
            );
        final tableBefore = tablesBefore.first;
        final d1StatusBefore = tableBefore.doublettes
            .firstWhere((d) => d.doubletteId == 1)
            .statut;
        final d2StatusBefore = tableBefore.doublettes
            .firstWhere((d) => d.doubletteId == 2)
            .statut;

        // Deletion should throw exception
        expect(
          () => useCase(concoursId: 'c-1', doubletteId: 1),
          throwsA(isA<DoubletteDejaJoueeException>()),
        );

        // Status should remain unchanged after failed deletion
        final tablesAfter = await deps.mancheRepository
            .findTablesDeJeuByMancheId(
              manche.id,
            );
        final tableAfter = tablesAfter.first;
        final d1StatusAfter = tableAfter.doublettes
            .firstWhere((d) => d.doubletteId == 1)
            .statut;
        final d2StatusAfter = tableAfter.doublettes
            .firstWhere((d) => d.doubletteId == 2)
            .statut;

        expect(d1StatusAfter, equals(d1StatusBefore));
        expect(d2StatusAfter, equals(d2StatusBefore));
      },
    );

    useCaseTest<_Deps, DeleteDoubletteUseCase>(
      'merges tables when both have single doublette in enAttente status',
      dependenciesFactory: () => (
        doubletteRepository: InMemoryDoubletteRepository(),
        mancheRepository: InMemoryMancheRepository(),
        concoursRepository: InMemoryConcoursRepository(),
      ),
      useCaseFactory: (deps) => DeleteDoubletteUseCase(
        deps.doubletteRepository,
        mancheRepository: deps.mancheRepository,
      ),
      body: (deps, useCase) async {
        final createDoublette = CreateDoubletteUseCase(
          deps.doubletteRepository,
        );
        // Create 4 doublettes to form 2 tables
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
        await createDoublette(
          concoursId: 'c-1',
          joueurA: 'A4',
          joueurB: 'B4',
          nomEquipe: 'E4',
        );

        final createManche = CreatePremiereMancheUseCase(
          deps.doubletteRepository,
          deps.mancheRepository,
          deps.concoursRepository,
        );
        final manche = await createManche('c-1');

        var tables = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche.id,
        );
        expect(tables, hasLength(2));
        expect(tables[0].doublettes, hasLength(2));
        expect(tables[1].doublettes, hasLength(2));

        // Delete from first table to leave 1 doublette
        final table1Id = tables[0].id;
        final table2Id = tables[1].id;
        final doublette2Id = tables[0].doublettes[1].doubletteId;
        final doublette3Id = tables[1].doublettes[0].doubletteId;

        await useCase(concoursId: 'c-1', doubletteId: doublette2Id);

        tables = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche.id,
        );
        expect(tables, hasLength(2)); // Still 2 tables
        expect(tables[0].doublettes, hasLength(1));
        expect(tables[1].doublettes, hasLength(2));

        // Delete from second table to leave 1 doublette
        // This should trigger merge
        await useCase(concoursId: 'c-1', doubletteId: doublette3Id);

        tables = await deps.mancheRepository.findTablesDeJeuByMancheId(
          manche.id,
        );
        // After merge: only 1 table should remain
        expect(tables, hasLength(1));
        // The table should have the smaller ID
        expect(tables[0].id, equals(min(table1Id, table2Id)));
        // The table should contain 2 doublettes (1 from each original table)
        expect(tables[0].doublettes, hasLength(2));
      },
    );
  });
}

int min(int a, int b) => a < b ? a : b;
