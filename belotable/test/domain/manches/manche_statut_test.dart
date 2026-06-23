import 'package:belotable/domain/manches/manche_statut.dart';
import 'package:belotable/domain/manches/table_doublette.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MancheStatut', () {
    test('label returns correct French label for enCours', () {
      expect(MancheStatut.enCours.label, equals('En cours'));
    });

    test('label returns correct French label for termine', () {
      expect(MancheStatut.termine.label, equals('Terminé'));
    });

    test('fromDb converts "En cours" to enCours', () {
      expect(MancheStatut.fromDb('En cours'), equals(MancheStatut.enCours));
    });

    test('fromDb converts "Terminé" to termine', () {
      expect(MancheStatut.fromDb('Terminé'), equals(MancheStatut.termine));
    });

    test('fromDb defaults to enCours for unknown value', () {
      expect(MancheStatut.fromDb('Unknown'), equals(MancheStatut.enCours));
    });

    test('fromDoublettes returns enCours when empty list', () {
      final result = MancheStatut.fromDoublettes([]);
      expect(result, equals(MancheStatut.enCours));
    });

    test('fromDoublettes returns enCours when any doublette has enAttente', () {
      final doublettes = [
        const TableDoublette(
          tableId: 1,
          concoursId: 'c1',
          doubletteId: 1,
          points: 0,
          statut: TableDoubletteStatut.enAttente,
          nomEquipe: 'Team A',
        ),
        const TableDoublette(
          tableId: 1,
          concoursId: 'c1',
          doubletteId: 2,
          points: 10,
          statut: TableDoubletteStatut.gagne,
          nomEquipe: 'Team B',
        ),
      ];

      final result = MancheStatut.fromDoublettes(doublettes);
      expect(result, equals(MancheStatut.enCours));
    });

    test('fromDoublettes returns enCours when any doublette has enJeu', () {
      final doublettes = [
        const TableDoublette(
          tableId: 1,
          concoursId: 'c1',
          doubletteId: 1,
          points: 0,
          statut: TableDoubletteStatut.enJeu,
          nomEquipe: 'Team A',
        ),
        const TableDoublette(
          tableId: 1,
          concoursId: 'c1',
          doubletteId: 2,
          points: 10,
          statut: TableDoubletteStatut.gagne,
          nomEquipe: 'Team B',
        ),
      ];

      final result = MancheStatut.fromDoublettes(doublettes);
      expect(result, equals(MancheStatut.enCours));
    });

    test(
      // ignore: lines_longer_than_80_chars because test name
      'fromDoublettes returns termine when all doublettes are in terminal state',
      () {
        final doublettes = [
          const TableDoublette(
            tableId: 1,
            concoursId: 'c1',
            doubletteId: 1,
            points: 0,
            statut: TableDoubletteStatut.perdu,
            nomEquipe: 'Team A',
          ),
          const TableDoublette(
            tableId: 1,
            concoursId: 'c1',
            doubletteId: 2,
            points: 10,
            statut: TableDoubletteStatut.gagne,
            nomEquipe: 'Team B',
          ),
        ];

        final result = MancheStatut.fromDoublettes(doublettes);
        expect(result, equals(MancheStatut.termine));
      },
    );

    test(
      // ignore: lines_longer_than_80_chars because test name
      'fromDoublettes returns termine when all doublettes are gagne or perdu or abandon',
      () {
        final doublettes = [
          const TableDoublette(
            tableId: 1,
            concoursId: 'c1',
            doubletteId: 1,
            points: 0,
            statut: TableDoubletteStatut.abandon,
            nomEquipe: 'Team A',
          ),
          const TableDoublette(
            tableId: 1,
            concoursId: 'c1',
            doubletteId: 2,
            points: 10,
            statut: TableDoubletteStatut.gagne,
            nomEquipe: 'Team B',
          ),
          const TableDoublette(
            tableId: 1,
            concoursId: 'c1',
            doubletteId: 3,
            points: 5,
            statut: TableDoubletteStatut.perdu,
            nomEquipe: 'Team C',
          ),
        ];

        final result = MancheStatut.fromDoublettes(doublettes);
        expect(result, equals(MancheStatut.termine));
      },
    );
  });
}
