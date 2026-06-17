/// Status of a concours throughout its lifecycle.
enum ConcoursStatut {
  /// Concours in setup phase. Parameters editable.
  initialisation('Initialisation'),

  /// Concours in progress. First manche created. Parameters locked.
  enCours('En cours'),

  /// Concours finished.
  termine('Terminé');

  /// Creates enum with display value.
  const ConcoursStatut(this.displayName);

  /// Human-readable name for UI display.
  final String displayName;

  /// Parse string to enum. Returns initialisation if unknown.
  static ConcoursStatut fromString(String value) {
    return ConcoursStatut.values.firstWhere(
      (s) => s.name == value,
      orElse: () => ConcoursStatut.initialisation,
    );
  }
}
