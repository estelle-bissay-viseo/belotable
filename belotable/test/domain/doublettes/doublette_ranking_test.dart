import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_ranking.dart';
import 'package:flutter_test/flutter_test.dart';

Doublette _doublette(int id, int totalPoints) {
  return Doublette(
    id: id,
    concoursId: 'concours-1',
    doubletteId: id,
    joueurA: 'Joueur A$id',
    joueurB: 'Joueur B$id',
    nomEquipe: 'Equipe $id',
    totalPoints: totalPoints,
  );
}

void main() {
  group('sortDoublettesByRanking', () {
    test('sorts by total points descending', () {
      final doublettes = [
        _doublette(1, 10),
        _doublette(2, 30),
        _doublette(3, 20),
      ];

      final sorted = sortDoublettesByRanking(doublettes);

      expect(
        sorted.map((d) => d.doubletteId).toList(),
        [2, 3, 1],
      );
    });

    test('breaks ties by doublette number ascending', () {
      final doublettes = [
        _doublette(3, 20),
        _doublette(1, 20),
        _doublette(2, 20),
      ];

      final sorted = sortDoublettesByRanking(doublettes);

      expect(
        sorted.map((d) => d.doubletteId).toList(),
        [1, 2, 3],
      );
    });

    test('does not mutate the original list', () {
      final doublettes = [_doublette(1, 10), _doublette(2, 30)];
      final original = List<Doublette>.from(doublettes);

      sortDoublettesByRanking(doublettes);

      expect(doublettes, original);
    });

    test('returns an empty list unchanged', () {
      expect(sortDoublettesByRanking(const []), isEmpty);
    });
  });
}
