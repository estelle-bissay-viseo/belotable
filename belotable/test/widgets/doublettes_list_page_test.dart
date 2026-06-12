import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/presentation/shared/doublettes/doublettes_list_page.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_utils.dart';

void main() {
  widgetDbTest('Doublettes list displays rows sorted by id', (
    tester,
    db,
  ) async {
    await db.concoursDao.insertConcours(
      Concours(
        id: 'c-1',
        date: DateTime(2026, 6, 8),
        lieu: 'Salle A',
        organisateur: 'Club A',
      ),
    );
    await db.doublettesDao.createDoublette(
      concoursId: 'c-1',
      joueurA: 'Alice',
      joueurB: 'Bob',
      nomEquipe: 'Equipe A',
    );
    await db.doublettesDao.createDoublette(
      concoursId: 'c-1',
      joueurA: 'Eve',
      joueurB: 'Max',
      nomEquipe: 'Equipe B',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: DoublettesListPage(concoursId: 'c-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('doublettes_list_table')), findsOneWidget);
    final firstIdTop = tester.getTopLeft(find.text('1')).dy;
    final secondIdTop = tester.getTopLeft(find.text('2')).dy;
    expect(firstIdTop, lessThan(secondIdTop));
  });

  widgetDbTest('Concours detail page shows Doublettes button', (
    tester,
    db,
  ) async {
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

    await tester.ensureVisible(
      find.byKey(const Key('concours_manage_button_c-1')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('concours_manage_button_c-1')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('concours_detail_doublettes_button')),
      findsOneWidget,
    );
  });
}
