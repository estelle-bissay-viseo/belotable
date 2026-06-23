import 'package:belotable/domain/manches/deal_points.dart';
import 'package:flutter/material.dart';

/// Computes per-deal sums from doublette dealPoints across a table.
///
/// Input: list of DealPoints for all doublettes in a table,
/// grouped by dealNumber
/// Output: [sum(D1), sum(D2), ...] where each sum = doubletteA_points +
/// doubletteB_points.
///
/// Example: 2 doublettes, 3 deals:
///   [DealPoints(dealNumber: 1, points: 15),   // doubletteA, D1
///    DealPoints(dealNumber: 1, points: 14),   // doubletteB, D1
///    DealPoints(dealNumber: 2, points: 10),   // doubletteA, D2
///    DealPoints(dealNumber: 2, points: 11),   // doubletteB, D2
///    ...]
///   Returns: [29, 21, ...] → sums for D1, D2, ...
List<int> computeTableDealSums(List<DealPoints> allDealPoints) {
  if (allDealPoints.isEmpty) return [];

  // Group by dealNumber, sum across all doublettes
  final sums = <int, int>{};
  for (final dp in allDealPoints) {
    sums[dp.dealNumber] = (sums[dp.dealNumber] ?? 0) + dp.points;
  }

  // Return sums in order of dealNumber
  final sorted = sums.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  return sorted.map((e) => e.value).toList();
}

/// Determines if a deal sum should be highlighted orange.
///
/// Returns true when:
/// - sum ≠ 0 AND sum ≠ maxPointsPerDeal
///
/// Returns false when:
/// - sum = 0 OR sum = maxPointsPerDeal
bool shouldHighlightDealSum(int dealSum, int maxPointsPerDeal) {
  return dealSum != 0 && dealSum != maxPointsPerDeal;
}

/// Gets text color for deal sum based on highlight logic.
Color getDealSumColor(int dealSum, int maxPointsPerDeal) {
  return shouldHighlightDealSum(dealSum, maxPointsPerDeal)
      ? Colors.orange
      : Colors.black;
}
