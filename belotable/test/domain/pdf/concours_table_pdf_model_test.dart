import 'package:belotable/domain/pdf/models/concours_table_pdf_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConcoursTablePdfModel', () {
    test('creates instance with required fields', () {
      final date = DateTime(2025, 6, 15);
      final model = ConcoursTablePdfModel(
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        reglesJeu: '8 donnes par manche',
        nombreDonnesParManche: 8,
      );

      expect(model.date, equals(date));
      expect(model.lieu, equals('Paris'));
      expect(model.organisateur, equals('Club de Belote'));
      expect(model.reglesJeu, equals('8 donnes par manche'));
      expect(model.nombreDonnesParManche, equals(8));
    });

    test('supports equality comparison', () {
      final date = DateTime(2025, 6, 15);
      final model1 = ConcoursTablePdfModel(
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        reglesJeu: '8 donnes par manche',
        nombreDonnesParManche: 8,
      );
      final model2 = ConcoursTablePdfModel(
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        reglesJeu: '8 donnes par manche',
        nombreDonnesParManche: 8,
      );

      expect(model1, equals(model2));
    });

    test('supports inequality comparison when fields differ', () {
      final date = DateTime(2025, 6, 15);
      final model1 = ConcoursTablePdfModel(
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        reglesJeu: '8 donnes par manche',
        nombreDonnesParManche: 8,
      );
      final model2 = ConcoursTablePdfModel(
        date: date,
        lieu: 'Lyon',
        organisateur: 'Club de Belote',
        reglesJeu: '8 donnes par manche',
        nombreDonnesParManche: 8,
      );

      expect(model1, isNot(equals(model2)));
    });

    test(
      'supports inequality comparison when nombreDonnesParManche differs',
      () {
        final date = DateTime(2025, 6, 15);
        final model1 = ConcoursTablePdfModel(
          date: date,
          lieu: 'Paris',
          organisateur: 'Club de Belote',
          reglesJeu: '8 donnes par manche',
          nombreDonnesParManche: 8,
        );
        final model2 = ConcoursTablePdfModel(
          date: date,
          lieu: 'Paris',
          organisateur: 'Club de Belote',
          reglesJeu: '8 donnes par manche',
          nombreDonnesParManche: 10,
        );

        expect(model1, isNot(equals(model2)));
      },
    );

    test('generates consistent hashCode for equal instances', () {
      final date = DateTime(2025, 6, 15);
      final model1 = ConcoursTablePdfModel(
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        reglesJeu: '8 donnes par manche',
        nombreDonnesParManche: 8,
      );
      final model2 = ConcoursTablePdfModel(
        date: date,
        lieu: 'Paris',
        organisateur: 'Club de Belote',
        reglesJeu: '8 donnes par manche',
        nombreDonnesParManche: 8,
      );

      expect(model1.hashCode, equals(model2.hashCode));
    });
  });
}
