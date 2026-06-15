import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_utils.dart';

void main() {
  widgetDbTest('Manage button opens management page in read-only mode', (
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
  });
}
