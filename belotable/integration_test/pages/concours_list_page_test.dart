import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Concours list page',
    'User can open concours list page and create concours from plus button',
    (tester, db) async {
      await pumpTestApp(tester, db);

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('concours_list_empty_message')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('concours_list_add_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('concours_creation_form')), findsOneWidget);
    },
  );

  e2eTest(
    'Concours list page',
    'Concours are displayed in descending date order with enabled actions',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-oldest',
              date: DateTime(2024, 1, 10),
              lieu: 'Salle A',
              organisateur: 'Club A',
            ),
          );
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-latest',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle B',
              organisateur: 'Club B',
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      final latestDateTop = tester.getTopLeft(find.text('2026-06-08')).dy;
      final oldestDateTop = tester.getTopLeft(find.text('2024-01-10')).dy;
      expect(latestDateTop, lessThan(oldestDateTop));

      final gererButton = tester.widget<IconButton>(
        find
            .ancestor(
              of: find.byIcon(Icons.settings_outlined),
              matching: find.byType(IconButton),
            )
            .first,
      );
      final modifierButton = tester.widget<IconButton>(
        find
            .ancestor(
              of: find.byIcon(Icons.edit_outlined),
              matching: find.byType(IconButton),
            )
            .first,
      );
      final supprimerButton = tester.widget<IconButton>(
        find
            .ancestor(
              of: find.byIcon(Icons.delete_outline),
              matching: find.byType(IconButton),
            )
            .first,
      );

      expect(modifierButton.onPressed, isNotNull);
      expect(gererButton.onPressed, isNotNull);
      expect(supprimerButton.onPressed, isNotNull);
    },
  );

  e2eTest(
    'Concours list page',
    'New concours created from home appears in list immediately on page open',
    (tester, db) async {
      await pumpTestApp(tester, db);

      // Create concours from home page (not via list + button).
      await tester.tap(find.byKey(const Key('home_create_concours_button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('concours_lieu_field')),
        'Salle des Fêtes',
      );
      await tester.enterText(
        find.byKey(const Key('concours_organisateur_field')),
        'Association Belote',
      );
      await tester.tap(find.byKey(const Key('concours_validate_button')));
      await tester.pumpAndSettle();

      // Back on home. Navigate to list.
      expect(find.byKey(const Key('home_body_title')), findsOneWidget);
      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      // Newly created concours must be visible.
      expect(find.text('Salle des Fêtes'), findsOneWidget);
      expect(find.text('Association Belote'), findsOneWidget);
    },
  );

  e2eTest(
    'Concours list page',
    'New concours created via plus button appears in list immediately',
    (tester, db) async {
      await pumpTestApp(tester, db);

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('concours_list_empty_message')),
        findsOneWidget,
      );

      // Create via + button from within list page.
      await tester.tap(find.byKey(const Key('concours_list_add_button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('concours_lieu_field')),
        'Gymnase Municipal',
      );
      await tester.enterText(
        find.byKey(const Key('concours_organisateur_field')),
        'Club Nord',
      );
      await tester.tap(find.byKey(const Key('concours_validate_button')));
      await tester.pumpAndSettle();

      // Back on list page — new concours must be visible.
      expect(find.byKey(const Key('concours_list_table')), findsOneWidget);
      expect(find.text('Gymnase Municipal'), findsOneWidget);
      expect(find.text('Club Nord'), findsOneWidget);
    },
  );
}
