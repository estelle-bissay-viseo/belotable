import 'package:flutter/foundation.dart';

/// Represents points scored in a single deal for a doublette in a table.
@immutable
class DealPoints {
  /// Creates a deal points record.
  const DealPoints({
    required this.tableDoubletteId,
    required this.dealNumber,
    required this.points,
  });

  /// Foreign key to TableDoublettesTable.id.
  final int tableDoubletteId;

  /// Deal number (1-based).
  final int dealNumber;

  /// Points for this deal (>= 0).
  final int points;

  /// Returns copy with updated fields.
  DealPoints copyWith({
    int? tableDoubletteId,
    int? dealNumber,
    int? points,
  }) {
    return DealPoints(
      tableDoubletteId: tableDoubletteId ?? this.tableDoubletteId,
      dealNumber: dealNumber ?? this.dealNumber,
      points: points ?? this.points,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DealPoints &&
        other.tableDoubletteId == tableDoubletteId &&
        other.dealNumber == dealNumber &&
        other.points == points;
  }

  @override
  int get hashCode => Object.hash(
    tableDoubletteId,
    dealNumber,
    points,
  );
}
