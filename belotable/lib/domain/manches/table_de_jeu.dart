import 'package:belotable/domain/manches/table_doublette.dart';

/// Status of a match table.
enum TableDeJeuStatut {
  /// No active play started.
  enAttente,

  /// At least one doublette has started or partial result exists.
  enCours,

  /// All doublettes are in terminal state.
  termine;

  /// French display label.
  String get label {
    switch (this) {
      case TableDeJeuStatut.enAttente:
        return 'En attente';
      case TableDeJeuStatut.enCours:
        return 'En cours';
      case TableDeJeuStatut.termine:
        return 'Terminé';
    }
  }

  /// Converts persisted string to enum value.
  static TableDeJeuStatut fromDb(String value) {
    switch (value) {
      case 'En cours':
        return TableDeJeuStatut.enCours;
      case 'Terminé':
        return TableDeJeuStatut.termine;
      default:
        return TableDeJeuStatut.enAttente;
    }
  }

  /// Computes table status from its doublettes' statuses.
  static TableDeJeuStatut fromDoublettes(List<TableDoublette> doublettes) {
    if (doublettes.isEmpty) {
      return TableDeJeuStatut.enAttente;
    }

    final allTerminated = doublettes.every(
      (d) =>
          d.statut == TableDoubletteStatut.gagne ||
          d.statut == TableDoubletteStatut.perdu ||
          d.statut == TableDoubletteStatut.abandon,
    );

    if (allTerminated) {
      return TableDeJeuStatut.termine;
    }

    final anyActive = doublettes.any(
      (d) =>
          d.statut == TableDoubletteStatut.enJeu ||
          d.statut == TableDoubletteStatut.gagne ||
          d.statut == TableDoubletteStatut.perdu ||
          d.statut == TableDoubletteStatut.abandon,
    );

    if (anyActive) {
      return TableDeJeuStatut.enCours;
    }

    return TableDeJeuStatut.enAttente;
  }
}

/// A match table within a round.
class TableDeJeu {
  /// Creates a match table entity.
  const TableDeJeu({
    required this.id,
    required this.mancheId,
    required this.numero,
    required this.statut,
    required this.doublettes,
  });

  /// Unique identifier.
  final int id;

  /// Owning manche id.
  final int mancheId;

  /// Table number within round, starting at 1.
  final int numero;

  /// Computed status from doublettes.
  final TableDeJeuStatut statut;

  /// Participating doublettes (0, 1, or 2).
  final List<TableDoublette> doublettes;

  /// Number of participating teams.
  int get nombreDoublettes => doublettes.length;
}
