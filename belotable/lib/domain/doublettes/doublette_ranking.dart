import 'package:belotable/domain/doublettes/doublette.dart';

/// Sorts [doublettes] by total points descending, ties broken by doublette
/// number ascending. Shared ranking order used by both the concours
/// doublette ranking page and the display screen.
List<Doublette> sortDoublettesByRanking(List<Doublette> doublettes) {
  return List<Doublette>.from(doublettes)..sort((a, b) {
    final pointsComparison = b.totalPoints.compareTo(a.totalPoints);
    if (pointsComparison != 0) {
      return pointsComparison;
    }
    return a.doubletteId.compareTo(b.doubletteId);
  });
}
