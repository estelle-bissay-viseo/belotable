import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';

/// Implements DoubletteRepository using Drift database.
class DriftDoubletteRepository implements DoubletteRepository {
  /// Creates repository with given database instance.
  DriftDoubletteRepository(AppDatabase database)
    : _doublettesDao = database.doublettesDao;

  final DoublettesDao _doublettesDao;

  @override
  Future<Doublette> create({
    required String concoursId,
    required String joueurA,
    required String joueurB,
    required String nomEquipe,
  }) {
    return _doublettesDao.createDoublette(
      concoursId: concoursId,
      joueurA: joueurA,
      joueurB: joueurB,
      nomEquipe: nomEquipe,
    );
  }

  @override
  Future<Doublette> update(Doublette doublette) {
    return _doublettesDao.updateDoublette(doublette);
  }

  @override
  Future<Doublette?> findById({
    required String concoursId,
    required int doubletteId,
  }) {
    return _doublettesDao.findDoubletteById(
      concoursId: concoursId,
      doubletteId: doubletteId,
    );
  }

  @override
  Future<List<Doublette>> findByConcoursId(String concoursId) {
    return _doublettesDao.findDoublettesByConcoursId(concoursId);
  }

  @override
  Future<bool> delete({required String concoursId, required int doubletteId}) {
    return _doublettesDao.deleteDoublette(
      concoursId: concoursId,
      doubletteId: doubletteId,
    );
  }

  @override
  Future<bool> teamNameExists({
    required String concoursId,
    required String nomEquipe,
    int? excludingDoubletteId,
  }) {
    return _doublettesDao.teamNameExists(
      concoursId: concoursId,
      nomEquipe: nomEquipe,
      excludingDoubletteId: excludingDoubletteId,
    );
  }
}
