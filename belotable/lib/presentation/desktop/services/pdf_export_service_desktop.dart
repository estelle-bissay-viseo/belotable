import 'dart:io';
import 'dart:typed_data';

import 'package:belotable/presentation/shared/services/pdf_export_service.dart';
import 'package:file_picker/file_picker.dart';

/// Implementation of PDF export service for desktop platforms.
class DesktopPdfExportService implements PdfExportService {
  @override
  Future<void> save(Uint8List bytes, {String fileName = 'belotable'}) async {
    // Use FilePicker to let the user choose where to save the PDF file.
    final path = await FilePicker.saveFile(
      dialogTitle: 'Enregistrer le PDF',
      fileName: '$fileName.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    // If the user cancels the file picker, path will be null.
    // In that case, we simply return without doing anything.
    if (path == null) return;

    final file = File(path);
    await file.writeAsBytes(bytes);
  }

  @override
  Future<void> saveAndOpen(
    Uint8List bytes, {
    String fileName = 'belotable',
  }) async {
    // Use FilePicker to let the user choose where to save the PDF file.
    final path = await FilePicker.saveFile(
      dialogTitle: 'Enregistrer le PDF',
      fileName: '$fileName.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    // If the user cancels the file picker, path will be null.
    // In that case, we simply return without doing anything.
    if (path == null) return;

    final file = File(path);
    await file.writeAsBytes(bytes);

    // open the PDF file using the default application for PDF files.
    if (Platform.isWindows) {
      await Process.run('start', [path], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', [path]);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [path]);
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }
}

/// Returns the appropriate PdfExportService implementation.
PdfExportService getPdfExportService() {
  return DesktopPdfExportService();
}
