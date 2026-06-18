import 'dart:typed_data';

import 'package:belotable/domain/pdf/models/concours_table_pdf_model.dart';
import 'package:belotable/domain/pdf/repositories/pdf_repository.dart';
import 'package:pdf/widgets.dart' as pw;

/// Implementation of PDF generation for concours table layout.
///
/// Uses package:pdf for rendering. Handles layout and formatting.
class PdfRepositoryImpl implements PdfRepository {
  @override
  Future<Uint8List> generateConcoursTablePdf(
    ConcoursTablePdfModel model,
  ) async {
    final pdf = pw.Document()
      ..addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Concours de Belote',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Lieu: ${model.lieu}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Organisateur: ${model.organisateur}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Date: ${_formatDate(model.date)}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Nombre de doublettes: ${model.nombreDoublettes}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 24),
                pw.Text(
                  'Disposition des tables',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      );

    return Uint8List.fromList(await pdf.save());
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
