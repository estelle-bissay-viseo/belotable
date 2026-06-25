import 'dart:typed_data';

import 'package:belotable/domain/pdf/models/concours_table_pdf_model.dart';

/// Repository interface for PDF generation.
abstract class PdfRepository {
  /// Generates PDF bytes for concours table layout.
  ///
  /// Returns PDF as [Uint8List] for portability and testability.
  /// Does not directly access database; depends on caller to provide model.
  Future<Uint8List> generateConcoursTablePdf(ConcoursTablePdfModel model);

  /// Generates PDF bytes for concours doublette layout.
  ///
  /// Returns PDF as [Uint8List] for portability and testability.
  /// Does not directly access database; depends on caller to provide model.
  Future<Uint8List> generateConcoursDoublettePdf(ConcoursTablePdfModel model);
}
