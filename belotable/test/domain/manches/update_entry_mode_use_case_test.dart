import 'package:belotable/domain/manches/update_entry_mode_use_case.dart';
import 'package:belotable/domain/manches/update_manche_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_donne_doublette_repository.dart';
import '../../helpers/in_memory_doublette_repository.dart';
import '../../helpers/in_memory_manche_repository.dart';

void main() {
  group('UpdateEntryModeUseCase', () {
    Future<
      ({
        InMemoryMancheRepository mancheRepo,
        InMemoryDonneDoubletteRepository donneDoubletteRepo,
        List<int> tableDoubletteIds,
      })
    >
    setUpTable() async {
      const concoursId = 'concours1';

      final doubletteRepo = InMemoryDoubletteRepository();
      final mancheRepo = InMemoryMancheRepository(doubletteRepo);
      final donneDoubletteRepo = InMemoryDonneDoubletteRepository();

      await doubletteRepo.create(
        concoursId: concoursId,
        joueurA: 'Alice',
        joueurB: 'Bob',
        nomEquipe: 'Team A',
      );
      await doubletteRepo.create(
        concoursId: concoursId,
        joueurA: 'Charlie',
        joueurB: 'Diana',
        nomEquipe: 'Team B',
      );

      final doublettes = await doubletteRepo.findByConcoursId(concoursId);
      final manche = await mancheRepo.createPremiereManche(
        concoursId: concoursId,
        doublettes: doublettes,
      );

      await mancheRepo.initializeDonneDoublettesForManche(
        mancheId: manche.id,
        numberOfDeals: 4,
      );

      final tables = await mancheRepo.findTablesDeJeuByMancheId(manche.id);
      final tableDoublettes = tables.first.doublettes;
      for (final td in tableDoublettes) {
        await donneDoubletteRepo.initializeDonneDoublettes(
          tableDoubletteId: td.id,
          numberOfDeals: 4,
        );
      }

      return (
        mancheRepo: mancheRepo,
        donneDoubletteRepo: donneDoubletteRepo,
        tableDoubletteIds: tableDoublettes
            .map((td) => td.id)
            .toList(growable: false),
      );
    }

    test('defaults to "par manche" (pointsParDonnes = false)', () async {
      final setup = await setUpTable();
      final td = await setup.mancheRepo.findTableDoublette(
        doubletteRowId: 1,
      );
      expect(td?.pointsParDonnes, isFalse);
    });

    test(
      'switching to "par donne" recalculates round score from deals',
      () async {
        final setup = await setUpTable();
        final pointsUseCase = UpdateManchePointsUseCase(
          setup.mancheRepo,
          setup.donneDoubletteRepo,
        );

        // Enter deal scores while still in "par manche" is not allowed by
        // the UI, but the repository layer allows it; simulate deals already
        // present before switching mode.
        await pointsUseCase(
          tableDoubletteId: setup.tableDoubletteIds.first,
          donneNumero: 1,
          points: 30,
        );
        await pointsUseCase(
          tableDoubletteId: setup.tableDoubletteIds.first,
          donneNumero: 2,
          points: 20,
        );

        final useCase = UpdateEntryModeUseCase(
          setup.mancheRepo,
          setup.donneDoubletteRepo,
        );
        await useCase(
          tableDoubletteIds: setup.tableDoubletteIds,
          pointsParDonnes: true,
        );

        for (final id in setup.tableDoubletteIds) {
          final td = await setup.mancheRepo.findTableDoublette(
            doubletteRowId: id == setup.tableDoubletteIds.first ? 1 : 2,
          );
          expect(td?.pointsParDonnes, isTrue);
        }

        final updated = await setup.mancheRepo.findTableDoublette(
          doubletteRowId: 1,
        );
        expect(updated?.points, 50);
      },
    );

    test(
      'switching to "par manche" resets deal scores and preserves round '
      'score',
      () async {
        final setup = await setUpTable();
        final target = setup.tableDoubletteIds.first;

        await setup.mancheRepo.updatePoints(
          tableDoubletteId: target,
          points: 75,
        );
        await setup.donneDoubletteRepo.updateDonneDoublette(
          tableDoubletteId: target,
          donneNumero: 1,
          points: 75,
        );

        final useCase = UpdateEntryModeUseCase(
          setup.mancheRepo,
          setup.donneDoubletteRepo,
        );
        await useCase(
          tableDoubletteIds: setup.tableDoubletteIds,
          pointsParDonnes: false,
        );

        final deals = await setup.donneDoubletteRepo
            .findDonneDoublettesForTableDoublette(tableDoubletteId: target);
        expect(deals.every((d) => d.points == 0), isTrue);

        final td = await setup.mancheRepo.findTableDoublette(
          doubletteRowId: 1,
        );
        expect(td?.points, 75);
        expect(td?.pointsParDonnes, isFalse);
      },
    );
  });
}
