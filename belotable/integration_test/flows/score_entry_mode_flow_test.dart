import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Score entry mode flow',
    'Round score sum and deal sum helpers toggle with entry mode',
    (tester, db) async {
      const concoursId = 'concours-score-entry-mode';

      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: concoursId,
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
              nombreDonnesParManche: 2,
              nombreMaxPointsParDonne: 100,
              reglesJeu: 'Règles originales',
            ),
          );

          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Alice',
            joueurB: 'Bob',
            nomEquipe: 'Team A',
          );
          await database.doublettesDao.createDoublette(
            concoursId: concoursId,
            joueurA: 'Charlie',
            joueurB: 'Diana',
            nomEquipe: 'Team B',
          );
        },
      );

      // Navigate to manche page
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
        find.byKey(const Key('concours_detail_prepare_manche_button')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('concours_detail_prepare_manche_button')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('prepare_manche_confirm_button')),
      );
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(
        find.byKey(const Key('concours_detail_manche_button_1')),
        find.byKey(const Key('concours_detail_form')),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('concours_detail_manche_button_1')),
      );
      await tester.pumpAndSettle();

      // Default mode is "par manche"
      expect(
        tester
            .widget<Switch>(
              find.byKey(const Key('entry_mode_switch_1')),
            )
            .value,
        isFalse,
      );

      // 1: round score sum shown under "score final" in "par manche" mode
      expect(find.byKey(const Key('round_score_sum_1')), findsOneWidget);
      expect(
        tester
            .widget<Text>(
              find
                  .descendant(
                    of: find.byKey(const Key('round_score_sum_1')),
                    matching: find.byType(Text),
                  )
                  .first,
            )
            .data,
        '0',
      );
      // sum == 0 must not be flagged invalid
      expect(
        find.byKey(const Key('round_score_sum_error_1')),
        findsNothing,
      );

      // 1 bis: deal sums stay hidden in "par manche" mode
      expect(find.byKey(const Key('table_sum_1_1')), findsNothing);

      // Deal fields hidden, round score fields editable in "par manche" mode
      expect(
        find.byKey(const Key('round_score_field_1_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('round_score_field_1_2')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('points_field_1_1_1')), findsNothing);

      // 3 + 4: round score sum updates after each entry, invalid when
      // different from 0 and from max points per deal * number of deals
      await tester.enterText(
        find.byKey(const Key('round_score_field_1_1')),
        '100',
      );
      await tester.tap(warnIfMissed: false, find.byType(Scaffold));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Text>(
              find
                  .descendant(
                    of: find.byKey(const Key('round_score_sum_1')),
                    matching: find.byType(Text),
                  )
                  .first,
            )
            .data,
        '100',
      );
      expect(
        find.byKey(const Key('round_score_sum_error_1')),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('round_score_field_1_2')),
        '100',
      );
      await tester.tap(warnIfMissed: false, find.byType(Scaffold));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<Text>(
              find
                  .descendant(
                    of: find.byKey(const Key('round_score_sum_1')),
                    matching: find.byType(Text),
                  )
                  .first,
            )
            .data,
        '200',
      );
      // sum == max points per deal (100) * number of deals (2) is valid
      expect(
        find.byKey(const Key('round_score_sum_error_1')),
        findsNothing,
      );

      // Switch to "par donne" mode
      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('entry_mode_switch_1')),
      );
      await tester.pumpAndSettle();

      // 2 bis: round score sum hidden in "par donne" mode
      expect(find.byKey(const Key('round_score_sum_1')), findsNothing);

      // 2: deal sums shown under deal points in "par donne" mode
      expect(find.byKey(const Key('table_sum_1_1')), findsOneWidget);
      expect(find.byKey(const Key('table_sum_1_2')), findsOneWidget);
      expect(find.byKey(const Key('round_score_field_1_1')), findsNothing);
      expect(find.byKey(const Key('points_field_1_1_1')), findsOneWidget);

      // Entering deal points updates the deal sum
      await tester.enterText(
        find.byKey(const Key('points_field_1_1_1')),
        '60',
      );
      await tester.tap(warnIfMissed: false, find.byType(Scaffold));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('points_field_1_2_1')),
        '40',
      );
      await tester.tap(warnIfMissed: false, find.byType(Scaffold));
      await tester.pumpAndSettle();
      final dealSum1 = tester.widget<InputDecorator>(
        find.byKey(const Key('table_sum_1_1')),
      );
      expect((dealSum1.child! as Text).data, '100');
      expect(dealSum1.decoration.errorText, isNull);

      // Switch back to "par manche": round score preserves recalculated total
      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('entry_mode_switch_1')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('round_score_sum_1')), findsOneWidget);
      expect(find.byKey(const Key('table_sum_1_1')), findsNothing);
      expect(
        tester
            .widget<Text>(
              find
                  .descendant(
                    of: find.byKey(const Key('round_score_sum_1')),
                    matching: find.byType(Text),
                  )
                  .first,
            )
            .data,
        '100',
      );
      expect(
        find.byKey(const Key('round_score_sum_error_1')),
        findsOneWidget,
      );
    },
  );
}
