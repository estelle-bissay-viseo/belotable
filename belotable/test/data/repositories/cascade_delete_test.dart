import 'package:belotable/data/repositories/drift_concours_repository.dart';
import 'package:belotable/data/repositories/drift_deal_points_repository.dart';
import 'package:belotable/data/repositories/drift_doublette_repository.dart';
import 'package:belotable/data/repositories/drift_manche_repository.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_utils.dart';

typedef _Repos = ({
  DriftConcoursRepository concoursRepository,
  DriftDoubletteRepository doubletteRepository,
  DriftMancheRepository mancheRepository,
  DriftDealPointsRepository dealPointsRepository,
});

// Répartition avec 5 doublettes :
//   table 1 → doublettes 1 & 2
//   table 2 → doublettes 3 & 4
//   table 3 → doublette  5  (table avec 1 seul participant)

void main() {
  // ---------------------------------------------------------------------------
  // Test 1 : suppression de la 5ème doublette
  // ---------------------------------------------------------------------------

  repositoryDbTest<_Repos>(
    'supprimer la 5ème doublette supprime en cascade sa TableDoublette '
    'et ses DealPoints',
    factory: (db) => (
      concoursRepository: DriftConcoursRepository(db),
      doubletteRepository: DriftDoubletteRepository(db),
      mancheRepository: DriftMancheRepository(db),
      dealPointsRepository: DriftDealPointsRepository(db),
    ),
    body: (db, repos) async {
      const concoursId = 'c-cascade-doublette';

      await repos.concoursRepository.save(
        Concours(
          id: concoursId,
          date: DateTime(2026, 6, 8),
          lieu: 'Salle Cascade',
          organisateur: 'Club Test',
          nombreDonnesParManche: 5,
        ),
      );

      for (var i = 1; i <= 5; i++) {
        await repos.doubletteRepository.create(
          concoursId: concoursId,
          joueurA: 'Joueur A$i',
          joueurB: 'Joueur B$i',
          nomEquipe: 'Equipe $i',
        );
      }

      final doublettes =
          await repos.doubletteRepository.findByConcoursId(concoursId);

      await repos.mancheRepository.createPremiereManche(
        concoursId: concoursId,
        doublettes: doublettes,
      );

      // Préconditions — la 5ème doublette a bien une TableDoublette et des
      // DealPoints avant la suppression.
      final tdAvant = await repos.mancheRepository.findTableDoublette(
        concoursId: concoursId,
        doubletteId: 5,
      );
      expect(tdAvant, isNotNull, reason: 'La doublette 5 doit être dans une table');

      final dealPointsAvant = await repos.dealPointsRepository
          .findDealPointsForTableDoublette(
            tableDoubletteId: tdAvant!.id,
          );
      expect(dealPointsAvant, hasLength(5));

      // Action : supprimer la 5ème doublette.
      final deleted = await repos.doubletteRepository.delete(
        concoursId: concoursId,
        doubletteId: 5,
      );
      expect(deleted, isTrue);

      // Vérification 1 : la doublette n'existe plus.
      final doubletteApres = await repos.doubletteRepository.findById(
        concoursId: concoursId,
        doubletteId: 5,
      );
      expect(doubletteApres, isNull);

      final doublettesRestantes =
          await repos.doubletteRepository.findByConcoursId(concoursId);
      expect(doublettesRestantes, hasLength(4));

      // Vérification 2 : la TableDoublette est supprimée en cascade.
      final tdApres = await repos.mancheRepository.findTableDoublette(
        concoursId: concoursId,
        doubletteId: 5,
      );
      expect(
        tdApres,
        isNull,
        reason:
            'La TableDoublette doit être supprimée par cascade '
            '(customConstraints FOREIGN KEY ON DELETE CASCADE)',
      );

      // Vérification 3 : les DealPoints sont supprimés en cascade.
      final dealPointsApres = await repos.dealPointsRepository
          .findDealPointsForTableDoublette(
            tableDoubletteId: tdAvant.id,
          );
      expect(
        dealPointsApres,
        isEmpty,
        reason:
            'Les DealPoints doivent être supprimés par cascade '
            '(DealPointsTable → TableDoublettesTable ON DELETE CASCADE)',
      );

      // Vérification 4 : les autres doublettes et leurs données sont intactes.
      for (var i = 1; i <= 4; i++) {
        final autreDoublette = await repos.doubletteRepository.findById(
          concoursId: concoursId,
          doubletteId: i,
        );
        expect(
          autreDoublette,
          isNotNull,
          reason: 'La doublette $i ne doit pas être supprimée',
        );

        final autreTd = await repos.mancheRepository.findTableDoublette(
          concoursId: concoursId,
          doubletteId: i,
        );
        expect(
          autreTd,
          isNotNull,
          reason: 'La TableDoublette de la doublette $i doit rester intacte',
        );

        final autresDealPoints = await repos.dealPointsRepository
            .findDealPointsForTableDoublette(
              tableDoubletteId: autreTd!.id,
            );
        expect(
          autresDealPoints,
          hasLength(5),
          reason: 'Les DealPoints de la doublette $i doivent rester intacts',
        );
      }
    },
  );

  // ---------------------------------------------------------------------------
  // Test 2 : suppression du concours
  // ---------------------------------------------------------------------------

  repositoryDbTest<_Repos>(
    'supprimer le concours supprime en cascade toutes les entités liées',
    factory: (db) => (
      concoursRepository: DriftConcoursRepository(db),
      doubletteRepository: DriftDoubletteRepository(db),
      mancheRepository: DriftMancheRepository(db),
      dealPointsRepository: DriftDealPointsRepository(db),
    ),
    body: (db, repos) async {
      const concoursId = 'c-cascade-concours';

      await repos.concoursRepository.save(
        Concours(
          id: concoursId,
          date: DateTime(2026, 6, 8),
          lieu: 'Salle Cascade',
          organisateur: 'Club Test',
          nombreDonnesParManche: 5,
        ),
      );

      for (var i = 1; i <= 5; i++) {
        await repos.doubletteRepository.create(
          concoursId: concoursId,
          joueurA: 'Joueur A$i',
          joueurB: 'Joueur B$i',
          nomEquipe: 'Equipe $i',
        );
      }

      final doublettes =
          await repos.doubletteRepository.findByConcoursId(concoursId);

      await repos.mancheRepository.createPremiereManche(
        concoursId: concoursId,
        doublettes: doublettes,
      );

      // Snapshot des ids de TableDoublettes avant suppression.
      final tablesAvant =
          await repos.mancheRepository.findTablesDeJeuByConcoursId(concoursId);
      final allTableDoubletteIds = tablesAvant
          .expand((t) => t.doublettes)
          .map((td) => td.id)
          .toList(growable: false);
      expect(allTableDoubletteIds, hasLength(5));

      // Action : supprimer le concours.
      final deleted = await repos.concoursRepository.delete(concoursId);
      expect(deleted, isTrue);

      // Vérification 1 : le concours n'existe plus.
      final concoursApres =
          await repos.concoursRepository.findById(concoursId);
      expect(concoursApres, isNull);

      // Vérification 2 : toutes les Doublettes sont supprimées.
      final doublettesApres =
          await repos.doubletteRepository.findByConcoursId(concoursId);
      expect(
        doublettesApres,
        isEmpty,
        reason: 'Toutes les Doublettes doivent être supprimées en cascade',
      );

      // Vérification 3 : toutes les Manches sont supprimées.
      final manchesApres =
          await repos.mancheRepository.findManchesByConcoursId(concoursId);
      expect(
        manchesApres,
        isEmpty,
        reason: 'Toutes les Manches doivent être supprimées en cascade',
      );

      // Vérification 4 : toutes les TablesDeJeu sont supprimées.
      final tablesApres =
          await repos.mancheRepository.findTablesDeJeuByConcoursId(concoursId);
      expect(
        tablesApres,
        isEmpty,
        reason: 'Toutes les TablesDeJeu doivent être supprimées en cascade',
      );

      // Vérification 5 : les DealPoints de chaque TableDoublette sont supprimés.
      // On utilise le DAO directement avec les ids capturés avant suppression.
      for (final tdId in allTableDoubletteIds) {
        final dealPointsApres = await db.manchesDao
            .findDealPointsForTableDoublette(tableDoubletteId: tdId);
        expect(
          dealPointsApres,
          isEmpty,
          reason:
              'Les DealPoints de la TableDoublette $tdId doivent être '
              'supprimés en cascade (DealPointsTable ON DELETE CASCADE)',
        );
      }

      // Vérification 6 : les TableDoublettes de chaque doublette sont supprimées.
      for (var doubletteId = 1; doubletteId <= 5; doubletteId++) {
        final tds = await repos.mancheRepository
            .findTableDoublettesByDoubletteId(
              concoursId: concoursId,
              doubletteId: doubletteId,
            );
        expect(
          tds,
          isEmpty,
          reason:
              'Les TableDoublettes de la doublette $doubletteId doivent '
              'être supprimées en cascade',
        );
      }
    },
  );
}
