import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../helpers/test_utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  e2eTest(
    'Concours deletion',
    'User can delete concours via delete button and confirmation dialog',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-to-delete',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle des Fêtes',
              organisateur: 'Club Belote',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-to-keep',
              date: DateTime(2025, 3, 15),
              lieu: 'Gymnase Municipal',
              organisateur: 'Association Belote',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );
        },
      );

      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('home_list_concours_button')),
      );
      await tester.pumpAndSettle();

      // Verify both concours are visible
      expect(find.text('Salle des Fêtes'), findsOneWidget);
      expect(find.text('Gymnase Municipal'), findsOneWidget);

      // Click delete button on first concours (2026-06-08)
      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('concours_delete_button_id-to-delete')),
      );
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Confirmer la suppression'), findsOneWidget);
      expect(
        find.textContaining('2026-06-08 - Salle des Fêtes'),
        findsOneWidget,
      );

      // Click confirm button in dialog
      await tester.tap(warnIfMissed: false, find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Dialog should close and deleted concours should be gone
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Salle des Fêtes'), findsNothing);

      // Other concours should remain
      expect(find.text('Gymnase Municipal'), findsOneWidget);
      expect(find.text('Association Belote'), findsOneWidget);

      // Success snackbar should appear
      expect(
        find.text('Concours supprimé avec succès'),
        findsOneWidget,
      );
    },
  );

  e2eTest(
    'Concours deletion',
    'User can cancel deletion via confirmation dialog',
    (tester, db) async {
      await pumpTestApp(
        tester,
        db,
        seed: (database) async {
          await database.concoursDao.insertConcours(
            Concours(
              id: 'id-1',
              date: DateTime(2026, 6, 8),
              lieu: 'Salle A',
              organisateur: 'Club A',
              nombreDonnesParManche: 8,
              reglesJeu: 'Règles originales',
            ),
          );
        },
      );

      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('home_list_concours_button')),
      );
      await tester.pumpAndSettle();

      // Click delete button
      await tester.tap(
        warnIfMissed: false,
        find.byKey(const Key('concours_delete_button_id-1')),
      );
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.byType(AlertDialog), findsOneWidget);

      // Click cancel button
      await tester.tap(warnIfMissed: false, find.text('Annuler'));
      await tester.pumpAndSettle();

      // Dialog should close and concours should still exist
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Salle A'), findsOneWidget);
      expect(find.text('Club A'), findsOneWidget);
    },
  );
}
