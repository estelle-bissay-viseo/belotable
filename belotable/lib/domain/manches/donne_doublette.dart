import 'package:flutter/foundation.dart';

/// Represents points scored in a single deal (donne) for a table-doublette.
@immutable
class DonneDoublette {
  /// Creates a donne doublette record.
  const DonneDoublette({
    required this.tableDoubletteId,
    required this.donneNumero,
    required this.points,
  });

  /// Owning table-doublette row id.
  final int tableDoubletteId;

  /// Donne number (1-based).
  final int donneNumero;

  /// Points for this deal (>= 0).
  final int points;

  /// Returns copy with updated fields.
  DonneDoublette copyWith({
    int? tableDoubletteId,
    int? donneNumero,
    int? points,
  }) {
    return DonneDoublette(
      tableDoubletteId: tableDoubletteId ?? this.tableDoubletteId,
      donneNumero: donneNumero ?? this.donneNumero,
      points: points ?? this.points,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is DonneDoublette &&
        other.tableDoubletteId == tableDoubletteId &&
        other.donneNumero == donneNumero &&
        other.points == points;
  }

  @override
  int get hashCode => Object.hash(
    tableDoubletteId,
    donneNumero,
    points,
  );
}
