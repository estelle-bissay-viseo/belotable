import 'dart:io';

import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/main.dart';
import 'package:belotable/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/mock_pdf_export_service.dart';
import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PDF generation from concours management page', (tester) async {
    final mockPdfService = MockPdfExportService();
    final db = createTestDatabase();

    try {
      // Setup data
      await db.concoursDao.insertConcours(
        Concours(
          id: 'id-pdf-gen',
          date: DateTime(2026, 7, 15),
          lieu: 'Salle de Belote',
          organisateur: 'Club Belote Pro',
          nombreDonnesParManche: 8,
          reglesJeu: 'Règles standards',
        ),
      );

      // Pump app with mocked PDF service
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            databaseProvider.overrideWithValue(db),
            pdfExportServiceProvider.overrideWithValue(mockPdfService),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to concours list
      await tester.tap(find.byKey(const Key('home_list_concours_button')));
      await tester.pumpAndSettle();

      // Open concours management page
      await tester.tap(
        find.byKey(const Key('concours_manage_button_id-pdf-gen')),
      );
      await tester.pumpAndSettle();

      // Verify PDF button exists
      expect(
        find.byKey(const Key('concours_detail_pdf_table_button')),
        findsOneWidget,
        reason: 'PDF button should be visible in concours detail page',
      );

      // Tap PDF generation button
      await tester.tap(
        find.byKey(const Key('concours_detail_pdf_table_button')),
      );
      await tester.pumpAndSettle();

      // Verify PDF was generated
      expect(
        mockPdfService.savedBytes,
        isNotNull,
        reason: 'Mock service should have received PDF bytes',
      );
      expect(
        mockPdfService.savedBytes!.length,
        greaterThan(0),
        reason: 'PDF bytes should not be empty',
      );

      // Verify file was saved to disk
      expect(
        mockPdfService.lastSavedPath,
        isNotNull,
        reason: 'Save should record file path',
      );

      final file = File(mockPdfService.lastSavedPath!);
      expect(
        file.existsSync(),
        isTrue,
        reason: 'PDF file should exist on disk',
      );

      // Verify file contains valid PDF (check magic bytes)
      final bytes = await file.readAsBytes();
      expect(bytes.length, greaterThan(0));
      expect(bytes[0], 0x25); // %
      expect(bytes[1], 0x50); // P
      expect(bytes[2], 0x44); // D
      expect(bytes[3], 0x46); // F
    } finally {
      await mockPdfService.cleanup();
      await db.close();
    }
  });
}
