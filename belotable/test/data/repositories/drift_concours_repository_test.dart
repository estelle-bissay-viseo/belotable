import 'package:belotable/data/repositories/drift_concours_repository.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_utils.dart';

void main() {
  repositoryDbTest<DriftConcoursRepository>(
    'save inserts concours in database',
    factory: DriftConcoursRepository.new,
    body: (database, repository) async {
      final concours = Concours(
        id: 'id-1',
        date: DateTime(2026, 6, 8),
        lieu: 'Salle Polyvalente',
        organisateur: 'Club Belote',
      );

      await repository.save(concours);

      final rowCount = await database.concoursDao.countConcours();
      expect(rowCount, 1);
    },
  );

  repositoryDbTest<DriftConcoursRepository>(
    'findAllByDateDesc returns empty list when no concours exists',
    factory: DriftConcoursRepository.new,
    body: (database, repository) async {
      final concoursList = await repository.findAllByDateDesc();

      expect(concoursList, isEmpty);
    },
  );

  repositoryDbTest<DriftConcoursRepository>(
    'findAllByDateDesc returns concours sorted by descending date',
    factory: DriftConcoursRepository.new,
    body: (database, repository) async {
      await repository.save(
        Concours(
          id: 'id-oldest',
          date: DateTime(2024, 1, 10),
          lieu: 'Salle A',
          organisateur: 'Club A',
        ),
      );
      await repository.save(
        Concours(
          id: 'id-latest',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle B',
          organisateur: 'Club B',
        ),
      );
      await repository.save(
        Concours(
          id: 'id-middle',
          date: DateTime(2025, 3, 20),
          lieu: 'Salle C',
          organisateur: 'Club C',
        ),
      );

      final concoursList = await repository.findAllByDateDesc();

      expect(
        concoursList.map((concours) => concours.id).toList(growable: false),
        ['id-latest', 'id-middle', 'id-oldest'],
      );
    },
  );

  repositoryDbTest<DriftConcoursRepository>(
    'delete removes concours and returns true',
    factory: DriftConcoursRepository.new,
    body: (database, repository) async {
      final concours = Concours(
        id: 'id-to-delete',
        date: DateTime(2026, 6, 8),
        lieu: 'Salle A',
        organisateur: 'Club A',
      );

      await repository.save(concours);
      var rowCount = await database.concoursDao.countConcours();
      expect(rowCount, 1);

      final result = await repository.delete('id-to-delete');

      expect(result, isTrue);
      rowCount = await database.concoursDao.countConcours();
      expect(rowCount, 0);
    },
  );

  repositoryDbTest<DriftConcoursRepository>(
    'delete returns false when concours not found',
    factory: DriftConcoursRepository.new,
    body: (database, repository) async {
      final result = await repository.delete('nonexistent-id');

      expect(result, isFalse);
    },
  );
}
