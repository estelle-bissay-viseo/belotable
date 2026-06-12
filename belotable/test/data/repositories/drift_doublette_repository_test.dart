import 'package:belotable/data/repositories/drift_concours_repository.dart';
import 'package:belotable/data/repositories/drift_doublette_repository.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_utils.dart';

void main() {
  repositoryDbTest<DriftDoubletteRepository>(
    'create assigns increasing id per concours',
    factory: DriftDoubletteRepository.new,
    body: (database, repository) async {
      final concoursRepo = DriftConcoursRepository(database);
      await concoursRepo.save(
        Concours(
          id: 'c-1',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
        ),
      );

      final first = await repository.create(
        concoursId: 'c-1',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'Equipe 1',
      );
      final second = await repository.create(
        concoursId: 'c-1',
        joueurA: 'A2',
        joueurB: 'B2',
        nomEquipe: 'Equipe 2',
      );

      expect(first.doubletteId, 1);
      expect(second.doubletteId, 2);
    },
  );

  repositoryDbTest<DriftDoubletteRepository>(
    'findByConcoursId returns sorted list by id asc',
    factory: DriftDoubletteRepository.new,
    body: (database, repository) async {
      final concoursRepo = DriftConcoursRepository(database);
      await concoursRepo.save(
        Concours(
          id: 'c-1',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
        ),
      );

      await repository.create(
        concoursId: 'c-1',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'E1',
      );
      await repository.create(
        concoursId: 'c-1',
        joueurA: 'A2',
        joueurB: 'B2',
        nomEquipe: 'E2',
      );

      final result = await repository.findByConcoursId('c-1');
      expect(result.map((e) => e.doubletteId).toList(growable: false), [1, 2]);
    },
  );

  repositoryDbTest<DriftDoubletteRepository>(
    'teamNameExists returns true for same concours',
    factory: DriftDoubletteRepository.new,
    body: (database, repository) async {
      final concoursRepo = DriftConcoursRepository(database);
      await concoursRepo.save(
        Concours(
          id: 'c-1',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
        ),
      );

      await repository.create(
        concoursId: 'c-1',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'Unique',
      );

      final exists = await repository.teamNameExists(
        concoursId: 'c-1',
        nomEquipe: 'Unique',
      );
      expect(exists, isTrue);
    },
  );

  repositoryDbTest<DriftDoubletteRepository>(
    'teamNameExists is case-insensitive for same concours',
    factory: DriftDoubletteRepository.new,
    body: (database, repository) async {
      final concoursRepo = DriftConcoursRepository(database);
      await concoursRepo.save(
        Concours(
          id: 'c-1',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
        ),
      );

      await repository.create(
        concoursId: 'c-1',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'Les As',
      );

      final existsLower = await repository.teamNameExists(
        concoursId: 'c-1',
        nomEquipe: 'les as',
      );
      final existsUpper = await repository.teamNameExists(
        concoursId: 'c-1',
        nomEquipe: 'LES AS',
      );

      expect(existsLower, isTrue);
      expect(existsUpper, isTrue);
    },
  );

  repositoryDbTest<DriftDoubletteRepository>(
    'delete concours cascades to doublettes',
    factory: DriftDoubletteRepository.new,
    body: (database, repository) async {
      final concoursRepo = DriftConcoursRepository(database);
      await concoursRepo.save(
        Concours(
          id: 'c-1',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
        ),
      );

      await repository.create(
        concoursId: 'c-1',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'E1',
      );

      final deleted = await concoursRepo.delete('c-1');
      expect(deleted, isTrue);

      final remaining = await repository.findByConcoursId('c-1');
      expect(remaining, isEmpty);
    },
  );
}
