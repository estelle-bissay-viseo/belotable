import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/manches/table_doublette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Doublettes flow',
    'User can create edit and delete doublette from concours detail',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'c-1',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('concours_doublettes_count_c-1')),
        findsOneWidget,
      );
      expect(find.text('0'), findsWidgets);

      await tester.tap(find.byKey(const Key('concours_manage_button_c-1')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_doublettes_button')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('doublettes_list_empty_message')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('doublettes_list_add_button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_a_field')),
        'Alice',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_b_field')),
        'Bob',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_nom_equipe_field')),
        'Les As',
      );
      await tester.tap(
        find.byKey(const Key('doublette_creation_validate_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Les As'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);

      await tester.tap(find.byKey(const Key('doublette_manage_button_c-1_1')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('doublette_detail_nom_equipe_field')),
        'Les Rois',
      );
      await tester.tap(
        find.byKey(const Key('doublette_detail_validate_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Les Rois'), findsOneWidget);

      await tester.tap(find.byKey(const Key('doublette_delete_button_c-1_1')));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('doublettes_list_empty_message')),
        findsOneWidget,
      );

      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('concours_doublettes_count_c-1')),
        findsOneWidget,
      );
      expect(find.text('0'), findsWidgets);
    },
  );

  e2eTest(
    'Doublettes flow',
    'Deleting in-play doublette is blocked and converted to abandon',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'c-2',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle B',
              organisateur: 'Club B',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('concours_manage_button_c-2')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_doublettes_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('doublettes_list_add_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_a_field')),
        'Alice',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_b_field')),
        'Bob',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_nom_equipe_field')),
        'Les As',
      );
      await tester.tap(
        find.byKey(const Key('doublette_creation_validate_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('doublettes_list_add_button')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_a_field')),
        'Chloe',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_b_field')),
        'David',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_nom_equipe_field')),
        'Les Rois',
      );
      await tester.tap(
        find.byKey(const Key('doublette_creation_validate_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('prepare_manche_confirm_button')));
      await tester.pumpAndSettle();

      final mancheRows = await db.manchesDao.findManchesByConcoursId('c-2');
      final tables = await db.manchesDao.findTablesDeJeuByMancheId(
        mancheRows.first.id,
      );
      await db.manchesDao.updateStatutWithRules(
        tableId: tables.first.id,
        concoursId: 'c-2',
        doubletteId: 1,
        statut: TableDoubletteStatut.enJeu,
      );

      final tdBeforeDelete = await db.manchesDao.findTableDoublette(
        concoursId: 'c-2',
        doubletteId: 1,
      );
      expect(tdBeforeDelete?.statut, TableDoubletteStatut.enJeu);

      await tester.tap(
        find.byKey(const Key('concours_detail_doublettes_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('doublette_delete_button_c-2_1')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Supprimer'));
      await tester.pumpAndSettle();

      final tdAfterDelete = await db.manchesDao.findTableDoublette(
        concoursId: 'c-2',
        doubletteId: 1,
      );
      expect(tdAfterDelete?.statut, TableDoubletteStatut.abandon);

      final registered = await db.doublettesDao.findDoublettesByConcoursId(
        'c-2',
      );
      expect(registered.map((d) => d.doubletteId), containsAll([1, 2]));

      expect(find.text('Les As'), findsOneWidget);
      expect(find.text('Les Rois'), findsOneWidget);
    },
  );
}
