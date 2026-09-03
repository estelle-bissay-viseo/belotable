import 'package:belotable/domain/manches/update_round_score_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/in_memory_doublette_repository.dart';
import '../../helpers/in_memory_manche_repository.dart';

void main() {
  group('UpdateRoundScoreUseCase', () {
    test('updates round score directly and recalculates total', () async {
      const concoursId = 'concours1';

      final doubletteRepo = InMemoryDoubletteRepository();
      final mancheRepo = InMemoryMancheRepository(doubletteRepo);

      await doubletteRepo.create(
        concoursId: concoursId,
        joueurA: 'Alice',
        joueurB: 'Bob',
        nomEquipe: 'Team A',
      );

      final doublettes = await doubletteRepo.findByConcoursId(concoursId);
      final manche = await mancheRepo.createPremiereManche(
        concoursId: concoursId,
        doublettes: doublettes,
      );

      final tables = await mancheRepo.findTablesDeJeuByMancheId(manche.id);
      final tableDoublette = tables.first.doublettes.first;

      final useCase = UpdateRoundScoreUseCase(mancheRepo);
      await useCase(tableDoubletteId: tableDoublette.id, points: 90);

      final updated = await mancheRepo.findTableDoublette(
        doubletteRowId: doublettes.first.id,
      );
      expect(updated?.points, 90);

      final updatedDoublette = await doubletteRepo.findById(
        concoursId: concoursId,
        doubletteId: doublettes.first.doubletteId,
      );
      expect(updatedDoublette?.totalPoints, 90);
    });

    test('rejects negative points', () async {
      final doubletteRepo = InMemoryDoubletteRepository();
      final mancheRepo = InMemoryMancheRepository(doubletteRepo);
      final useCase = UpdateRoundScoreUseCase(mancheRepo);

      await expectLater(
        useCase(tableDoubletteId: 1, points: -5),
        throwsArgumentError,
      );
    });
  });
}
