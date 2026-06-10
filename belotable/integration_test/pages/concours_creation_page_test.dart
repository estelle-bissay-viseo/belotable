import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Concours creation',
    'User can open concours form then cancel',
    (tester, db) async {
      await pumpTestApp(tester, db);

      await tester.tap(find.byKey(const Key('home_create_concours_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('concours_creation_form')), findsOneWidget);

      await tester.tap(find.byKey(const Key('concours_cancel_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_body_title')), findsOneWidget);
    },
  );

  e2eTest(
    'Concours creation',
    'User can submit concours form',
    (tester, db) async {
      await pumpTestApp(tester, db);

      await tester.tap(find.byKey(const Key('home_create_concours_button')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('concours_lieu_field')),
        'Salle des fetes',
      );
      await tester.enterText(
        find.byKey(const Key('concours_organisateur_field')),
        'Association Belote',
      );

      await tester.tap(find.byKey(const Key('concours_validate_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_body_title')), findsOneWidget);
    },
  );
}
