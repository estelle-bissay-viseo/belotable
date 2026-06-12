/// Arguments for doublettes list route.
class DoublettesListArgs {
  /// Creates route arguments for list page.
  const DoublettesListArgs({required this.concoursId});

  /// Concours owning listed doublettes.
  final String concoursId;
}

/// Arguments for doublette creation route.
class DoubletteCreationArgs {
  /// Creates route arguments for creation page.
  const DoubletteCreationArgs({required this.concoursId});

  /// Concours owning created doublette.
  final String concoursId;
}

/// Arguments for doublette detail route.
class DoubletteDetailArgs {
  /// Creates route arguments for detail page.
  const DoubletteDetailArgs({
    required this.concoursId,
    required this.doubletteId,
  });

  /// Concours owning target doublette.
  final String concoursId;

  /// Registration order id of target doublette.
  final int doubletteId;
}
