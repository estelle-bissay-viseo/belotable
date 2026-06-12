import 'package:belotable/domain/doublettes/doublette.dart';

/// Repository contract for contest doublettes.
abstract interface class DoubletteRepository {
  /// Creates a doublette with next registration id in contest.
  Future<Doublette> create({
    required String concoursId,
    required String joueurA,
    required String joueurB,
    required String nomEquipe,
  });

  /// Updates an existing doublette.
  Future<Doublette> update(Doublette doublette);

  /// Finds one doublette by composite key.
  Future<Doublette?> findById({
    required String concoursId,
    required int doubletteId,
  });

  /// Lists doublettes by ascending registration id.
  Future<List<Doublette>> findByConcoursId(String concoursId);

  /// Deletes one doublette by composite key.
  Future<bool> delete({
    required String concoursId,
    required int doubletteId,
  });

  /// Checks whether team name already exists in contest.
  Future<bool> teamNameExists({
    required String concoursId,
    required String nomEquipe,
    int? excludingDoubletteId,
  });
}
