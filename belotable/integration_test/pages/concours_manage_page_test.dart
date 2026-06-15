import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Concours detail page',
    'User opens concours management page from list and sees read-only sections',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-detail',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_id-detail')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('concours_detail_form')), findsOneWidget);
      expect(find.text('Informations générales'), findsOneWidget);
      expect(find.text('Gérer un concours'), findsOneWidget);
      expect(find.text('Valider les modifications'), findsNothing);
      expect(find.text('Annuler les modifications'), findsNothing);
      expect(find.byIcon(Icons.delete_outline), findsNothing);
    },
  );

  e2eTest(
    'Concours detail page',
    'User opens manche page and sees immediate-save warning',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-manche-warning',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
            ),
          );

          final d1 = await database.doublettesDao.createDoublette(
            concoursId: 'id-manche-warning',
            joueurA: 'A1',
            joueurB: 'B1',
            nomEquipe: 'E1',
          );
          final d2 = await database.doublettesDao.createDoublette(
            concoursId: 'id-manche-warning',
            joueurA: 'A2',
            joueurB: 'B2',
            nomEquipe: 'E2',
          );

          final mancheRow = await database.manchesDao.insertManche(
            ManchesTableCompanion.insert(
              concoursId: 'id-manche-warning',
              numero: 1,
            ),
          );
          final tableRow = await database.manchesDao.insertTableDeJeu(
            TablesDeJeuTableCompanion.insert(
              mancheId: mancheRow.id,
              numero: 1,
            ),
          );
          await database.manchesDao.insertTableDoublette(
            TableDoublettesTableCompanion.insert(
              tableId: tableRow.id,
              concoursId: 'id-manche-warning',
              doubletteId: d1.doubletteId,
            ),
          );
          await database.manchesDao.insertTableDoublette(
            TableDoublettesTableCompanion.insert(
              tableId: tableRow.id,
              concoursId: 'id-manche-warning',
              doubletteId: d2.doubletteId,
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_id-manche-warning')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_manche_button_1')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('manche_page_autosave_warning')),
        findsOneWidget,
      );
      expect(
        find.text(
          // ignore: lines_longer_than_80_chars because test content
          'Attention: toute modification réalisée sur cet écran est immédiatement enregistrée.',
        ),
        findsOneWidget,
      );
    },
  );
}
