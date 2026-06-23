/// Exception thrown when attempting to delete a doublette that has already
/// played or is currently playing in a manche table.
class DoubletteDejaJoueeException implements Exception {
  /// Creates exception for given doublette.
  const DoubletteDejaJoueeException(this.doubletteId);

  /// Id of the doublette that cannot be deleted.
  final int doubletteId;

  /// User-facing message explaining why deletion is refused.
  String get message =>
      'Vous ne pouvez pas supprimer une doublette qui a commencé à jouer. '
      'Veuillez la noter au statut "Abandon" dans la dernière manche jouée '
      'pour exclure cette doublette de la prochaine manche.';

  @override
  String toString() =>
      'DoubletteDejaJoueeException: doublette $doubletteId cannot be deleted '
      'because it is playing or has already played.';
}
