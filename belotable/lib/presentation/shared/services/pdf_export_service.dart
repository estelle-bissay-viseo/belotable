import 'dart:typed_data';

import 'package:belotable/presentation/shared/services/pdf_export_service_stub.dart'
    if (dart.library.html) 'package:belotable/presentation/web/services/pdf_export_service_web.dart'
    if (dart.library.io) 'package:belotable/presentation/desktop/services/pdf_export_service_desktop.dart';

/// Abstract service for exporting PDFs.
abstract class PdfExportService {
  /// Saves the given PDF bytes to a file.
  Future<void> save(Uint8List bytes);

  /// Saves the given PDF bytes to a file and opens it.
  Future<void> saveAndOpen(Uint8List bytes);
}

/// Returns the appropriate PdfExportService.
PdfExportService createPdfExportService() => getPdfExportService();
