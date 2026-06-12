import 'package:belotable/domain/concours/concours.dart';
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
}
