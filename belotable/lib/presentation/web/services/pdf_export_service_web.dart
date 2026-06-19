import 'dart:js_interop';
import 'dart:typed_data';

import 'package:belotable/presentation/shared/services/pdf_export_service.dart';
import 'package:web/web.dart' as web;

/// Implementation of PDF export service for web platforms.
class WebPdfExportService implements PdfExportService {
  @override
  Future<void> save(Uint8List bytes) async {
    final buffer = bytes.buffer.toJS;
    final parts = <JSAny>[buffer].toJS;
    final blob = web.Blob(parts, web.BlobPropertyBag(type: 'application/pdf'));
    final url = web.URL.createObjectURL(blob);

    web.HTMLAnchorElement()
      ..href = url
      ..download = 'concours.pdf'
      ..click();

    web.URL.revokeObjectURL(url);
  }

  @override
  Future<void> saveAndOpen(Uint8List bytes) async {
    // On web, we can only trigger a download.
    await save(bytes);
  }
}

/// Returns the appropriate PdfExportService implementation.
PdfExportService getPdfExportService() {
  return WebPdfExportService();
}
