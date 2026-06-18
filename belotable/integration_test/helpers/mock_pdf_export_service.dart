import 'dart:io';
import 'dart:typed_data';

import 'package:belotable/presentation/shared/services/pdf_export_service.dart';

/// Mock implementation for testing PDF export without user interaction.
class MockPdfExportService implements PdfExportService {
  /// Stores saved PDF bytes for verification.
  Uint8List? savedBytes;

  /// Path where file was saved during last save call.
  String? lastSavedPath;

  /// Gets temp directory path for test files.
  static String get tempDir {
    return Directory.systemTemp.createTempSync('belotable_test_').path;
  }

  @override
  Future<void> save(Uint8List bytes) async {
    savedBytes = bytes;
    final dir = Directory(tempDir);
    final path = '${dir.path}/concours.pdf';
    lastSavedPath = path;
    final file = File(path);
    await file.writeAsBytes(bytes);
  }

  @override
  Future<void> saveAndOpen(Uint8List bytes) async {
    await save(bytes);
    // Don't actually open in tests
  }

  /// Resets mock state for next test.
  void reset() {
    savedBytes = null;
    lastSavedPath = null;
  }

  /// Cleans up temp files created during test.
  Future<void> cleanup() async {
    if (lastSavedPath != null) {
      final file = File(lastSavedPath!);
      if (file.existsSync()) {
        await file.delete();
      }
    }
    reset();
  }
}
