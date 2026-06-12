/// Exception thrown when attempting to delete a doublette that has already
/// played or is currently playing in a manche table.
class DoubletteDejaJoueeException implements Exception {
  /// Creates exception for given doublette.
  const DoubletteDejaJoueeException(this.doubletteId);

  /// Id of the doublette that cannot be deleted.
  final int doubletteId;

  @override
  String toString() =>
      'DoubletteDejaJoueeException: doublette $doubletteId cannot be deleted '
      'because it is playing or has already played.';
}
