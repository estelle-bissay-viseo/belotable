// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_utils.dart';

void main() {
  const packageInfoChannel = MethodChannel(
    'dev.fluttercommunity.plus/package_info',
  );

  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(packageInfoChannel, (methodCall) async {
          if (methodCall.method == 'getAll') {
            return <String, dynamic>{
              'appName': 'Belotable',
              'packageName': 'com.example.belotable',
              'version': '9.9.9-test',
              'buildNumber': '1',
              'buildSignature': '',
              'installerStore': '',
              'installTime': null,
              'updateTime': null,
            };
          }

          return null;
        });
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(packageInfoChannel, null);
  });

  widgetDbTest('User can open information page and go back', (
    tester,
    db,
  ) async {
    await pumpTestApp(tester, db);

    await tester.tap(find.byKey(const Key('home_info_button')));
    await tester.pumpAndSettle();

    expect(find.text('Informations'), findsOneWidget);
    expect(find.byKey(const Key('app_info_version_text')), findsOneWidget);
    expect(find.textContaining('Version : 9.9.9-test'), findsOneWidget);
    expect(find.byKey(const Key('app_info_repo_link_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('app_info_back_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('home_body_title')), findsOneWidget);
  });
}
