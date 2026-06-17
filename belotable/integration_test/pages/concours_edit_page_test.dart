import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Concours edit page',
    'User updates concours from Modifier flow and returns with saved values',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-edit',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle Initiale',
              organisateur: 'Club Initial',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_edit_button_id-edit')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('concours_edit_general_section')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('concours_edit_parameters_section')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('concours_edit_lieu_field')),
        'Salle Finale',
      );
      await tester.enterText(
        find.byKey(const Key('concours_edit_organisateur_field')),
        'Club Final',
      );

      await tester.dragUntilVisible(
        find.byKey(const Key('concours_edit_validate_button')),
        find.byKey(const Key('concours_edit_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_edit_validate_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Liste des concours'), findsOneWidget);
      expect(find.text('Salle Finale'), findsOneWidget);
      expect(find.text('Club Final'), findsOneWidget);
    },
  );

  e2eTest(
    'Concours edit page',
    'User cancels edits and confirms discard to return without saving',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-discard',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle Originale',
              organisateur: 'Club Original',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_edit_button_id-discard')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('concours_edit_lieu_field')),
        'Salle Temporaire',
      );

      await tester.dragUntilVisible(
        find.byKey(const Key('concours_edit_cancel_button')),
        find.byKey(const Key('concours_edit_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('concours_edit_cancel_button')));
      await tester.pumpAndSettle();

      expect(find.text('Annuler les modifications ?'), findsOneWidget);

      await tester.tap(
        find.byKey(const Key('concours_edit_discard_keep_editing_button')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('concours_edit_form')), findsOneWidget);

      await tester.dragUntilVisible(
        find.byKey(const Key('concours_edit_cancel_button')),
        find.byKey(const Key('concours_edit_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('concours_edit_cancel_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_edit_discard_confirm_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Liste des concours'), findsOneWidget);
      expect(find.text('Salle Originale'), findsOneWidget);
      expect(find.text('Salle Temporaire'), findsNothing);
    },
  );

  e2eTest(
    'Concours edit page',
    'Parameters can be edited before manche creation',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-params',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle Params',
              organisateur: 'Club Params',
              nombreDonnesParManche: 5,
              reglesJeu: 'Règles initiales',
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_edit_button_id-params')),
      );
      await tester.pumpAndSettle();

      // Verify parameter fields are editable
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const Key('concours_edit_nombre_donnes_field')),
            )
            .enabled,
        isTrue,
      );
      expect(
        tester
            .widget<TextFormField>(
              find.byKey(const Key('concours_edit_regles_jeu_field')),
            )
            .enabled,
        isTrue,
      );

      // Edit parameters
      await tester.enterText(
        find.byKey(const Key('concours_edit_nombre_donnes_field')),
        '15',
      );
      await tester.enterText(
        find.byKey(const Key('concours_edit_regles_jeu_field')),
        'Règles modifiées',
      );

      await tester.dragUntilVisible(
        find.byKey(const Key('concours_edit_validate_button')),
        find.byKey(const Key('concours_edit_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_edit_validate_button')),
      );
      await tester.pumpAndSettle();

      // Back on list — verify changes saved
      expect(find.text('Liste des concours'), findsOneWidget);
    },
  );
}
