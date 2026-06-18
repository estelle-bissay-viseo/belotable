import 'package:flutter/foundation.dart';

/// Represents data needed for PDF rendering of concours tables.
///
/// Decoupled from database schema for portability and testability.
@immutable
class ConcoursTablePdfModel {
  /// Creates instance for PDF rendering.
  const ConcoursTablePdfModel({
    required this.title,
    required this.date,
    required this.lieu,
    required this.organisateur,
    required this.nombreDoublettes,
  });

  /// Concours title/identifier.
  final String title;

  /// Concours date.
  final DateTime date;

  /// Venue location.
  final String lieu;

  /// Organizing entity.
  final String organisateur;

  /// Number of registered doublettes.
  final int nombreDoublettes;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ConcoursTablePdfModel &&
        other.title == title &&
        other.date == date &&
        other.lieu == lieu &&
        other.organisateur == organisateur &&
        other.nombreDoublettes == nombreDoublettes;
  }

  @override
  int get hashCode => Object.hash(
    title,
    date,
    lieu,
    organisateur,
    nombreDoublettes,
  );
}
