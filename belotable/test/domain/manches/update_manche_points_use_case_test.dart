import 'package:belotable/domain/manches/update_manche_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test/helpers/in_memory_doublette_repository.dart';
import '../../../test/helpers/in_memory_manche_repository.dart';

void main() {
  group('UpdateManchePointsUseCase', () {
    test('updates points for a doublette and recalculates total', () async {
      const concoursId = 'concours1';
      const doubletteId = 1;

      final mancheRepo = InMemoryMancheRepository();
      final doubletteRepo = InMemoryDoubletteRepository();

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

      // Get the table doublette
      final tables = await mancheRepo.findTablesDeJeuByMancheId(manche.id);
      expect(tables, isNotEmpty);
      final tableDoublette = tables.first.doublettes.first;
      expect(tableDoublette.points, 0);

      // Use case: update points
      final useCase = UpdateManchePointsUseCase(mancheRepo, doubletteRepo);
      await useCase(
        tableId: tableDoublette.tableId,
        concoursId: concoursId,
        doubletteId: doubletteId,
        points: 250,
      );

      // Verify points updated
      final updatedTableDoublette = await mancheRepo.findTableDoublette(
        concoursId: concoursId,
        doubletteId: doubletteId,
      );
      expect(updatedTableDoublette?.points, 250);

      // Verify totalPoints updated on doublette
      final updatedDoublette = await doubletteRepo.findById(
        concoursId: concoursId,
        doubletteId: doubletteId,
      );
      expect(updatedDoublette?.totalPoints, 250);
    });

    test('recalculates total when updating existing points', () async {
      const concoursId = 'concours2';

      final mancheRepo = InMemoryMancheRepository();
      final doubletteRepo = InMemoryDoubletteRepository();

      // Setup
      await doubletteRepo.create(
        concoursId: concoursId,
        joueurA: 'Charlie',
        joueurB: 'Diana',
        nomEquipe: 'Team B',
      );

      final doublettes = await doubletteRepo.findByConcoursId(concoursId);
      final doubletteId = doublettes.first.doubletteId;

      final manche = await mancheRepo.createPremiereManche(
        concoursId: concoursId,
        doublettes: doublettes,
      );

      final tables = await mancheRepo.findTablesDeJeuByMancheId(manche.id);
      final tableDoublette = tables.first.doublettes.first;

      // First update
      final useCase = UpdateManchePointsUseCase(mancheRepo, doubletteRepo);
      await useCase(
        tableId: tableDoublette.tableId,
        concoursId: concoursId,
        doubletteId: doubletteId,
        points: 300,
      );

      var doublette = await doubletteRepo.findById(
        concoursId: concoursId,
        doubletteId: doubletteId,
      );
      expect(doublette?.totalPoints, 300);

      // Second update (change points)
      await useCase(
        tableId: tableDoublette.tableId,
        concoursId: concoursId,
        doubletteId: doubletteId,
        points: 450,
      );

      doublette = await doubletteRepo.findById(
        concoursId: concoursId,
        doubletteId: doubletteId,
      );
      expect(doublette?.totalPoints, 450);
    });
  });
}
