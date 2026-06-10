// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_utils.dart';

void main() {
  widgetDbTest('App home page', (tester, db) async {
    // Build our app and trigger a frame.
    await pumpTestApp(tester, db);

    // Verify that the welcome message is displayed.
    expect(find.text('Bienvenue !'), findsOneWidget);
    expect(find.text('Belotable'), findsOneWidget);
    expect(find.text('Créer un nouveau concours'), findsOneWidget);
    expect(find.byKey(const Key('home_info_button')), findsOneWidget);
  });
}
