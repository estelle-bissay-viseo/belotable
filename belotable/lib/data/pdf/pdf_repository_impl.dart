import 'dart:math';

import 'package:belotable/domain/pdf/models/concours_table_pdf_model.dart';
import 'package:belotable/domain/pdf/repositories/pdf_repository.dart';
import 'package:belotable/utils/date_format.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

const double _iconRotationDegrees = 15;

/// Implementation of PDF generation for concours table layout.
///
/// Uses package:pdf for rendering. Handles layout and formatting.
class PdfRepositoryImpl implements PdfRepository {
  @override
  Future<Uint8List> generateConcoursTablePdf(
    ConcoursTablePdfModel model,
  ) async {
    // Load logo image
    final imageData = await rootBundle.load('assets/icon.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    final pdf = pw.Document()
      ..addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header: Logo + BELOTABLE title
                pw.Center(
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Transform.rotate(
                        angle: _iconRotationDegrees * pi / 180,
                        child: pw.Image(
                          image,
                          width: 40,
                          height: 40,
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Text(
                        'Concours de belote',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 8),

                // Metadata section
                pw.Text(
                  'Date: ${formatDateFrLettres(model.date)}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Lieu: ${model.lieu}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Organisateur: ${model.organisateur}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 16),

                // Manual input section
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Table n°',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Container(
                          width: 60,
                          height: 20,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Manche n°',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Container(
                          width: 60,
                          height: 20,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Doublette A',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Container(
                          width: 150,
                          height: 20,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Doublette B',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 2),
                        pw.Container(
                          width: 150,
                          height: 20,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),

                // Rules section
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Règles de jeu',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      model.reglesJeu,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ],
                ),
                pw.SizedBox(height: 16),

                // Score table
                _buildScoreTable(model.nombreDonnesParManche),
              ],
            );
          },
        ),
      );

    return Uint8List.fromList(await pdf.save());
  }

  pw.Widget _buildScoreTable(int nombreDonnes) {
    final headerRow = pw.TableRow(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Donne n°',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Score Doublette A',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Score Doublette B',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
      ],
    );

    final dataRows = <pw.TableRow>[];
    for (var i = 1; i <= nombreDonnes; i++) {
      dataRows.add(
        pw.TableRow(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(),
          ),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                '$i',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                '',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                '',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      );
    }

    final totalRow = pw.TableRow(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Score Total',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            '',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            '',
            style: const pw.TextStyle(fontSize: 12),
          ),
        ),
      ],
    );

    return pw.Table(
      border: pw.TableBorder.all(),
      children: [headerRow, ...dataRows, totalRow],
    );
  }
}
