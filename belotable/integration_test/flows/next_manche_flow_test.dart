import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Create subsequent manche (manche 2+) when previous is finished
  e2eTest(
    'Next manche flow',
    'User finishes manche 1 and creates manche 2',
    (tester, db) async {
      const concoursId = 'uc1-next-manche-flow';

      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: concoursId,
              date: DateTime(2026, 6, 15),
              lieu: 'Salle B',
              organisateur: 'Club B',
              nombreDonnesParManche: 2,
              reglesJeu: 'Règles standard',
            ),
          );

          // Create 2 doublettes
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Alice',
            joueurB: 'Bob',
            nomEquipe: 'Team A',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Charlie',
            joueurB: 'Diana',
            nomEquipe: 'Team B',
          );
        },
      );

      // Create manche 1
      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_$concoursId')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      // Verify manche 1 created
      expect(find.text('Manche créée avec succès'), findsOneWidget);

      // Navigate to manche 1
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_manche_button_1')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_1')),
      );
      await tester.pumpAndSettle();

      // Mark both doublettes as finished (gagne)
      await tester.tap(
        find.byKey(const Key('statut_dropdown_1_1')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_item_1_1_gagne')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('statut_dropdown_1_2')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_item_1_2_gagne')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      // Go back to concours detail
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      // Verify manche 2 button is now available
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, 200),
      );
      await tester.pumpAndSettle();

      // Create manche 2
      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      // Verify manche 2 created
      expect(find.text('Manche créée avec succès'), findsOneWidget);

      // Verify manche 2 exists in UI
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_manche_button_2')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('concours_detail_manche_button_2')),
        findsOneWidget,
      );

      // Click manche 2 and verify it contains same doublettes
      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_2')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('manche_page_tables_list')),
        findsOneWidget,
      );
      expect(find.text('Team A (#1)'), findsOneWidget);
      expect(find.text('Team B (#2)'), findsOneWidget);
    },
  );

  // Block manche creation if previous is not finished
  e2eTest(
    'Next manche flow',
    'User cannot create manche 2 if manche 1 still in progress',
    (tester, db) async {
      const concoursId = 'uc1-blocking-test';

      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: concoursId,
              date: DateTime(2026, 6, 15),
              lieu: 'Salle B',
              organisateur: 'Club B',
              nombreDonnesParManche: 2,
              reglesJeu: 'Règles standard',
            ),
          );

          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Alice',
            joueurB: 'Bob',
            nomEquipe: 'Team A',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Charlie',
            joueurB: 'Diana',
            nomEquipe: 'Team B',
          );
        },
      );

      // Create manche 1
      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_$concoursId')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manche créée avec succès'), findsOneWidget);

      // Try to create manche 2 without finishing manche 1
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, 200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      // Verify error message
      expect(
        find.text('Manche précédente non terminée'),
        findsOneWidget,
      );
    },
  );

  // Auto-assign doublette to manche 1 while open
  e2eTest(
    'Next manche flow',
    'New doublette auto-assigned to manche 1 while open',
    (tester, db) async {
      const concoursId = 'uc3-auto-assign-test';

      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: concoursId,
              date: DateTime(2026, 6, 15),
              lieu: 'Salle B',
              organisateur: 'Club B',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles standard',
            ),
          );

          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Alice',
            joueurB: 'Bob',
            nomEquipe: 'Team A',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Charlie',
            joueurB: 'Diana',
            nomEquipe: 'Team B',
          );
        },
      );

      // Create manche 1
      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_$concoursId')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manche créée avec succès'), findsOneWidget);

      // Navigate to doublettes to add new one
      await tester.tap(
        find.byKey(const Key('concours_detail_doublettes_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('doublettes_list_add_button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_a_field')),
        'Eve',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_b_field')),
        'Frank',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_nom_equipe_field')),
        'Team C',
      );

      await tester.tap(
        find.byKey(const Key('doublette_creation_validate_button')),
      );
      await tester.pumpAndSettle();

      // Go back and verify manche 1 now contains new doublette
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_manche_button_1')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_1')),
      );
      await tester.pumpAndSettle();

      // Verify new doublette is in manche 1
      expect(find.text('Team C (#3)'), findsOneWidget);
    },
  );

  // Block doublette creation after manche 1 finished
  e2eTest(
    'Next manche flow',
    'Cannot create doublette after manche 1 finished',
    (tester, db) async {
      const concoursId = 'uc4-block-doublette-test';

      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: concoursId,
              date: DateTime(2026, 6, 15),
              lieu: 'Salle B',
              organisateur: 'Club B',
              nombreDonnesParManche: 2,
              reglesJeu: 'Règles standard',
            ),
          );

          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Alice',
            joueurB: 'Bob',
            nomEquipe: 'Team A',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Charlie',
            joueurB: 'Diana',
            nomEquipe: 'Team B',
          );
        },
      );

      // Create manche 1
      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_$concoursId')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      // Navigate to manche and finish all doublettes
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_manche_button_1')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_1')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('statut_dropdown_1_1')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_item_1_1_gagne')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('statut_dropdown_1_2')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_item_1_2_gagne')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      // Go back and try to create new doublette
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_doublettes_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('doublettes_list_add_button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_a_field')),
        'Eve',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_joueur_b_field')),
        'Frank',
      );
      await tester.enterText(
        find.byKey(const Key('doublette_creation_nom_equipe_field')),
        'Team C',
      );

      await tester.tap(
        find.byKey(const Key('doublette_creation_validate_button')),
      );
      await tester.pumpAndSettle();

      // Verify that we see an error dialog or snackbar
      // Verify error message
      expect(
        find.text(
          // ignore: lines_longer_than_80_chars because UI test
          'Vous ne pouvez pas ajouter de doublettes car la première manche est terminée.',
        ),
        findsOneWidget,
      );
      // The page should still show the form (not navigated away)
      expect(
        find.byKey(const Key('doublette_creation_nom_equipe_field')),
        findsOneWidget,
      );
    },
  );

  // Deterministic distribution by ranking (points desc, then date asc)
  e2eTest(
    'Next manche flow',
    'Doublettes distributed by ranking (points desc, date asc)',
    (tester, db) async {
      const concoursId = 'uc2-ranking-distribution';

      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: concoursId,
              date: DateTime(2026, 6, 15),
              lieu: 'Salle B',
              organisateur: 'Club B',
              nombreDonnesParManche: 1,
              reglesJeu: 'Règles standard',
            ),
          );

          // Create 4 doublettes (registration order: D1, D2, D3, D4)
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Alice',
            joueurB: 'Bob',
            nomEquipe: 'Team1',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Charlie',
            joueurB: 'Diana',
            nomEquipe: 'Team2',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Eve',
            joueurB: 'Frank',
            nomEquipe: 'Team3',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Grace',
            joueurB: 'Henry',
            nomEquipe: 'Team4',
          );
        },
      );

      // Navigate to concours
      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_$concoursId')),
      );
      await tester.pumpAndSettle();

      // Create manche 1
      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manche créée avec succès'), findsOneWidget);

      // Navigate to manche 1
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_manche_button_1')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_1')),
      );
      await tester.pumpAndSettle();

      // With 4 doublettes and numberOfDonnesParManche=1:
      // There will be 2 tables
      // table 1 : team1 + team2
      // table 2 : team3 + team4

      expect(
        tester.widget<Text>(find.byKey(const Key('doublette_name_1_1'))).data,
        'Team1 (#1)',
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('doublette_name_1_2'))).data,
        'Team2 (#2)',
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('doublette_name_2_3'))).data,
        'Team3 (#3)',
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('doublette_name_2_4'))).data,
        'Team4 (#4)',
      );

      // Input points: T1=100, T2=50, T3=100, T4=30
      await tester.enterText(
        find.byKey(const Key('points_field_1_1_1')),
        '100',
      );
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('points_field_1_2_1')),
        '50',
      );
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('points_field_2_3_1')),
        '100',
      );
      await tester.tap(find.byType(Scaffold), warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('points_field_2_4_1')),
        '30',
      );
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();

      // Mark all as finished
      await tester.tap(
        find.byKey(const Key('statut_dropdown_1_2')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_item_1_2_perdu')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(
        find.byKey(const Key('table_card_2')),
        find.byKey(const Key('manche_page_tables_list')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_2_4')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('statut_dropdown_item_2_4_perdu')),
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();

      // Go back to concours detail
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      // Create manche 2
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, 200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();

      // Navigate to manche 2
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_manche_button_2')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_2')),
      );
      await tester.pumpAndSettle();

      // Verify distribution order
      // Expected manche this ranking: D1(100), D3(100), D2(50), D4(30)
      // So table 1 = team1 + team3 and table2 = team2 + team4
      expect(
        tester.widget<Text>(find.byKey(const Key('doublette_name_1_1'))).data,
        'Team1 (#1)',
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('doublette_name_1_3'))).data,
        'Team3 (#3)',
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('doublette_name_2_2'))).data,
        'Team2 (#2)',
      );
      expect(
        tester.widget<Text>(find.byKey(const Key('doublette_name_2_4'))).data,
        'Team4 (#4)',
      );
    },
  );
}
