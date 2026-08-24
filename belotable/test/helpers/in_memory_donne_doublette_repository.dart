import 'package:belotable/domain/manches/donne_doublette.dart';
import 'package:belotable/domain/manches/donne_doublette_repository.dart';

/// In-memory implementation of DonneDoubletteRepository for testing.
class InMemoryDonneDoubletteRepository implements DonneDoubletteRepository {
  final _donneDoublettes = <({int tableDoubletteId, int donneNumero}), int>{};

  @override
  Future<void> initializeDonneDoublettes({
    required int tableDoubletteId,
    required int numberOfDeals,
  }) async {
    for (var donneNumero = 1; donneNumero <= numberOfDeals; donneNumero++) {
      _donneDoublettes[(
            tableDoubletteId: tableDoubletteId,
            donneNumero: donneNumero,
          )] =
          0;
    }
  }

  @override
  Future<List<DonneDoublette>> findDonneDoublettesForTableDoublette({
    required int tableDoubletteId,
  }) async {
    final result = <DonneDoublette>[];
    for (final entry in _donneDoublettes.entries) {
      if (entry.key.tableDoubletteId == tableDoubletteId) {
        result.add(
          DonneDoublette(
            tableDoubletteId: entry.key.tableDoubletteId,
            donneNumero: entry.key.donneNumero,
            points: entry.value,
          ),
        );
      }
    }
    result.sort((a, b) => a.donneNumero.compareTo(b.donneNumero));
    return result;
  }

  @override
  Future<void> updateDonneDoublette({
    required int tableDoubletteId,
    required int donneNumero,
    required int points,
  }) async {
    _donneDoublettes[(
          tableDoubletteId: tableDoubletteId,
          donneNumero: donneNumero,
        )] =
        points;
  }

  @override
  Future<int> calculateTotalPointsFromDeals({
    required int tableDoubletteId,
  }) async {
    var total = 0;
    for (final entry in _donneDoublettes.entries) {
      if (entry.key.tableDoubletteId == tableDoubletteId) {
        total += entry.value;
      }
    }
    return total;
  }
}
