import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';

class InMemoryDoubletteRepository implements DoubletteRepository {
  final _items = <Doublette>[];
  var _nextSurrogateId = 1;

  List<Doublette> get savedDoublettes => List.unmodifiable(_items);

  /// Test-only helper to resolve a doublette by its surrogate row id,
  /// mimicking the join production DAOs perform against DoublettesTable.
  Doublette? findByRowId(int id) {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<Doublette> create({
    required String concoursId,
    required String joueurA,
    required String joueurB,
    required String nomEquipe,
  }) async {
    final maxId = _items
        .where((d) => d.concoursId == concoursId)
        .map((d) => d.doubletteId)
        .fold<int>(0, (prev, id) => id > prev ? id : prev);

    final created = Doublette(
      id: _nextSurrogateId++,
      concoursId: concoursId,
      doubletteId: maxId + 1,
      joueurA: joueurA,
      joueurB: joueurB,
      nomEquipe: nomEquipe,
    );
    _items.add(created);
    return created;
  }

  @override
  Future<Doublette> update(Doublette doublette) async {
    final index = _items.indexWhere((item) => item.id == doublette.id);
    if (index == -1) {
      _items.add(doublette);
    } else {
      _items[index] = doublette;
    }
    return doublette;
  }

  @override
  Future<Doublette?> findById({
    required String concoursId,
    required int doubletteId,
  }) async {
    for (final item in _items) {
      if (item.concoursId == concoursId && item.doubletteId == doubletteId) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<Doublette>> findByConcoursId(String concoursId) async {
    final list = _items.where((item) => item.concoursId == concoursId).toList()
      ..sort((a, b) => a.doubletteId.compareTo(b.doubletteId));
    return list;
  }

  @override
  Future<bool> delete(int id) async {
    final before = _items.length;
    _items.removeWhere((item) => item.id == id);
    return _items.length < before;
  }

  @override
  Future<bool> teamNameExists({
    required String concoursId,
    required String nomEquipe,
    int? excludingId,
  }) async {
    final normalizedTeamName = nomEquipe.toLowerCase();
    for (final item in _items) {
      if (item.concoursId != concoursId) {
        continue;
      }
      if (excludingId != null && item.id == excludingId) {
        continue;
      }
      if (item.nomEquipe.toLowerCase() == normalizedTeamName) {
        return true;
      }
    }
    return false;
  }

  Future<void> updateTotalPoints(int doubletteId, int totalPoints) async {
    final index = _items.indexWhere((item) => item.doubletteId == doubletteId);
    if (index != -1) {
      final d = _items[index];
      _items[index] = Doublette(
        id: d.id,
        concoursId: d.concoursId,
        doubletteId: d.doubletteId,
        joueurA: d.joueurA,
        joueurB: d.joueurB,
        nomEquipe: d.nomEquipe,
        totalPoints: totalPoints,
      );
    }
  }
}
