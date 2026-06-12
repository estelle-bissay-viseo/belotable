import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';

/// Implements ConcoursRepository using Drift database.
class DriftConcoursRepository implements ConcoursRepository {
  /// Creates repository with given database instance.
  DriftConcoursRepository(AppDatabase database)
    : _concoursDao = database.concoursDao;

  final ConcoursDao _concoursDao;

  @override
  Future<void> save(Concours concours) {
    return _concoursDao.insertConcours(concours);
  }

  @override
  Future<Concours?> findById(String id) {
    return _concoursDao.findConcoursById(id);
  }

  @override
  Future<List<Concours>> findAllByDateDesc() {
    return _concoursDao.findAllConcoursByDateDesc();
  }

  @override
  Future<bool> delete(String id) {
    return _concoursDao.deleteConcoursById(id);
  }
}
