import 'package:flutter/foundation.dart';

/// Represents data needed for PDF rendering of concours tables.
///
/// Decoupled from database schema for portability and testability.
@immutable
class ConcoursTablePdfModel {
  /// Creates instance for PDF rendering.
  const ConcoursTablePdfModel({
    required this.date,
    required this.lieu,
    required this.organisateur,
    required this.reglesJeu,
    required this.nombreDonnesParManche,
  });

  /// Concours date.
  final DateTime date;

  /// Venue location.
  final String lieu;

  /// Organizing entity.
  final String organisateur;

  /// Game rules text.
  final String reglesJeu;

  /// Number of deals per round.
  final int nombreDonnesParManche;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ConcoursTablePdfModel &&
        other.date == date &&
        other.lieu == lieu &&
        other.organisateur == organisateur &&
        other.reglesJeu == reglesJeu &&
        other.nombreDonnesParManche == nombreDonnesParManche;
  }

  @override
  int get hashCode => Object.hash(
    date,
    lieu,
    organisateur,
    reglesJeu,
    nombreDonnesParManche,
  );
}
