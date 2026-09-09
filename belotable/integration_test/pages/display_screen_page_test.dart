import 'package:belotable/data/repositories/drift_concours_repository.dart';
import 'package:belotable/data/repositories/drift_doublette_repository.dart';
import 'package:belotable/data/repositories/drift_manche_repository.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/manches/create_premiere_manche_use_case.dart';
import 'package:belotable/main.dart';
import 'package:belotable/presentation/shared/display/display_screen_page.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/mock_display_window_service.dart';
import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Display screen',
    'User opens display screen from Le jour J section',
    (tester, db) async {
      const concoursId = 'concours-display-open';
      final mockDisplayWindowService = MockDisplayWindowService();

      await db.concoursDao.insertConcours(
        Concours(
          id: concoursId,
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          reglesJeu: 'Règles originales',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            displayWindowServiceProvider.overrideWithValue(
              mockDisplayWindowService,
            ),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('home_list_concours_button')),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('concours_manage_button_$concoursId')),
      );
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_open_display_button')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('concours_detail_open_display_button')),
        findsOneWidget,
      );

      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('concours_detail_open_display_button')),
      );
      await tester.pumpAndSettle();

      expect(mockDisplayWindowService.openedConcoursIds, [concoursId]);

      // Clicking again opens another independent instance (AC-04).
      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('concours_detail_open_display_button')),
      );
      await tester.pumpAndSettle();

      expect(
        mockDisplayWindowService.openedConcoursIds,
        [concoursId, concoursId],
      );
    },
  );

  e2eTest(
    'Display screen',
    'Display screen shows only logo and refresh when no round exists',
    (tester, db) async {
      const concoursId = 'concours-display-empty';

      await db.concoursDao.insertConcours(
        Concours(
          id: concoursId,
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          reglesJeu: 'Règles originales',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: DisplayScreenPage(concoursId: concoursId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('display_screen_empty_state')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('display_screen_refresh_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('display_screen_round_heading')),
        findsNothing,
      );
      expect(find.byKey(const Key('display_screen_content')), findsNothing);
    },
  );

  e2eTest(
    'Display screen',
    'Display screen shows current round and table assignments',
    (tester, db) async {
      const concoursId = 'concours-display-round';

      await db.concoursDao.insertConcours(
        Concours(
          id: concoursId,
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          reglesJeu: 'Règles originales',
        ),
      );
      await db.doublettesDao.createDoublette(
        concoursId: concoursId,
        joueurA: 'Alice',
        joueurB: 'Bob',
        nomEquipe: 'Les As',
      );
      await db.doublettesDao.createDoublette(
        concoursId: concoursId,
        joueurA: 'Charlie',
        joueurB: 'Diana',
        nomEquipe: 'Les Pros',
      );

      final doubletteRepo = DriftDoubletteRepository(db);
      final mancheRepo = DriftMancheRepository(db);
      final concoursRepo = DriftConcoursRepository(db);
      await CreatePremiereMancheUseCase(
        doubletteRepo,
        mancheRepo,
        concoursRepo,
      ).call(concoursId);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: DisplayScreenPage(concoursId: concoursId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manche 1'), findsOneWidget);
      expect(
        find.byKey(const Key('display_screen_table_row_1')),
        findsOneWidget,
      );
      expect(find.textContaining('Les As (#1)'), findsOneWidget);
      expect(find.textContaining('Les Pros (#2)'), findsOneWidget);
      expect(find.byKey(const Key('display_screen_empty_state')), findsNothing);
    },
  );

  e2eTest(
    'Display screen',
    'Refresh replaces empty state with the round created after initial load',
    (tester, db) async {
      const concoursId = 'concours-display-refresh';

      await db.concoursDao.insertConcours(
        Concours(
          id: concoursId,
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          reglesJeu: 'Règles originales',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: DisplayScreenPage(concoursId: concoursId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('display_screen_empty_state')),
        findsOneWidget,
      );

      // A round is created after the display screen was first loaded.
      await db.doublettesDao.createDoublette(
        concoursId: concoursId,
        joueurA: 'Alice',
        joueurB: 'Bob',
        nomEquipe: 'Les As',
      );
      final doubletteRepo = DriftDoubletteRepository(db);
      final mancheRepo = DriftMancheRepository(db);
      final concoursRepo = DriftConcoursRepository(db);
      await CreatePremiereMancheUseCase(
        doubletteRepo,
        mancheRepo,
        concoursRepo,
      ).call(concoursId);

      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('display_screen_refresh_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Manche 1'), findsOneWidget);
      expect(find.textContaining('Les As (#1)'), findsOneWidget);
      expect(find.byKey(const Key('display_screen_empty_state')), findsNothing);
    },
  );

  e2eTest(
    'Display screen',
    'Display screen shows an error when the concours does not exist',
    (tester, db) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: DisplayScreenPage(concoursId: 'unknown-concours'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('display_screen_concours_not_found')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('display_screen_refresh_button')),
        findsOneWidget,
      );
    },
  );

  e2eTest(
    'Display screen',
    'Table repartition stays in a single column when height is generous',
    (tester, db) async {
      const concoursId = 'concours-display-columns-one';

      await db.concoursDao.insertConcours(
        Concours(
          id: concoursId,
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          reglesJeu: 'Règles originales',
        ),
      );
      for (var i = 0; i < 12; i++) {
        await db.doublettesDao.createDoublette(
          concoursId: concoursId,
          joueurA: 'Joueur A$i',
          joueurB: 'Joueur B$i',
          nomEquipe: 'Equipe $i',
        );
      }
      final doubletteRepo = DriftDoubletteRepository(db);
      final mancheRepo = DriftMancheRepository(db);
      final concoursRepo = DriftConcoursRepository(db);
      await CreatePremiereMancheUseCase(
        doubletteRepo,
        mancheRepo,
        concoursRepo,
      ).call(concoursId);

      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.binding.setSurfaceSize(const Size(1400, 2000));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: DisplayScreenPage(concoursId: concoursId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 6 tables (12 doublettes) fit in a single column when there is
      // plenty of vertical space.
      expect(find.byType(Table), findsOneWidget);
      expect(
        find.byKey(const Key('display_screen_table_row_6')),
        findsOneWidget,
      );
    },
  );

  e2eTest(
    'Display screen',
    'Table repartition splits into 3 columns when height is limited',
    (tester, db) async {
      const concoursId = 'concours-display-columns-three';

      await db.concoursDao.insertConcours(
        Concours(
          id: concoursId,
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
          nombreDonnesParManche: 8,
          reglesJeu: 'Règles originales',
        ),
      );
      // 12 doublettes => 6 tables of 2, which need to be split into 3
      // columns of 2 tables each once vertical space is constrained.
      for (var i = 0; i < 12; i++) {
        await db.doublettesDao.createDoublette(
          concoursId: concoursId,
          joueurA: 'Joueur A$i',
          joueurB: 'Joueur B$i',
          nomEquipe: 'Equipe $i',
        );
      }
      final doubletteRepo = DriftDoubletteRepository(db);
      final mancheRepo = DriftMancheRepository(db);
      final concoursRepo = DriftConcoursRepository(db);
      await CreatePremiereMancheUseCase(
        doubletteRepo,
        mancheRepo,
        concoursRepo,
      ).call(concoursId);

      addTearDown(() => tester.binding.setSurfaceSize(null));
      // Width stays generous (enough for 3+ columns); height is limited so
      // only 2 data rows fit per column, forcing a 3-column split for 6
      // tables.
      await tester.binding.setSurfaceSize(const Size(1400, 330));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [databaseProvider.overrideWithValue(db)],
          child: const MaterialApp(
            home: DisplayScreenPage(concoursId: concoursId),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Table), findsNWidgets(3));
      // All 6 tables are still rendered, split across the 3 columns.
      for (var numero = 1; numero <= 6; numero++) {
        expect(
          find.byKey(Key('display_screen_table_row_$numero')),
          findsOneWidget,
        );
      }
    },
  );
}
