import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Manches flow',
    'User creates first manche with 5 pairs and verifies auto-distribution',
    (tester, db) async {
      const concoursId = 'concours-manches-flow';

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
              nombreDonnesParManche: 8,
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

      // Verify the prepare manche button exists
      expect(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
        findsOneWidget,
      );

      // Click prepare manche button
      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      // Confirm manche creation in dialog
      expect(
        find.byKey(const Key('prepare_manche_confirm_button')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      // Verify success message
      expect(
        find.text('Première manche créée avec succès'),
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

      // Verify we have exactly 3 tables (5 pairs = 2+2+1 distribution)
      expect(
        find.byKey(const Key('table_card_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('table_card_2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('table_card_3')),
        findsOneWidget,
      );

      // Verify last table (table 3) initially has 1 pair
      expect(
        find.byKey(const Key('td_row_3_5')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('td_row_3_6')),
        findsNothing,
      );
    },
  );

  e2eTest(
    'Manches flow',
    'User adds a pair to last table and verifies it now contains 2 pairs',
    (tester, db) async {
      const concoursId = 'concours-manches-flow';

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
              nombreDonnesParManche: 8,
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

      // Verify the prepare manche button exists
      expect(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
        findsOneWidget,
      );

      // Click prepare manche button
      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      // Confirm manche creation in dialog
      expect(
        find.byKey(const Key('prepare_manche_confirm_button')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      // Verify success message
      expect(
        find.text('Première manche créée avec succès'),
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

      // Verify we have exactly 3 tables (5 pairs = 2+2+1 distribution)
      expect(
        find.byKey(const Key('table_card_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('table_card_2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('table_card_3')),
        findsOneWidget,
      );

      // Verify last table (table 3) initially has 1 pair
      expect(
        find.byKey(const Key('td_row_3_5')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('td_row_3_6')),
        findsNothing,
      );

      // Now add a 6th pair to the last table directly via database
      // First, navigate back to concours detail to trigger database update
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      // Create the 6th doublette
      await tester.tap(
        find.byKey(const Key('concours_detail_doublettes_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('doublettes_list_add_button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_a_field')),
        'Kevin',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_b_field')),
        'Laura',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_nom_equipe_field')),
        'Les Vainqueurs',
      );
      await tester.tap(
        find.byKey(const Key('doublette_creation_validate_button')),
      );
      await tester.pumpAndSettle();

      // Return to manche view
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_1')),
      );
      await tester.pumpAndSettle();

      // Verify last table now has 2 pairs (d5 and d6)
      expect(
        find.byKey(const Key('td_row_3_5')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('td_row_3_6')),
        findsOneWidget,
      );
      expect(find.text('Les Stars (#5)'), findsOneWidget);
      expect(find.text('Les Vainqueurs (#6)'), findsOneWidget);
    },
  );
}
