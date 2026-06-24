import 'package:belotable/domain/manches/deal_points.dart';
import 'package:belotable/presentation/shared/manches/deal_sum_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('deal_sum_utils', () {
    group('computeTableDealSums', () {
      test('computes table sums for 2 doublettes across 3 deals', () {
        final allDealPoints = [
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 1,
            mancheId: 1,
            dealNumber: 1,
            points: 15,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 2,
            mancheId: 1,
            dealNumber: 1,
            points: 14,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 1,
            mancheId: 1,
            dealNumber: 2,
            points: 10,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 2,
            mancheId: 1,
            dealNumber: 2,
            points: 11,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 1,
            mancheId: 1,
            dealNumber: 3,
            points: 20,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 2,
            mancheId: 1,
            dealNumber: 3,
            points: 25,
          ),
        ];

        final sums = computeTableDealSums(allDealPoints);

        expect(sums, equals([29, 21, 45]));
      });

      test('computes sums with zero values', () {
        final allDealPoints = [
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 1,
            mancheId: 1,
            dealNumber: 1,
            points: 0,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 2,
            mancheId: 1,
            dealNumber: 1,
            points: 0,
          ),
        ];

        final sums = computeTableDealSums(allDealPoints);

        expect(sums, equals([0]));
      });

      test('returns empty list for empty input', () {
        final sums = computeTableDealSums([]);

        expect(sums, equals([]));
      });

      test('handles unordered dealNumbers', () {
        final allDealPoints = [
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 1,
            mancheId: 1,
            dealNumber: 3,
            points: 10,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 2,
            mancheId: 1,
            dealNumber: 1,
            points: 5,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 1,
            mancheId: 1,
            dealNumber: 1,
            points: 6,
          ),
          const DealPoints(
            tableId: 1,
            concoursId: 'concours1',
            doubletteId: 2,
            mancheId: 1,
            dealNumber: 3,
            points: 12,
          ),
        ];

        final sums = computeTableDealSums(allDealPoints);

        expect(sums, equals([11, 22]));
      });
    });

    group('shouldHighlightDealSum', () {
      test('highlights when sum is non-zero and not equal to max', () {
        expect(shouldHighlightDealSum(50, 162), isTrue);
        expect(shouldHighlightDealSum(100, 162), isTrue);
        expect(shouldHighlightDealSum(1, 162), isTrue);
      });

      test('does not highlight when sum is 0', () {
        expect(shouldHighlightDealSum(0, 162), isFalse);
      });

      test('does not highlight when sum equals max', () {
        expect(shouldHighlightDealSum(162, 162), isFalse);
      });

      test('handles different max values', () {
        expect(shouldHighlightDealSum(50, 100), isTrue);
        expect(shouldHighlightDealSum(100, 100), isFalse);
        expect(shouldHighlightDealSum(0, 100), isFalse);
      });
    });

    group('getDealSumError', () {
      test('returns error when highlighted', () {
        final error = getDealSumError(50, 162);
        expect(error, isNotNull);
        expect(error, equals('❌162'));
      });

      test('returns null when not highlighted (sum is 0)', () {
        final error = getDealSumError(0, 162);
        expect(error, isNull);
      });

      test('returns null when not highlighted (sum equals max)', () {
        final error = getDealSumError(162, 162);
        expect(error, isNull);
      });
    });
  });
}
