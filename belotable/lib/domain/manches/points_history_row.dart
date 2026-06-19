/// Row data for doublette points history per manche.
class PointsHistoryRow {
  /// Creates row with manche number, points, status, and opponent info.
  PointsHistoryRow({
    required this.mancheNum,
    required this.points,
    required this.statut,
    required this.opponentName,
    required this.opponentId,
  });

  /// Round number.
  final int mancheNum;

  /// Points scored.
  final int points;

  /// Match status label.
  final String statut;

  /// Opponent doublette name.
  final String opponentName;

  /// Opponent doublette id.
  final int opponentId;
}
