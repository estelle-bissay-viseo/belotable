import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';

/// Aggregated current-round data shown on the display screen.
class DisplayData {
  /// Creates display data. [manche] is null when the concours has no round.
  const DisplayData({this.manche, this.tables = const []});

  /// Round with the highest numero for the concours, or null if none exists.
  final Manche? manche;

  /// Table assignments for [manche], ordered by table numero.
  final List<TableDeJeu> tables;
}
