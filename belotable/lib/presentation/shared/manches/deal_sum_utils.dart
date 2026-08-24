import 'package:belotable/domain/manches/donne_doublette.dart';

/// Computes per-deal sums from doublette donnes doublettes across a table.
///
/// Input: list of DonneDoublette for all doublettes in a table,
/// grouped by donneNumero
/// Output: [sum(D1), sum(D2), ...] where each sum = doubletteA_points +
/// doubletteB_points.
///
/// Example: 2 doublettes, 3 deals:
///   [DonneDoublette(donneNumero: 1, points: 15),   // doubletteA, D1
///    DonneDoublette(donneNumero: 1, points: 14),   // doubletteB, D1
///    DonneDoublette(donneNumero: 2, points: 10),   // doubletteA, D2
///    DonneDoublette(donneNumero: 2, points: 11),   // doubletteB, D2
///    ...]
///   Returns: [29, 21, ...] → sums for D1, D2, ...
List<int> computeTableDealSums(List<DonneDoublette> allDonneDoublettes) {
  if (allDonneDoublettes.isEmpty) return [];

  // Group by donneNumero, sum across all doublettes
  final sums = <int, int>{};
  for (final dp in allDonneDoublettes) {
    sums[dp.donneNumero] = (sums[dp.donneNumero] ?? 0) + dp.points;
  }

  // Return sums in order of donneNumero
  final sorted = sums.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  return sorted.map((e) => e.value).toList();
}

/// Determines if a deal sum should be highlighted orange.
///
/// Returns true when:
/// - sum != 0 AND sum != maxPointsPerDeal
///
/// Returns false when:
/// - sum = 0 OR sum = maxPointsPerDeal
bool shouldHighlightDealSum(int dealSum, int maxPointsPerDeal) {
  return dealSum != 0 && dealSum != maxPointsPerDeal;
}

/// Gets the error hint
String? getDealSumError(int dealSum, int maxPointsPerDeal) {
  return shouldHighlightDealSum(dealSum, maxPointsPerDeal)
      ? '❌$maxPointsPerDeal'
      : null;
}
