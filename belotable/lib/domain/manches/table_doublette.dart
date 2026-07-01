/// Status of a doublette within a match table.
enum TableDoubletteStatut {
  /// Doublette registered, match not started.
  enAttente,

  /// Doublette currently playing.
  enJeu,

  /// Doublette won match.
  gagne,

  /// Doublette lost match.
  perdu,

  /// Doublette abandoned match.
  abandon;

  /// French display label.
  String get label {
    switch (this) {
      case TableDoubletteStatut.enAttente:
        return 'En attente';
      case TableDoubletteStatut.enJeu:
        return 'En jeu';
      case TableDoubletteStatut.gagne:
        return 'Gagné';
      case TableDoubletteStatut.perdu:
        return 'Perdu';
      case TableDoubletteStatut.abandon:
        return 'Abandon';
    }
  }

  /// Converts persisted string to enum value.
  static TableDoubletteStatut fromDb(String value) {
    switch (value) {
      case 'En jeu':
        return TableDoubletteStatut.enJeu;
      case 'Gagné':
        return TableDoubletteStatut.gagne;
      case 'Perdu':
        return TableDoubletteStatut.perdu;
      case 'Abandon':
        return TableDoubletteStatut.abandon;
      default:
        return TableDoubletteStatut.enAttente;
    }
  }
}

/// Participation of one doublette in a match table.
class TableDoublette {
  /// Creates a table-doublette link.
  const TableDoublette({
    required this.id,
    required this.tableId,
    required this.concoursId,
    required this.doubletteId,
    required this.points,
    required this.statut,
    required this.nomEquipe,
  });

  /// Auto-incremented surrogate primary key.
  final int id;

  /// Owning table id.
  final int tableId;

  /// Owning concours id.
  final String concoursId;

  /// Doublette registration id.
  final int doubletteId;

  /// Points achieved in this table.
  final int points;

  /// Current status of the doublette in this table.
  final TableDoubletteStatut statut;

  /// Team name (denormalized for display).
  final String nomEquipe;

  /// Returns copy with updated fields.
  TableDoublette copyWith({
    int? points,
    TableDoubletteStatut? statut,
  }) {
    return TableDoublette(
      id: id,
      tableId: tableId,
      concoursId: concoursId,
      doubletteId: doubletteId,
      points: points ?? this.points,
      statut: statut ?? this.statut,
      nomEquipe: nomEquipe,
    );
  }
}
