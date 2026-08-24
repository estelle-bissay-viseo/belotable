import 'package:flutter/foundation.dart';

/// Represents a duo registered in a contest.
@immutable
class Doublette {
  /// Creates an immutable doublette entity.
  const Doublette({
    required this.id,
    required this.concoursId,
    required this.doubletteId,
    required this.joueurA,
    required this.joueurB,
    required this.nomEquipe,
    this.totalPoints = 0,
  });

  /// Auto-generated surrogate primary key.
  final int id;

  /// Owning contest id.
  final String concoursId;

  /// Registration order id within the contest (display only).
  final int doubletteId;

  /// Player A full name.
  final String joueurA;

  /// Player B full name.
  final String joueurB;

  /// Unique team name within contest.
  final String nomEquipe;

  /// Aggregated points across all manches.
  final int totalPoints;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Doublette &&
        other.id == id &&
        other.concoursId == concoursId &&
        other.doubletteId == doubletteId &&
        other.joueurA == joueurA &&
        other.joueurB == joueurB &&
        other.nomEquipe == nomEquipe &&
        other.totalPoints == totalPoints;
  }

  @override
  int get hashCode => Object.hash(
    id,
    concoursId,
    doubletteId,
    joueurA,
    joueurB,
    nomEquipe,
    totalPoints,
  );
}
