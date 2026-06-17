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

  e2eTest('Home page', 'Home page displays everything', (
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
    expect(find.byKey(const Key('home_body_title')), findsOneWidget);

    expect(find.text('Créer un nouveau concours'), findsOneWidget);
    expect(
      find.byKey(const Key('home_create_concours_button')),
      findsOneWidget,
    );

    expect(find.text('Liste des concours'), findsOneWidget);
    expect(find.byKey(const Key('home_list_concours_button')), findsOneWidget);

    expect(find.byKey(const Key('home_info_button')), findsOneWidget);
  });
}
