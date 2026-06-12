/// Navigation arguments for the manche management page.
class ManchePageArgs {
  /// Creates navigation arguments for a manche.
  const ManchePageArgs({required this.mancheId, required this.mancheNumero});

  /// Target manche id.
  final int mancheId;

  /// Round number for display.
  final int mancheNumero;
}
