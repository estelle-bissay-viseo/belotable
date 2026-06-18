import 'dart:typed_data';

import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/pdf/models/concours_table_pdf_model.dart';
import 'package:belotable/domain/pdf/repositories/pdf_repository.dart';
import 'package:belotable/domain/pdf/usecases/generate_concours_table_pdf_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockConcoursRepository extends Mock implements ConcoursRepository {}

class MockPdfRepository extends Mock implements PdfRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      ConcoursTablePdfModel(
        title: 'Test',
        date: DateTime.now(),
        lieu: 'Test',
        organisateur: 'Test',
        nombreDoublettes: 0,
      ),
    );
  });

  group('GenerateConcoursTablePdfUseCase', () {
    late MockConcoursRepository mockConcoursRepository;
    late MockPdfRepository mockPdfRepository;
    late GenerateConcoursTablePdfUseCase useCase;

    final testConcours = Concours(
      id: 'c1',
      date: DateTime(2025, 6, 15),
      lieu: 'Paris',
      organisateur: 'Club de Belote',
      nombreDoublettes: 5,
    );

    setUp(() {
      mockConcoursRepository = MockConcoursRepository();
      mockPdfRepository = MockPdfRepository();
      useCase = GenerateConcoursTablePdfUseCase(
        concoursRepository: mockConcoursRepository,
        pdfRepository: mockPdfRepository,
      );
    });

    test('generates PDF when concours exists', () async {
      final testBytes = Uint8List.fromList([0, 1, 2, 3]);

      when(
        () => mockConcoursRepository.findById('c1'),
      ).thenAnswer((_) async => testConcours);
      when(
        () => mockPdfRepository.generateConcoursTablePdf(any()),
      ).thenAnswer((_) async => testBytes);

      final result = await useCase('c1');

      expect(result, equals(testBytes));

      verify(() => mockConcoursRepository.findById('c1')).called(1);
      verify(() => mockPdfRepository.generateConcoursTablePdf(any())).called(1);
    });

    test('maps concours to PDF model correctly', () async {
      final testBytes = Uint8List.fromList([0, 1, 2, 3]);

      when(
        () => mockConcoursRepository.findById('c1'),
      ).thenAnswer((_) async => testConcours);
      when(
        () => mockPdfRepository.generateConcoursTablePdf(any()),
      ).thenAnswer((_) async => testBytes);

      await useCase('c1');

      final captured =
          verify(
                () => mockPdfRepository.generateConcoursTablePdf(
                  captureAny(),
                ),
              ).captured.single
              as ConcoursTablePdfModel;

      expect(captured.lieu, equals('Paris'));
      expect(captured.organisateur, equals('Club de Belote'));
      expect(captured.date, equals(DateTime(2025, 6, 15)));
      expect(captured.nombreDoublettes, equals(5));
    });

    test('throws when concours not found', () async {
      when(
        () => mockConcoursRepository.findById('unknown'),
      ).thenAnswer((_) async => null);

      expect(
        () => useCase('unknown'),
        throwsA(isA<ArgumentError>()),
      );

      verifyNever(
        () => mockPdfRepository.generateConcoursTablePdf(any()),
      );
    });
  });
}
