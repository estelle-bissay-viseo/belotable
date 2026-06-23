import 'package:belotable/domain/manches/table_doublette.dart';

/// Status of a round (manche).
enum MancheStatut {
  /// At least one doublette has status En attente or En jeu.
  enCours,

  /// All doublettes are in terminal state.
  termine;

  /// French display label.
  String get label {
    switch (this) {
      case MancheStatut.enCours:
        return 'En cours';
      case MancheStatut.termine:
        return 'Terminé';
    }
  }

  /// Converts persisted string to enum value.
  static MancheStatut fromDb(String value) {
    switch (value) {
      case 'En cours':
        return MancheStatut.enCours;
      case 'Terminé':
        return MancheStatut.termine;
      default:
        return MancheStatut.enCours;
    }
  }

  /// Computes manche status from all its doublettes across all tables.
  static MancheStatut fromDoublettes(List<TableDoublette> doublettes) {
    if (doublettes.isEmpty) {
      return MancheStatut.enCours;
    }

    final anyActive = doublettes.any(
      (d) =>
          d.statut == TableDoubletteStatut.enAttente ||
          d.statut == TableDoubletteStatut.enJeu,
    );

    if (anyActive) {
      return MancheStatut.enCours;
    }

    return MancheStatut.termine;
  }
}
