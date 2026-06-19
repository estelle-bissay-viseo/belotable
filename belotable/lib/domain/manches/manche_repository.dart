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
    required String concoursId,
    required int doubletteId,
  });

  /// Assigns a doublette to latest manche table, creating new table when all
  /// existing tables are full. No-op if no manche exists.
  Future<void> assignDoubletteToLatestManche({
    required String concoursId,
    required int doubletteId,
  });

  /// Removes a doublette from its table. Deletes the table if it becomes empty.
  Future<void> removeDoubletteFromTable({
    required String concoursId,
    required int doubletteId,
  });

  /// Returns active table-doublette record for a doublette, or null.
  Future<TableDoublette?> findTableDoublette({
    required String concoursId,
    required int doubletteId,
  });

  /// Returns all table-doublette records for a doublette across all manches,
  /// ordered by manche numero ascending.
  Future<List<TableDoublette>> findTableDoublettesByDoubletteId({
    required String concoursId,
    required int doubletteId,
  });

  /// Updates points for a doublette in a table.
  Future<void> updatePoints({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required int points,
  });

  /// Updates statut of a doublette in a table and its opponent if applicable.
  /// Returns the updated table with recomputed status.
  Future<TableDeJeu> updateStatut({
    required int tableId,
    required String concoursId,
    required int doubletteId,
    required TableDoubletteStatut statut,
  });

  /// Merges two tables: moves all doublettes from source table to target table,
  /// then deletes the source table. Target table keeps its id.
  /// Requires: both tables must have matching mancheId.
  Future<void> mergeTableDoublettes({
    required int targetTableId,
    required int sourceTableId,
    required String concoursId,
  });
}
