import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/table_de_jeu.dart';
import 'package:belotable/domain/manches/table_doublette.dart';

/// Repository contract for manches and their tables.
abstract interface class MancheRepository {
  /// Creates the first manche for a concours distributing doublettes into
  /// tables of 2 (last table may have 3 if count is odd).
  Future<Manche> createPremiereManche({
    required String concoursId,
    required List<Doublette> doublettes,
  });

  /// Returns all manches for a concours ordered by numero.
  Future<List<Manche>> findManchesByConcoursId(String concoursId);

  /// Returns the latest manche (highest numero) for a concours,
  /// or null if none exists.
  Future<Manche?> findLatestManche(String concoursId);

  /// Returns surrogate row ids (Doublette.id) of doublettes that have at
  /// least one "Abandon" status across any manche in the concours.
  Future<List<int>> findDoublettesWithAbandonHistory(String concoursId);

  /// Returns tables with doublettes for a given manche id.
  Future<List<TableDeJeu>> findTablesDeJeuByMancheId(int mancheId);

  /// Returns all tables for a concours across all manches.
  Future<List<TableDeJeu>> findTablesDeJeuByConcoursId(String concoursId);

  /// Returns true if at least one manche exists for the concours.
  Future<bool> mancheExistsPourConcours(String concoursId);

  /// Returns id of the first table with fewer than 2 doublettes in the
  /// latest manche, or null if none available.
  Future<int?> findFirstAvailableTableId(String concoursId);

  /// Adds a doublette to a specific table.
  Future<void> addDoubletteToTable({
    required int tableId,
    required int doubletteRowId,
  });

  /// Assigns a doublette to latest manche table, creating new table when all
  /// existing tables are full. No-op if no manche exists.
  Future<void> assignDoubletteToLatestManche({
    required String concoursId,
    required int doubletteRowId,
  });

  /// Removes a doublette from its table. Deletes the table if it becomes empty.
  Future<void> removeDoubletteFromTable({
    required int doubletteRowId,
  });

  /// Returns active table-doublette record for a doublette, or null.
  Future<TableDoublette?> findTableDoublette({
    required int doubletteRowId,
  });

  /// Returns all table-doublette records for a doublette across all manches,
  /// ordered by manche numero ascending.
  Future<List<TableDoublette>> findTableDoublettesByDoubletteRowId({
    required int doubletteRowId,
  });

  /// Updates points for a table-doublette row.
  Future<void> updatePoints({
    required int tableDoubletteId,
    required int points,
  });

  /// Updates score entry mode for a table-doublette row.
  Future<void> updateEntryMode({
    required int tableDoubletteId,
    required bool pointsParDonnes,
  });

  /// Updates statut of a doublette in a table and its opponent if applicable.
  /// Returns the updated table with recomputed status.
  Future<TableDeJeu> updateStatut({
    required int tableDoubletteId,
    required TableDoubletteStatut statut,
  });

  /// Merges two tables: moves all doublettes from source table to target table,
  /// then deletes the source table. Target table keeps its id.
  /// Requires: both tables must have matching mancheId.
  Future<void> mergeTableDoublettes({
    required int targetTableId,
    required int sourceTableId,
  });

  /// Initializes donnes doublettes for all doublettes in all tables
  /// of a manche.
  Future<void> initializeDonneDoublettesForManche({
    required int mancheId,
    required int numberOfDeals,
  });

  /// Recomputes and persists a doublette's total points across all manches,
  /// given any of its table-doublette row ids.
  Future<int> recalculateDoubletteTotalPoints(int tableDoubletteId);
}
