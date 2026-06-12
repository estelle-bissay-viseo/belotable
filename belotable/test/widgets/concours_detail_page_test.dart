import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_utils.dart';

void main() {
  widgetDbTest('Manage button opens detail with general information section', (
    tester,
    db,
  ) async {
    await pumpTestApp(
      tester,
      db,
      seed: (database) async {
        await database.concoursDao.insertConcours(
          Concours(
            id: 'id-manage',
            date: DateTime(2026, 6, 8),
            lieu: 'Salle A',
            organisateur: 'Club A',
          ),
        );
      },
    );

    await tester.tap(find.byKey(const Key('home_list_concours_button')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('concours_manage_button_id-manage')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('concours_manage_button_id-manage')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('concours_detail_form')), findsOneWidget);
    expect(
      find.byKey(const Key('concours_detail_general_section')),
      findsOneWidget,
    );
    expect(find.text('Informations générales'), findsOneWidget);
    expect(
      find.byKey(const Key('concours_detail_jour_j_section')),
      findsOneWidget,
    );
    expect(find.text('Le jour J'), findsOneWidget);
    expect(
      find.byKey(const Key('concours_detail_doublettes_button')),
      findsOneWidget,
    );

    final idFieldEditable = tester.widget<EditableText>(
      find.descendant(
        of: find.byKey(const Key('concours_detail_id_field')),
        matching: find.byType(EditableText),
      ),
    );
    expect(idFieldEditable.readOnly, isTrue);
  });

  widgetDbTest('Validate modifications saves and returns to concours list', (
    tester,
    db,
  ) async {
    await pumpTestApp(
      tester,
      db,
      seed: (database) async {
        await database.concoursDao.insertConcours(
          Concours(
            id: 'id-update',
            date: DateTime(2026, 6, 8),
            lieu: 'Salle Initiale',
            organisateur: 'Club Initial',
          ),
        );
      },
    );

    await tester.tap(find.byKey(const Key('home_list_concours_button')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('concours_manage_button_id-update')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('concours_manage_button_id-update')),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('concours_detail_lieu_field')),
      'Salle Modifiee',
    );
    await tester.enterText(
      find.byKey(const Key('concours_detail_organisateur_field')),
      'Club Modifie',
    );

    await tester.drag(
      find.byKey(const Key('concours_detail_form')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('concours_detail_validate_button')));
    await tester.pumpAndSettle();

    expect(find.text('Liste des concours'), findsOneWidget);
    expect(find.text('Salle Modifiee'), findsOneWidget);
    expect(find.text('Club Modifie'), findsOneWidget);
  });

  widgetDbTest('Cancel modifications confirms before discarding changes', (
    tester,
    db,
  ) async {
    await pumpTestApp(
      tester,
      db,
      seed: (database) async {
        await database.concoursDao.insertConcours(
          Concours(
            id: 'id-cancel',
            date: DateTime(2026, 6, 8),
            lieu: 'Salle Originale',
            organisateur: 'Club Original',
          ),
        );
      },
    );

    await tester.tap(find.byKey(const Key('home_list_concours_button')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(const Key('concours_manage_button_id-cancel')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('concours_manage_button_id-cancel')),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('concours_detail_lieu_field')),
      'Salle Temporaire',
    );

    await tester.drag(
      find.byKey(const Key('concours_detail_form')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('concours_detail_cancel_button')));
    await tester.pumpAndSettle();

    expect(find.text('Annuler les modifications ?'), findsOneWidget);

    await tester.tap(
      find.byKey(const Key('concours_detail_discard_keep_editing_button')),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('concours_detail_form')), findsOneWidget);

    await tester.drag(
      find.byKey(const Key('concours_detail_form')),
      const Offset(0, -500),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('concours_detail_cancel_button')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('concours_detail_discard_confirm_button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Liste des concours'), findsOneWidget);
    expect(find.text('Salle Originale'), findsOneWidget);
    expect(find.text('Salle Temporaire'), findsNothing);
  });
}
