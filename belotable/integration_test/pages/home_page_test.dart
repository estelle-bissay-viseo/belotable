import 'package:belotable/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest('Home page', 'Home page displays welcome message', (tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the welcome message is displayed.  
    final titleWidget = tester.widget<Text>(
      find.byKey(const Key('home_body_title')),
    );

    expect(titleWidget.data, 'Bienvenue !');
  });
}
