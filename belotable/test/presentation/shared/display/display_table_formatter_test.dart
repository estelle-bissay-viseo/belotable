import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';
import 'package:belotable/presentation/shared/display/display_table_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

TableDoublette _doublette({
  required int doubletteId,
  required String nomEquipe,
}) {
  return TableDoublette(
    id: doubletteId,
    tableId: 1,
    concoursId: 'concours-1',
    doubletteId: doubletteId,
    points: 0,
    statut: TableDoubletteStatut.enAttente,
    nomEquipe: nomEquipe,
  );
}

void main() {
  group('formatPairLabel', () {
    test('formats team name with registration id', () {
      final doublette = _doublette(doubletteId: 3, nomEquipe: 'Les Aces');
      expect(formatPairLabel(doublette), 'Les Aces (#3)');
    });
  });

  group('buildDisplaySlotLabels', () {
    test('returns both pair labels for a full table', () {
      final table = TableDeJeu(
        id: 1,
        mancheId: 1,
        numero: 1,
        statut: TableDeJeuStatut.enAttente,
        doublettes: [
          _doublette(doubletteId: 1, nomEquipe: 'Equipe A'),
          _doublette(doubletteId: 2, nomEquipe: 'Equipe B'),
        ],
      );

      expect(
        buildDisplaySlotLabels(table),
        ['Equipe A (#1)', 'Equipe B (#2)'],
      );
    });

    test('pads a missing second pair with an empty slot placeholder', () {
      final table = TableDeJeu(
        id: 1,
        mancheId: 1,
        numero: 1,
        statut: TableDeJeuStatut.enAttente,
        doublettes: [_doublette(doubletteId: 1, nomEquipe: 'Equipe A')],
      );

      expect(
        buildDisplaySlotLabels(table),
        ['Equipe A (#1)', displayEmptySlotLabel],
      );
    });

    test('returns an empty-slot pair for a table with no assignment', () {
      const table = TableDeJeu(
        id: 1,
        mancheId: 1,
        numero: 1,
        statut: TableDeJeuStatut.enAttente,
        doublettes: [],
      );

      expect(
        buildDisplaySlotLabels(table),
        [displayEmptySlotLabel, displayEmptySlotLabel],
      );
    });
  });
}
