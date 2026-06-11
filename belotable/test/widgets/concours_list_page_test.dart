import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_utils.dart';

void main() {
  widgetDbTest('User can open concours list and see empty message', (
    tester,
    db,
  ) async {
    await pumpTestApp(tester, db);

    await tester.tap(find.byKey(const Key('home_list_concours_button')));
    await tester.pumpAndSettle();

    expect(find.text('Liste des concours'), findsOneWidget);
    expect(
      find.byKey(const Key('concours_list_empty_message')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('concours_list_add_button')), findsOneWidget);
  });

  widgetDbTest('Concours list displays sorted rows and action states', (
    tester,
    db,
  ) async {
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

    expect(find.byKey(const Key('concours_list_table')), findsOneWidget);

    final latestDateTop = tester.getTopLeft(find.text('2026-06-08')).dy;
    final oldestDateTop = tester.getTopLeft(find.text('2024-01-10')).dy;
    expect(latestDateTop, lessThan(oldestDateTop));

    final gererButtons = tester.widgetList<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.settings_outlined),
        matching: find.byType(IconButton),
      ),
    );
    final supprimerButtons = tester.widgetList<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.delete_outline),
        matching: find.byType(IconButton),
      ),
    );

    expect(gererButtons, hasLength(2));
    expect(supprimerButtons, hasLength(2));

    for (final button in gererButtons) {
      expect(button.onPressed, isNull);
    }
    for (final button in supprimerButtons) {
      expect(button.onPressed, isNotNull);
    }
  });
}
