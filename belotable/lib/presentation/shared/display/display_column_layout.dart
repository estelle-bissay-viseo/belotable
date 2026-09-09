import 'package:belotable/domain/manches/table_de_jeu.dart';

/// Approximate height of one table row (header or data), used to decide
/// how many rows fit in a column without scrolling.
const displayEstimatedRowHeight = 48.0;

/// Minimum width a table column needs to stay readable.
const displayMinColumnWidth = 320.0;

/// Horizontal gap between columns.
const displayColumnSpacing = 24.0;

/// Picks how many columns to use so that [tableCount] rows fit within
/// [availableHeight] without scrolling, while never dropping columns below
/// [displayMinColumnWidth] and never exceeding [tableCount].
int resolveDisplayColumnCount({
  required int tableCount,
  required double availableHeight,
  required double availableWidth,
}) {
  if (tableCount <= 0) {
    return 1;
  }

  // One row is reserved for the header when estimating how many data
  // rows fit in a column without scrolling.
  final maxRowsPerColumn =
      (availableHeight / displayEstimatedRowHeight).floor() - 1;
  final columnsForHeight = maxRowsPerColumn < 1
      ? 1
      : (tableCount / maxRowsPerColumn).ceil();

  final columnsForWidth =
      ((availableWidth + displayColumnSpacing) /
              (displayMinColumnWidth + displayColumnSpacing))
          .floor();

  final columnCount = columnsForHeight.clamp(
    1,
    columnsForWidth < 1 ? 1 : columnsForWidth,
  );
  return columnCount > tableCount
      ? tableCount.clamp(1, columnCount)
      : columnCount;
}

/// Splits [tables] into [columnCount] left-to-right chunks, earlier
/// columns receiving any extra remainder rows.
List<List<TableDeJeu>> splitDisplayTablesIntoColumns(
  List<TableDeJeu> tables,
  int columnCount,
) {
  if (columnCount <= 1 || tables.isEmpty) {
    return [tables];
  }

  final baseSize = tables.length ~/ columnCount;
  final remainder = tables.length % columnCount;

  final columns = <List<TableDeJeu>>[];
  var start = 0;
  for (var i = 0; i < columnCount; i++) {
    final size = baseSize + (i < remainder ? 1 : 0);
    columns.add(tables.sublist(start, start + size));
    start += size;
  }
  return columns;
}
