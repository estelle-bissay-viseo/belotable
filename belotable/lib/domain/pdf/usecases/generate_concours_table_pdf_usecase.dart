import 'dart:typed_data';

import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/pdf/models/concours_table_pdf_model.dart';
import 'package:belotable/domain/pdf/repositories/pdf_repository.dart';

/// Use case for generating PDF export of concours table layout.
///
/// Responsibilities:
/// - Fetch concours data via repository
/// - Map domain entities to PDF model
/// - Call PDF repository for rendering
class GenerateConcoursTablePdfUseCase {
  /// Creates use case with repository dependencies.
  GenerateConcoursTablePdfUseCase({
    required this.concoursRepository,
    required this.pdfRepository,
  });

  /// Repository for fetching concours entities.
  final ConcoursRepository concoursRepository;

  /// Repository for rendering PDF documents.
  final PdfRepository pdfRepository;

  /// Generates PDF for concours with given id.
  ///
  /// Fetches concours, maps to PDF model, returns rendered bytes.
  /// Throws if concours not found.
  Future<Uint8List> call(String concoursId) async {
    final concours = await concoursRepository.findById(concoursId);

    if (concours == null) {
      throw ArgumentError.value(
        concoursId,
        'concoursId',
        'Concours not found',
      );
    }

    final pdfModel = ConcoursTablePdfModel(
      date: concours.date,
      lieu: concours.lieu,
      organisateur: concours.organisateur,
      reglesJeu: concours.reglesJeu,
      nombreDonnesParManche: concours.nombreDonnesParManche,
    );

    return pdfRepository.generateConcoursTablePdf(pdfModel);
  }
}
