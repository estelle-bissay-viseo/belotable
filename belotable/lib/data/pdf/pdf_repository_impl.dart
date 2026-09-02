import 'dart:math';

import 'package:belotable/domain/pdf/models/concours_table_pdf_model.dart';
import 'package:belotable/domain/pdf/repositories/pdf_repository.dart';
import 'package:belotable/utils/date_format.dart';
import 'package:belotable/utils/points_manage.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
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
          pageFormat: const PdfPageFormat(
            21.0 * PdfPageFormat.cm,
            29.7 * PdfPageFormat.cm,
            marginAll: 0.5 * PdfPageFormat.cm,
          ),
          orientation: pw.PageOrientation.landscape,
          build: (context) {
            return pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(right: 4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
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
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  formatDateFrLettres(model.date),
                                  style: const pw.TextStyle(fontSize: 10),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Text(
                                  model.organisateur,
                                  style: const pw.TextStyle(
                                    fontSize: 10,
                                    fontStyle: pw.FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(width: 4),
                            pw.Row(
                              children: [
                                pw.Text(
                                  'Table n° :',
                                  style: const pw.TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                pw.SizedBox(width: 4),
                                pw.Container(
                                  width: 40,
                                  height: 20,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 0.5),
                                  ),
                                ),
                                pw.SizedBox(width: 4),
                                pw.Text(
                                  'Manche n° :',
                                  style: const pw.TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                pw.SizedBox(width: 4),
                                pw.Container(
                                  width: 40,
                                  height: 20,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Doublette A (nom et n°) :',
                                  style: const pw.TextStyle(fontSize: 10),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Container(
                                  width: 185,
                                  height: 20,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 0.5),
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'Doublette B (nom et n°) :',
                                  style: const pw.TextStyle(fontSize: 10),
                                ),
                                pw.SizedBox(height: 2),
                                pw.Container(
                                  width: 185,
                                  height: 20,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(width: 0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        // Score doublette
                        _buildScoreTable(model.nombreDonnesParManche),
                      ],
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: model.maxPointsParDonne == 0 ? 0 : 1,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10, right: 4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Points section
                        ..._buildScoreHelp(model.maxPointsParDonne),
                      ],
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: model.maxPointsParDonne == 0 ? 2 : 1,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Rules section
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Règles de jeu :',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              model.reglesJeu,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Score Doublette A',
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Score Doublette B',
            style: const pw.TextStyle(
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
            _emptyCell(),
            _emptyCell(),
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
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        _emptyCell(),
        _emptyCell(),
      ],
    );

    return pw.Table(
      border: pw.TableBorder.all(),
      children: [headerRow, ...dataRows, totalRow],
    );
  }

  @override
  Future<Uint8List> generateConcoursDoublettePdf(
    ConcoursTablePdfModel model,
  ) async {
    // Load logo image
    final imageData = await rootBundle.load('assets/icon.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    final pdf = pw.Document()
      ..addPage(
        pw.Page(
          pageFormat: const PdfPageFormat(
            21.0 * PdfPageFormat.cm,
            29.7 * PdfPageFormat.cm,
            marginAll: 0.5 * PdfPageFormat.cm,
          ),
          orientation: pw.PageOrientation.landscape,
          build: (context) {
            return pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(right: 4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
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
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  formatDateFrLettres(model.date),
                                  style: const pw.TextStyle(fontSize: 10),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Text(
                                  model.organisateur,
                                  style: const pw.TextStyle(
                                    fontSize: 10,
                                    fontStyle: pw.FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(width: 12),
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    'Doublette (nom et n°) :',
                                    style: const pw.TextStyle(fontSize: 10),
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Container(
                                    height: 20,
                                    decoration: pw.BoxDecoration(
                                      border: pw.Border.all(width: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        // Score doublette
                        _buildScoreDoublette(model.nombreDonnesParManche),
                      ],
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: model.maxPointsParDonne == 0 ? 0 : 1,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 10, right: 4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Points section
                        ..._buildScoreHelp(model.maxPointsParDonne),
                      ],
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: model.maxPointsParDonne == 0 ? 2 : 1,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.only(left: 4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Rules section
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Règles de jeu :',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                            pw.SizedBox(height: 5),
                            pw.Text(
                              model.reglesJeu,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

    return Uint8List.fromList(await pdf.save());
  }

  pw.Widget _buildScoreDoublette(int nombreDonnes) {
    final headerRow = pw.TableRow(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      children: [
        _emptyCell(),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Manche  ',
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Manche  ',
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Manche  ',
            style: const pw.TextStyle(
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
                'Donne $i',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            _emptyCell(),
            _emptyCell(),
            _emptyCell(),
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
            'Score de la manche',
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        _emptyCell(),
        _emptyCell(),
        _emptyCell(),
      ],
    );

    final cumulRow = pw.TableRow(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Score cumulé',
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        _emptyCell(),
        _emptyCell(),
        _emptyCell(),
      ],
    );

    final rank = pw.TableRow(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Classement',
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        _emptyCell(),
        _emptyCell(),
        _emptyCell(),
      ],
    );

    final opponent = pw.TableRow(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'Adversaires',
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        _emptyCell(),
        _emptyCell(),
        _emptyCell(),
      ],
    );

    final tableNumber = pw.TableRow(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(4),
          child: pw.Text(
            'N° de table',
            style: const pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        _emptyCell(),
        _emptyCell(),
        _emptyCell(),
      ],
    );

    return pw.Table(
      border: pw.TableBorder.all(),
      children: [
        headerRow,
        tableNumber,
        opponent,
        ...dataRows,
        totalRow,
        cumulRow,
        rank,
      ],
    );
  }

  List<pw.Widget> _buildScoreHelp(int maxPointsParDonne) {
    if (maxPointsParDonne <= 0) {
      return [];
    }
    final pairs = generatePairs(0, maxPointsParDonne);
    final pairsAsPaddings = pairs.map((pair) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(4),
        alignment: pw.Alignment.center,
        child: pw.Text(
          '${pair.$1} - ${pair.$2}',
          style: const pw.TextStyle(fontSize: 8),
        ),
      );
    }).toList();

    final rows = <pw.TableRow>[];
    const maxColumns = 3;
    final rowCount = (pairsAsPaddings.length / maxColumns).ceil();

    for (var rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      final rowChildren = List<pw.Widget>.generate(
        maxColumns,
        (columnIndex) {
          final itemIndex = columnIndex * rowCount + rowIndex;

          return itemIndex < pairsAsPaddings.length
              ? pairsAsPaddings[itemIndex]
              : _emptyCell(8);
        },
      );
      rows.add(pw.TableRow(children: rowChildren));
    }

    return <pw.Widget>[
      pw.Text(
        'Aide pour les points :',
        style: const pw.TextStyle(
          fontSize: 10,
          decoration: pw.TextDecoration.underline,
        ),
      ),
      pw.SizedBox(height: 5),
      pw.Table(
        border: pw.TableBorder.all(width: 0.5),
        children: rows,
      ),
      pw.SizedBox(height: 10),
    ];
  }

  /// Returns an empty table cell with optional custom font size.
  pw.Padding _emptyCell([double customFontSize = 12]) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        '',
        style: pw.TextStyle(fontSize: customFontSize),
      ),
    );
  }
}
