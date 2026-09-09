import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';

/// Placeholder shown for a table slot without an assigned pair.
const displayEmptySlotLabel = '-';

/// Formats one pair label as "Nom (#Id)".
String formatPairLabel(TableDoublette doublette) =>
    '${doublette.nomEquipe} (#${doublette.doubletteId})';

/// Builds the ordered slot labels for a table, padding missing pairs with
/// [displayEmptySlotLabel]. A table always has at most 2 assigned pairs.
List<String> buildDisplaySlotLabels(TableDeJeu table) {
  return List.generate(2, (index) {
    if (index >= table.doublettes.length) {
      return displayEmptySlotLabel;
    }
    return formatPairLabel(table.doublettes[index]);
  });
}
