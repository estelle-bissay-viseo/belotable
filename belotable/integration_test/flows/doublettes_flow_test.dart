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
    'Deleting in-play doublette is blocked with error message',
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

      // Doublette status should remain unchanged (not converted to abandon)
      final tdAfterDelete = await db.manchesDao.findTableDoublette(
        concoursId: 'c-2',
        doubletteId: 1,
      );
      expect(tdAfterDelete?.statut, TableDoubletteStatut.enJeu);

      // Doublette should still be in the database
      final registered = await db.doublettesDao.findDoublettesByConcoursId(
        'c-2',
      );
      expect(registered.map((d) => d.doubletteId), containsAll([1, 2]));

      // Error snackbar should appear (check for presence, not exact text)
      expect(
        find.byType(SnackBar),
        findsOneWidget,
      );

      // Doublettes should still be visible
      expect(find.text('Les As'), findsOneWidget);
      expect(find.text('Les Rois'), findsOneWidget);
    },
  );

  e2eTest(
    'Doublettes flow',
    'Points history is displayed correctly after manche update',
    (tester, db) async {
      const concoursId = 'concours-doublettes-flow';

      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          // Create concours
          await database.concoursDao.insertConcours(
            Concours(
              id: concoursId,
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
              nombreDonnesParManche: 2,
              reglesJeu: 'Règles originales',
            ),
          );

          // Create 5 doublettes
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Alice',
            joueurB: 'Bob',
            nomEquipe: 'Les As',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Charlie',
            joueurB: 'Diana',
            nomEquipe: 'Les Pros',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Eve',
            joueurB: 'Frank',
            nomEquipe: 'Les Experts',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Grace',
            joueurB: 'Henry',
            nomEquipe: 'Les Champions',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Iris',
            joueurB: 'Jack',
            nomEquipe: 'Les Stars',
          );
        },
      );

      // Navigate to concours list
      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      // Open concours detail
      await tester.tap(
        find.byKey(const Key('concours_manage_button_$concoursId')),
      );
      await tester.pumpAndSettle();

      // Click prepare manche button
      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      // Confirm manche creation in dialog
      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      // Verify success message
      expect(
        find.text('Manche créée avec succès'),
        findsOneWidget,
      );

      // Wait a moment for navigation
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_manche_button_1')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      // Click on the first manche button to view it
      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_1')),
      );
      await tester.pumpAndSettle();

      // Verify manche page is displayed
      expect(
        find.byKey(const Key('manche_page_tables_list')),
        findsOneWidget,
      );

      // Fill first table results
      await tester.enterText(
        find.byKey(const Key('points_field_1_1_1')),
        '100',
      );
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('points_field_1_1_2')),
        '50',
      );
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('total_field_1_1'))).data,
        '150',
      );
      await tester.tap(
        find.byKey(const Key('statut_dropdown_1_1')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_item_1_1_gagne')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('points_field_1_2_1')),
        '62',
      );
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('points_field_1_2_2')),
        '150',
      );
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('total_field_1_2'))).data,
        '212',
      );
      await tester.tap(
        find.byKey(const Key('statut_dropdown_1_2')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_item_1_2_perdu')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      // Go back to concours detail
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      // Verify points history is displayed correctly in first doublette
      await tester.tap(
        find.byKey(const Key('concours_detail_doublettes_button')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(
          const Key('doublette_manage_button_concours-doublettes-flow_1'),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const Key('doublette_detail_nom_equipe_field')),
            )
            .controller!
            .text,
        'Les As',
      );

      // Points history
      expect(
        find.byKey(const Key('doublette_points_history_table')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('doublette_points_history_manche_1')),
        findsOneWidget,
      );
      expect(
        tester
            .widget<Text>(
              find.byKey(const Key('doublette_points_history_manche_1')),
            )
            .data,
        'Manche 1',
      );
      expect(
        find.byKey(const Key('doublette_points_history_points_1')),
        findsOneWidget,
      );
      expect(
        tester
            .widget<Text>(
              find.byKey(const Key('doublette_points_history_points_1')),
            )
            .data,
        '150',
      );
      expect(
        find.byKey(const Key('doublette_points_history_statut_1')),
        findsOneWidget,
      );
      expect(
        tester
            .widget<Text>(
              find.byKey(const Key('doublette_points_history_statut_1')),
            )
            .data,
        'Gagné',
      );
      expect(
        find.byKey(const Key('doublette_points_history_opponent_1')),
        findsOneWidget,
      );
      expect(
        tester
            .widget<Text>(
              find.byKey(const Key('doublette_points_history_opponent_1')),
            )
            .data,
        'Les Pros (#2)',
      );
      expect(
        find.byKey(const Key('doublette_points_total')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('doublette_points_total')),
          matching: find.text('150'),
        ),
        findsOneWidget,
      );
    },
  );
}
