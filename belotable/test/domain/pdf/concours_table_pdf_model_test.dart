import 'package:belotable/domain/pdf/models/concours_table_pdf_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConcoursTablePdfModel', () {
    test('creates instance with required fields', () {
      final date = DateTime(2025, 6, 15);
      final model = ConcoursTablePdfModel(
        title: 'Belote 2025',
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        nombreDoublettes: 10,
      );

      expect(model.title, equals('Belote 2025'));
      expect(model.date, equals(date));
      expect(model.lieu, equals('Paris'));
      expect(model.organisateur, equals('Club de Belote'));
      expect(model.nombreDoublettes, equals(10));
    });

    test('supports equality comparison', () {
      final date = DateTime(2025, 6, 15);
      final model1 = ConcoursTablePdfModel(
        title: 'Belote 2025',
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        nombreDoublettes: 10,
      );
      final model2 = ConcoursTablePdfModel(
        title: 'Belote 2025',
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        nombreDoublettes: 10,
      );

      expect(model1, equals(model2));
    });

    test('supports inequality comparison when fields differ', () {
      final date = DateTime(2025, 6, 15);
      final model1 = ConcoursTablePdfModel(
        title: 'Belote 2025',
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        nombreDoublettes: 10,
      );
      final model2 = ConcoursTablePdfModel(
        title: 'Belote 2025',
        date: date,
        lieu: 'Lyon',
        organisateur: 'Club de Belote',
        nombreDoublettes: 10,
      );

      expect(model1, isNot(equals(model2)));
    });

    test('generates consistent hashCode for equal instances', () {
      final date = DateTime(2025, 6, 15);
      final model1 = ConcoursTablePdfModel(
        title: 'Belote 2025',
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        nombreDoublettes: 10,
      );
      final model2 = ConcoursTablePdfModel(
        title: 'Belote 2025',
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        nombreDoublettes: 10,
      );

      expect(model1.hashCode, equals(model2.hashCode));
    });
  });
}
