import 'package:belotable/data/repositories/drift_concours_repository.dart';
import 'package:belotable/data/repositories/drift_doublette_repository.dart';
import 'package:belotable/data/repositories/drift_manche_repository.dart';
import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/manches/table_doublette.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_utils.dart';

typedef _Repos = ({
  DriftConcoursRepository concoursRepository,
  DriftDoubletteRepository doubletteRepository,
  DriftMancheRepository mancheRepository,
});

void main() {
  repositoryDbTest<_Repos>(
    'createPremiereManche creates tables and supports status propagation',
    factory: (db) => (
      concoursRepository: DriftConcoursRepository(db),
      doubletteRepository: DriftDoubletteRepository(db),
      mancheRepository: DriftMancheRepository(db),
    ),
    body: (_, repos) async {
      await repos.concoursRepository.save(
        Concours(
          id: 'c-1',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle A',
          organisateur: 'Club A',
        ),
      );

      await repos.doubletteRepository.create(
        concoursId: 'c-1',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'E1',
      );
      await repos.doubletteRepository.create(
        concoursId: 'c-1',
        joueurA: 'A2',
        joueurB: 'B2',
        nomEquipe: 'E2',
      );

      final doublettes = await repos.doubletteRepository.findByConcoursId(
        'c-1',
      );
      final manche = await repos.mancheRepository.createPremiereManche(
        concoursId: 'c-1',
        doublettes: doublettes,
      );

      var tables = await repos.mancheRepository.findTablesDeJeuByMancheId(
        manche.id,
      );
      expect(tables, hasLength(1));
      expect(tables.first.statut.label, 'En attente');

      final updated = await repos.mancheRepository.updateStatut(
        tableId: tables.first.id,
        concoursId: 'c-1',
        doubletteId: 2,
        statut: TableDoubletteStatut.perdu,
      );

      expect(updated.statut.label, 'Terminé');
      expect(
        updated.doublettes.firstWhere((d) => d.doubletteId == 1).statut,
        TableDoubletteStatut.gagne,
      );
      expect(
        updated.doublettes.firstWhere((d) => d.doubletteId == 2).statut,
        TableDoubletteStatut.perdu,
      );

      tables = await repos.mancheRepository.findTablesDeJeuByMancheId(
        manche.id,
      );
      expect(tables.first.statut.label, 'Terminé');
    },
  );

  repositoryDbTest<_Repos>(
    'manche status persists and updates when doublette status changes',
    factory: (db) => (
      concoursRepository: DriftConcoursRepository(db),
      doubletteRepository: DriftDoubletteRepository(db),
      mancheRepository: DriftMancheRepository(db),
    ),
    body: (_, repos) async {
      await repos.concoursRepository.save(
        Concours(
          id: 'c-manche-status',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle Test',
          organisateur: 'Club Test',
        ),
      );

      await repos.doubletteRepository.create(
        concoursId: 'c-manche-status',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'E1',
      );
      await repos.doubletteRepository.create(
        concoursId: 'c-manche-status',
        joueurA: 'A2',
        joueurB: 'B2',
        nomEquipe: 'E2',
      );

      final doublettes = await repos.doubletteRepository.findByConcoursId(
        'c-manche-status',
      );
      final manche = await repos.mancheRepository.createPremiereManche(
        concoursId: 'c-manche-status',
        doublettes: doublettes,
      );

      // Verify manche status is initially "En cours"
      expect(manche.statut.label, 'En cours');

      // Retrieve manche again to verify status persists in DB
      final manches = await repos.mancheRepository.findManchesByConcoursId(
        'c-manche-status',
      );
      expect(manches.first.statut.label, 'En cours');

      // Update doublette status to terminate all doublettes
      final tables = await repos.mancheRepository.findTablesDeJeuByMancheId(
        manche.id,
      );
      await repos.mancheRepository.updateStatut(
        tableId: tables.first.id,
        concoursId: 'c-manche-status',
        doubletteId: 2,
        statut: TableDoubletteStatut.perdu,
      );

      // Verify manche status changed to "Terminé"
      final updatedManches = await repos.mancheRepository
          .findManchesByConcoursId('c-manche-status');
      expect(updatedManches.first.statut.label, 'Terminé');
    },
  );

  repositoryDbTest<_Repos>(
    'addDoubletteToTable enforces one table per manche and max two per table',
    factory: (db) => (
      concoursRepository: DriftConcoursRepository(db),
      doubletteRepository: DriftDoubletteRepository(db),
      mancheRepository: DriftMancheRepository(db),
    ),
    body: (_, repos) async {
      await repos.concoursRepository.save(
        Concours(
          id: 'c-2',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle B',
          organisateur: 'Club B',
        ),
      );

      await repos.doubletteRepository.create(
        concoursId: 'c-2',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'E1',
      );
      await repos.doubletteRepository.create(
        concoursId: 'c-2',
        joueurA: 'A2',
        joueurB: 'B2',
        nomEquipe: 'E2',
      );
      await repos.doubletteRepository.create(
        concoursId: 'c-2',
        joueurA: 'A3',
        joueurB: 'B3',
        nomEquipe: 'E3',
      );

      final doublettes = await repos.doubletteRepository.findByConcoursId(
        'c-2',
      );
      final manche = await repos.mancheRepository.createPremiereManche(
        concoursId: 'c-2',
        doublettes: doublettes,
      );

      final initialTables = await repos.mancheRepository
          .findTablesDeJeuByMancheId(
            manche.id,
          );
      expect(initialTables, hasLength(2));

      final tableOne = initialTables.firstWhere((t) => t.numero == 1);
      final tableTwo = initialTables.firstWhere((t) => t.numero == 2);

      await repos.mancheRepository.addDoubletteToTable(
        tableId: tableOne.id,
        concoursId: 'c-2',
        doubletteId: 3,
      );

      await repos.mancheRepository.addDoubletteToTable(
        tableId: tableTwo.id,
        concoursId: 'c-2',
        doubletteId: 1,
      );

      final updatedTables = await repos.mancheRepository
          .findTablesDeJeuByMancheId(
            manche.id,
          );

      final d1Appearances = updatedTables
          .expand((t) => t.doublettes)
          .where((d) => d.doubletteId == 1)
          .length;
      expect(d1Appearances, 1);

      expect(
        updatedTables.firstWhere((t) => t.id == tableOne.id).doublettes,
        hasLength(2),
      );
      expect(
        updatedTables.firstWhere((t) => t.id == tableTwo.id).doublettes,
        hasLength(1),
      );
    },
  );

  repositoryDbTest<_Repos>(
    'assignDoubletteToLatestManche creates table when latest manche full',
    factory: (db) => (
      concoursRepository: DriftConcoursRepository(db),
      doubletteRepository: DriftDoubletteRepository(db),
      mancheRepository: DriftMancheRepository(db),
    ),
    body: (_, repos) async {
      await repos.concoursRepository.save(
        Concours(
          id: 'c-3',
          date: DateTime(2026, 6, 8),
          lieu: 'Salle C',
          organisateur: 'Club C',
        ),
      );

      await repos.doubletteRepository.create(
        concoursId: 'c-3',
        joueurA: 'A1',
        joueurB: 'B1',
        nomEquipe: 'E1',
      );
      await repos.doubletteRepository.create(
        concoursId: 'c-3',
        joueurA: 'A2',
        joueurB: 'B2',
        nomEquipe: 'E2',
      );
      await repos.doubletteRepository.create(
        concoursId: 'c-3',
        joueurA: 'A3',
        joueurB: 'B3',
        nomEquipe: 'E3',
      );

      final seeded = await repos.doubletteRepository.findByConcoursId('c-3');
      final manche = await repos.mancheRepository.createPremiereManche(
        concoursId: 'c-3',
        doublettes: seeded.take(2).toList(growable: false),
      );

      await repos.mancheRepository.assignDoubletteToLatestManche(
        concoursId: 'c-3',
        doubletteId: 3,
      );

      final tables = await repos.mancheRepository.findTablesDeJeuByMancheId(
        manche.id,
      );
      expect(tables, hasLength(2));
      expect(tables.first.doublettes, hasLength(2));
      expect(tables.last.doublettes, hasLength(1));
      expect(tables.last.doublettes.single.doubletteId, 3);
    },
  );
}
