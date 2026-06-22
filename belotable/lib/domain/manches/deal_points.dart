import 'package:flutter/foundation.dart';

/// Represents points scored in a single deal for a doublette in a table.
@immutable
class DealPoints {
  /// Creates a deal points record.
  const DealPoints({
    required this.tableId,
    required this.concoursId,
    required this.doubletteId,
    required this.mancheId,
    required this.dealNumber,
    required this.points,
  });

  /// Owning table id.
  final int tableId;

  /// Owning concours id.
  final String concoursId;

  /// Doublette registration id.
  final int doubletteId;

  /// Owning manche id.
  final int mancheId;

  /// Deal number (1-based).
  final int dealNumber;

  /// Points for this deal (>= 0).
  final int points;

  /// Returns copy with updated fields.
  DealPoints copyWith({
    int? tableId,
    String? concoursId,
    int? doubletteId,
    int? mancheId,
    int? dealNumber,
    int? points,
  }) {
    return DealPoints(
      tableId: tableId ?? this.tableId,
      concoursId: concoursId ?? this.concoursId,
      doubletteId: doubletteId ?? this.doubletteId,
      mancheId: mancheId ?? this.mancheId,
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
        other.tableId == tableId &&
        other.concoursId == concoursId &&
        other.doubletteId == doubletteId &&
        other.mancheId == mancheId &&
        other.dealNumber == dealNumber &&
        other.points == points;
  }

  @override
  int get hashCode => Object.hash(
    tableId,
    concoursId,
    doubletteId,
    mancheId,
    dealNumber,
    points,
  );
}
