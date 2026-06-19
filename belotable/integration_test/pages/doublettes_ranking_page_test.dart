import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Doublettes Ranking Page',
    'Ranking button is not visible when no manches exist',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-ranking-no-manche',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_id-ranking-no-manche')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('concours_detail_ranking_button')),
        findsNothing,
      );
    },
  );

  e2eTest(
    'Doublettes Ranking Page',
    'Ranking button is visible when at least one manche exists',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-ranking-with-manche',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );

          final d1 = await database.doublettesDao.createDoublette(
            concoursId: 'id-ranking-with-manche',
            joueurA: 'A1',
            joueurB: 'B1',
            nomEquipe: 'E1',
          );
          final d2 = await database.doublettesDao.createDoublette(
            concoursId: 'id-ranking-with-manche',
            joueurA: 'A2',
            joueurB: 'B2',
            nomEquipe: 'E2',
          );

          final mancheRow = await database.manchesDao.insertManche(
            ManchesTableCompanion.insert(
              concoursId: 'id-ranking-with-manche',
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
              concoursId: 'id-ranking-with-manche',
              doubletteId: d1.doubletteId,
            ),
          );
          await database.manchesDao.insertTableDoublette(
            TableDoublettesTableCompanion.insert(
              tableId: tableRow.id,
              concoursId: 'id-ranking-with-manche',
              doubletteId: d2.doubletteId,
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_id-ranking-with-manche')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('concours_detail_ranking_button')),
        findsOneWidget,
      );
    },
  );

  e2eTest(
    'Doublettes Ranking Page',
    'Ranking button navigates to ranking page with sorted doublettes',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-ranking-nav',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );

          final d1 = await database.doublettesDao.createDoublette(
            concoursId: 'id-ranking-nav',
            joueurA: 'A1',
            joueurB: 'B1',
            nomEquipe: 'Team A',
          );
          final d2 = await database.doublettesDao.createDoublette(
            concoursId: 'id-ranking-nav',
            joueurA: 'A2',
            joueurB: 'B2',
            nomEquipe: 'Team B',
          );

          final mancheRow = await database.manchesDao.insertManche(
            ManchesTableCompanion.insert(
              concoursId: 'id-ranking-nav',
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
              concoursId: 'id-ranking-nav',
              doubletteId: d1.doubletteId,
            ),
          );
          await database.manchesDao.insertTableDoublette(
            TableDoublettesTableCompanion.insert(
              tableId: tableRow.id,
              concoursId: 'id-ranking-nav',
              doubletteId: d2.doubletteId,
            ),
          );
        },
      );

      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_manage_button_id-ranking-nav')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const Key('concours_detail_ranking_button')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('doublettes_ranking_table')),
        findsOneWidget,
      );
      expect(find.text('Classement des doublettes'), findsOneWidget);
    },
  );
}
