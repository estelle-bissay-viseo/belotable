import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

typedef TestBody = Future<void> Function(WidgetTester tester);

Future<void> takeFlutterScreenshot(WidgetTester tester, String name) async {
  final boundary = tester.firstRenderObject(find.byType(RepaintBoundary))
      as RenderRepaintBoundary;

  final image = await boundary.toImage();
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = '${name}_$timestamp.png';

  final file = File('integration_test/screenshots_failures/$fileName');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData!.buffer.asUint8List());
}

void e2eTest(
  String category,
  String description,
  TestBody body,
) {
  testWidgets(description, (tester) async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    try {
      await body(tester);
    } catch (e) {
      final categoryName = category.replaceAll(' ', '_').toLowerCase();
      final fileName = description
          .replaceAll(' ', '_')
          .toLowerCase();
      final fullFileName = '${categoryName}__$fileName';

      await takeFlutterScreenshot(tester, fullFileName);

      // Re-throw to keep the test marked as failed.
      rethrow;
    }
  });
}
