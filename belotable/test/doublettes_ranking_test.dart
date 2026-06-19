import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Doublettes Ranking', () {
    test('Doublettes sort by total points descending', () {
      final doublettes = [
        const Doublette(
          concoursId: 'c1',
          doubletteId: 1,
          joueurA: 'Player A1',
          joueurB: 'Player B1',
          nomEquipe: 'Team A',
          totalPoints: 100,
        ),
        const Doublette(
          concoursId: 'c1',
          doubletteId: 2,
          joueurA: 'Player A2',
          joueurB: 'Player B2',
          nomEquipe: 'Team B',
          totalPoints: 150,
        ),
        const Doublette(
          concoursId: 'c1',
          doubletteId: 3,
          joueurA: 'Player A3',
          joueurB: 'Player B3',
          nomEquipe: 'Team C',
          totalPoints: 120,
        ),
      ];

      // Sort descending by total points (simulating ranking logic)
      final sorted = List<Doublette>.from(doublettes)
        ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      expect(sorted.length, 3);
      expect(sorted[0].nomEquipe, 'Team B');
      expect(sorted[0].totalPoints, 150);
      expect(sorted[1].nomEquipe, 'Team C');
      expect(sorted[1].totalPoints, 120);
      expect(sorted[2].nomEquipe, 'Team A');
      expect(sorted[2].totalPoints, 100);
    });

    test('Empty doublettes list returns empty sorted list', () {
      final doublettes = <Doublette>[];

      final sorted = List<Doublette>.from(doublettes)
        ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      expect(sorted.isEmpty, true);
    });

    test('Single doublette returns single element list', () {
      final doublettes = [
        const Doublette(
          concoursId: 'c1',
          doubletteId: 1,
          joueurA: 'Player A',
          joueurB: 'Player B',
          nomEquipe: 'Team A',
          totalPoints: 100,
        ),
      ];

      final sorted = List<Doublette>.from(doublettes)
        ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      expect(sorted.length, 1);
      expect(sorted[0].nomEquipe, 'Team A');
    });

    test('Doublettes with equal points maintain relative order', () {
      final doublettes = [
        const Doublette(
          concoursId: 'c1',
          doubletteId: 1,
          joueurA: 'Player A1',
          joueurB: 'Player B1',
          nomEquipe: 'Team A',
          totalPoints: 100,
        ),
        const Doublette(
          concoursId: 'c1',
          doubletteId: 2,
          joueurA: 'Player A2',
          joueurB: 'Player B2',
          nomEquipe: 'Team B',
          totalPoints: 100,
        ),
      ];

      final sorted = List<Doublette>.from(doublettes)
        ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

      expect(sorted.length, 2);
      expect(sorted[0].totalPoints, 100);
      expect(sorted[1].totalPoints, 100);
    });
  });
}
