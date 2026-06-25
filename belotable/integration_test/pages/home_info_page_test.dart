import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Home info page',
    'User can open app info page and return home',
    (tester, db) async {
      await pumpTestApp(tester, db);

      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('home_info_button')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Informations'), findsOneWidget);
      expect(find.byKey(const Key('app_info_version_text')), findsOneWidget);
      expect(
        find.byKey(const Key('app_info_repo_link_button')),
        findsOneWidget,
      );

      final versionText = tester.widget<Text>(
        find.byKey(const Key('app_info_version_text')),
      );
      expect(versionText.data, isNotNull);
      expect(versionText.data, startsWith('Version : '));

      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('app_info_back_button')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_body_title')), findsOneWidget);
    },
  );
}
