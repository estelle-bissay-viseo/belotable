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
}
