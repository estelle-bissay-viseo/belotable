import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest('App common page', 'App bar is visible', (tester, db) async {
    await pumpTestApp(tester, db);

    expect(find.byKey(const Key('app_bar_title')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('app_bar')),
        matching: find.byKey(const Key('app_bar_icon')),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('app_bar')),
        matching: find.byKey(const Key('app_bar_title')),
      ),
      findsOneWidget,
    );
  });
}
