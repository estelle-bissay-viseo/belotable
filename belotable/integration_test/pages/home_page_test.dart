import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest('Home page', 'Home page displays welcome message', (
    tester,
    db,
  ) async {
    // Build the app and trigger a frame.
    await pumpTestApp(tester, db);

    // Verify that the welcome message is displayed.
    final titleWidget = tester.widget<Text>(
      find.byKey(const Key('home_body_title')),
    );

    expect(titleWidget.data, 'Bienvenue !');
    expect(find.byKey(const Key('home_list_concours_button')), findsOneWidget);
  });
}
