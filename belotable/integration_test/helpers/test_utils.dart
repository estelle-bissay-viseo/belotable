import 'dart:io';
import 'dart:ui' as ui;

import 'package:belotable/data/database/app_database.dart';
import 'package:belotable/main.dart';
import 'package:belotable/utils/providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

typedef TestBody =
    Future<void> Function(
      WidgetTester tester,
      AppDatabase database,
    );

AppDatabase createTestDatabase() {
  return AppDatabase.withExecutor(
    NativeDatabase.memory(),
  );
}

Future<void> takeFlutterScreenshot(WidgetTester tester, String name) async {
  final boundary =
      tester.firstRenderObject(find.byType(RepaintBoundary))
          as RenderRepaintBoundary;

  final image = await boundary.toImage();
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = '${name}_$timestamp.png';

  final file = File('integration_test/screenshots_failures/$fileName');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData!.buffer.asUint8List());
}

Future<void> pumpTestApp(
  WidgetTester tester,
  AppDatabase db, {
  Future<void> Function(AppDatabase db)? seed,
}) async {
  // seed optionnel
  if (seed != null) {
    await seed(db);
  }

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
      ],
      child: const MyApp(),
    ),
  );

  await tester.pumpAndSettle();
}

void e2eTest(
  String category,
  String description,
  TestBody body,
) {
  testWidgets(description, (tester) async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    final db = createTestDatabase();

    try {
      await body(tester, db);
    } catch (e) {
      final categoryName = category.replaceAll(' ', '_').toLowerCase();
      final fileName = description.replaceAll(' ', '_').toLowerCase();
      final fullFileName = '${categoryName}__$fileName';

      await takeFlutterScreenshot(tester, fullFileName);

      // Re-throw to keep the test marked as failed.
      rethrow;
    } finally {
      await db.close();
    }
  });
}
