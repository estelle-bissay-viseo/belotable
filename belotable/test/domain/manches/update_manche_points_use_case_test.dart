import 'package:belotable/domain/manches/update_manche_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_deal_points_repository.dart';
import '../../helpers/in_memory_doublette_repository.dart';
import '../../helpers/in_memory_manche_repository.dart';

void main() {
  group('UpdateManchePointsUseCase', () {
    test('updates deal points and calculates total', () async {
      const concoursId = 'concours1';
      const doubletteId = 1;
      const dealNumber = 1;

      final mancheRepo = InMemoryMancheRepository();
      final doubletteRepo = InMemoryDoubletteRepository();
      final dealPointsRepo = InMemoryDealPointsRepository();

      // Setup: create doublette with totalPoints = 0
      await doubletteRepo.create(
        concoursId: concoursId,
        joueurA: 'Alice',
        joueurB: 'Bob',
        nomEquipe: 'Team A',
      );

      // Create premiere manche
      final doublettes = await doubletteRepo.findByConcoursId(concoursId);
      final manche = await mancheRepo.createPremiereManche(
        concoursId: concoursId,
        doublettes: doublettes,
      );

      // Initialize deal points
      await mancheRepo.initializeDealPointsForManche(
        mancheId: manche.id,
        concoursId: concoursId,
        numberOfDeals: 10,
      );

      // Get the table doublette
      final tables = await mancheRepo.findTablesDeJeuByMancheId(manche.id);
      expect(tables, isNotEmpty);
      final tableDoublette = tables.first.doublettes.first;
      expect(tableDoublette.points, 0);

      // Use case: update deal points
      final useCase = UpdateManchePointsUseCase(
        mancheRepo,
        doubletteRepo,
        dealPointsRepo,
      );
      await useCase(
        tableDoubletteId: tableDoublette.id,
        concoursId: concoursId,
        doubletteId: doubletteId,
        dealNumber: dealNumber,
        points: 50,
      );

      // Verify deal points updated
      final dealPoints = await dealPointsRepo.findDealPointsForTableDoublette(
        tableDoubletteId: tableDoublette.id,
      );
      expect(dealPoints[dealNumber - 1].points, 50);

      // Verify total points updated on table doublette
      final updatedTableDoublette = await mancheRepo.findTableDoublette(
        concoursId: concoursId,
        doubletteId: doubletteId,
      );
      expect(updatedTableDoublette?.points, 50);

      // Verify totalPoints updated on doublette
      final updatedDoublette = await doubletteRepo.findById(
        concoursId: concoursId,
        doubletteId: doubletteId,
      );
      expect(updatedDoublette?.totalPoints, 50);
    });

    test('rejects negative deal points', () async {
      const concoursId = 'concours2';
      const doubletteId = 1;

      final mancheRepo = InMemoryMancheRepository();
      final doubletteRepo = InMemoryDoubletteRepository();
      final dealPointsRepo = InMemoryDealPointsRepository();

      // Setup
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

      await mancheRepo.initializeDealPointsForManche(
        mancheId: manche.id,
        concoursId: concoursId,
        numberOfDeals: 10,
      );

      final tables = await mancheRepo.findTablesDeJeuByMancheId(manche.id);
      final tableDoublette = tables.first.doublettes.first;

      // Use case: try to set negative points
      final useCase = UpdateManchePointsUseCase(
        mancheRepo,
        doubletteRepo,
        dealPointsRepo,
      );
      expect(
        () => useCase(
          tableDoubletteId: tableDoublette.id,
          concoursId: concoursId,
          doubletteId: doubletteId,
          dealNumber: 1,
          points: -10,
        ),
        throwsArgumentError,
      );
    });
  });
}
