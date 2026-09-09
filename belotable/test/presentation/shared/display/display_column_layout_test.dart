import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';
import 'package:belotable/presentation/shared/display/display_column_layout.dart';
import 'package:flutter_test/flutter_test.dart';

TableDeJeu _table(int numero) {
  return TableDeJeu(
    id: numero,
    mancheId: 1,
    numero: numero,
    statut: TableDeJeuStatut.enAttente,
    doublettes: [
      TableDoublette(
        id: numero,
        tableId: numero,
        concoursId: 'concours-1',
        doubletteId: numero,
        points: 0,
        statut: TableDoubletteStatut.enAttente,
        nomEquipe: 'Equipe $numero',
      ),
    ],
  );
}

void main() {
  group('resolveDisplayColumnCount', () {
    test('returns 1 column when height and width are generous', () {
      final columns = resolveDisplayColumnCount(
        tableCount: 6,
        availableHeight: 2000,
        availableWidth: 2000,
      );
      expect(columns, 1);
    });

    test('returns 1 column when there is no table', () {
      final columns = resolveDisplayColumnCount(
        tableCount: 0,
        availableHeight: 2000,
        availableWidth: 2000,
      );
      expect(columns, 1);
    });

    test('splits into 3 columns when height only fits 2 rows per column', () {
      // 6 tables, 2 rows/column (1 header row + 2 data rows fit) => 3 cols.
      final columns = resolveDisplayColumnCount(
        tableCount: 6,
        availableHeight: 3 * displayEstimatedRowHeight,
        availableWidth: 2000,
      );
      expect(columns, 3);
    });

    test('caps columns to available width even if height allows more', () {
      // Height alone would ask for 6 columns (1 row per column), but width
      // only fits 2.
      final columns = resolveDisplayColumnCount(
        tableCount: 6,
        availableHeight: 2 * displayEstimatedRowHeight,
        availableWidth: 2 * displayMinColumnWidth + displayColumnSpacing,
      );
      expect(columns, 2);
    });

    test('never exceeds the number of tables', () {
      final columns = resolveDisplayColumnCount(
        tableCount: 2,
        availableHeight: 1 * displayEstimatedRowHeight,
        availableWidth: 10 * displayMinColumnWidth,
      );
      expect(columns, lessThanOrEqualTo(2));
    });

    test('falls back to 1 column when height is too small for a header', () {
      final columns = resolveDisplayColumnCount(
        tableCount: 6,
        availableHeight: 10,
        availableWidth: 2000,
      );
      expect(columns, 1);
    });
  });

  group('splitDisplayTablesIntoColumns', () {
    test('returns a single column unchanged when columnCount is 1', () {
      final tables = [_table(1), _table(2), _table(3)];
      expect(splitDisplayTablesIntoColumns(tables, 1), [tables]);
    });

    test('splits evenly across columns when count divides evenly', () {
      final tables = [_table(1), _table(2), _table(3), _table(4)];
      final columns = splitDisplayTablesIntoColumns(tables, 2);
      expect(columns, [
        [tables[0], tables[1]],
        [tables[2], tables[3]],
      ]);
    });

    test('gives earlier columns the extra remainder rows', () {
      final tables = [_table(1), _table(2), _table(3), _table(4), _table(5)];
      final columns = splitDisplayTablesIntoColumns(tables, 3);
      expect(columns, [
        [tables[0], tables[1]],
        [tables[2], tables[3]],
        [tables[4]],
      ]);
    });

    test('returns empty list wrapped once when there are no tables', () {
      expect(splitDisplayTablesIntoColumns(const [], 3), [<TableDeJeu>[]]);
    });
  });
}
