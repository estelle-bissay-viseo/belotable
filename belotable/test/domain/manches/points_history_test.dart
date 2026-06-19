import 'package:belotable/domain/manches/points_history_row.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PointsHistoryRow', () {
    test('creates with all fields', () {
      final row = PointsHistoryRow(
        mancheNum: 1,
        points: 500,
        statut: 'Gagné',
        opponentName: 'Les Amigos',
        opponentId: 2,
      );

      expect(row.mancheNum, 1);
      expect(row.points, 500);
      expect(row.statut, 'Gagné');
      expect(row.opponentName, 'Les Amigos');
      expect(row.opponentId, 2);
    });

    test('formats opponent display as "Nom (#ID)"', () {
      final row = PointsHistoryRow(
        mancheNum: 1,
        points: 500,
        statut: 'Gagné',
        opponentName: 'Les Amigos',
        opponentId: 2,
      );

      final formatted = '${row.opponentName} (#${row.opponentId})';
      expect(formatted, 'Les Amigos (#2)');
    });

    test('handles empty opponent name', () {
      final row = PointsHistoryRow(
        mancheNum: 1,
        points: 500,
        statut: 'Gagné',
        opponentName: '',
        opponentId: 0,
      );

      expect(row.opponentName.isEmpty, true);
      expect(row.opponentId, 0);
    });

    test('stores zero points', () {
      final row = PointsHistoryRow(
        mancheNum: 2,
        points: 0,
        statut: 'Perdu',
        opponentName: 'Team B',
        opponentId: 3,
      );

      expect(row.points, 0);
    });
  });
}
