import 'package:belotable/domain/manches/update_manche_points_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_donne_doublette_repository.dart';
import '../../helpers/in_memory_doublette_repository.dart';
import '../../helpers/in_memory_manche_repository.dart';

void main() {
  group('UpdateManchePointsUseCase', () {
    test('updates deal points and calculates total', () async {
      const concoursId = 'concours1';
      const donneNumero = 1;

      final doubletteRepo = InMemoryDoubletteRepository();
      final mancheRepo = InMemoryMancheRepository(doubletteRepo);
      final donneDoubletteRepo = InMemoryDonneDoubletteRepository();

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

      // Initialize donnes doublettes
      await mancheRepo.initializeDonneDoublettesForManche(
        mancheId: manche.id,
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
        donneDoubletteRepo,
      );
      await useCase(
        tableDoubletteId: tableDoublette.id,
        donneNumero: donneNumero,
        points: 50,
      );

      // Verify deal points updated
      final donneDoublettes = await donneDoubletteRepo
          .findDonneDoublettesForTableDoublette(
            tableDoubletteId: tableDoublette.id,
          );
      expect(donneDoublettes[donneNumero - 1].points, 50);

      // Verify total points updated on table doublette
      final updatedTableDoublette = await mancheRepo.findTableDoublette(
        doubletteRowId: doublettes.first.id,
      );
      expect(updatedTableDoublette?.points, 50);

      // Verify totalPoints updated on doublette
      final updatedDoublette = await doubletteRepo.findById(
        concoursId: concoursId,
        doubletteId: doublettes.first.doubletteId,
      );
      expect(updatedDoublette?.totalPoints, 50);
    });

    test('rejects negative deal points', () async {
      const concoursId = 'concours2';

      final doubletteRepo = InMemoryDoubletteRepository();
      final mancheRepo = InMemoryMancheRepository(doubletteRepo);
      final donneDoubletteRepo = InMemoryDonneDoubletteRepository();

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

      await mancheRepo.initializeDonneDoublettesForManche(
        mancheId: manche.id,
        numberOfDeals: 10,
      );

      final tables = await mancheRepo.findTablesDeJeuByMancheId(manche.id);
      final tableDoublette = tables.first.doublettes.first;

      // Use case: try to set negative points
      final useCase = UpdateManchePointsUseCase(
        mancheRepo,
        donneDoubletteRepo,
      );
      expect(
        () => useCase(
          tableDoubletteId: tableDoublette.id,
          donneNumero: 1,
          points: -10,
        ),
        throwsArgumentError,
      );
    });
  });
}
