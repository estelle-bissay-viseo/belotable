import 'package:flutter/foundation.dart';

/// Represents a belote competition.
///
/// An immutable entity containing competition date, location, and organizer.
@immutable
class Concours {
  /// Creates an instance.
  const Concours({
    required this.id,
    required this.date,
    required this.lieu,
    required this.organisateur,
    this.nombreDoublettes = 0,
  });

  /// Unique identifier.
  final String id;

  /// Competition date.
  final DateTime date;

  /// Venue location.
  final String lieu;

  /// Organizing entity.
  final String organisateur;

  /// Number of doublettes registered for this concours.
  final int nombreDoublettes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Concours &&
        other.id == id &&
        other.date == date &&
        other.lieu == lieu &&
        other.organisateur == organisateur &&
        other.nombreDoublettes == nombreDoublettes;
  }

  @override
  int get hashCode =>
      Object.hash(id, date, lieu, organisateur, nombreDoublettes);
}
