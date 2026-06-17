import 'package:belotable/domain/concours/concours_statut.dart';
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
    this.nombreDonnesParManche = 10,
    this.nombreMaxPointsParDonne = 162,
    this.nombreDoublettes = 0,
    this.reglesJeu = '',
    this.statutConcours = ConcoursStatut.initialisation,
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

  /// Number of deals per round.
  final int nombreDonnesParManche;

  /// Maximum points per deal.
  final int nombreMaxPointsParDonne;

  /// Game rules text.
  final String reglesJeu;

  /// Contest status: Initialisation, EnCours, Termine.
  final ConcoursStatut statutConcours;

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
        other.nombreDoublettes == nombreDoublettes &&
        other.nombreDonnesParManche == nombreDonnesParManche &&
        other.nombreMaxPointsParDonne == nombreMaxPointsParDonne &&
        other.reglesJeu == reglesJeu &&
        other.statutConcours == statutConcours;
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    lieu,
    organisateur,
    nombreDoublettes,
    nombreDonnesParManche,
    nombreMaxPointsParDonne,
    reglesJeu,
    statutConcours,
  );

  /// Returns true if general concours info can be edited.
  ///
  /// Only editable when status is Initialisation.
  bool canEditInfo() {
    return statutConcours == ConcoursStatut.initialisation;
  }
}
