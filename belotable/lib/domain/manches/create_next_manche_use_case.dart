import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';
import 'package:belotable/domain/concours/concours_statut.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/manches/manche.dart';
import 'package:belotable/domain/manches/manche_repository.dart';
import 'package:belotable/domain/manches/manche_statut.dart';

/// Creates the next manche for a concours, with ranking-based distribution.
/// Filters out doublettes with "Abandon" history, sorts by total points desc
/// then creation date asc, and gates creation on previous manche completion.
class CreateNextMancheUseCase {
  /// Creates use case with required dependencies.
  CreateNextMancheUseCase(
    this._doubletteRepository,
    this._mancheRepository,
    this._concoursRepository,
  );

  final DoubletteRepository _doubletteRepository;
  final MancheRepository _mancheRepository;
  final ConcoursRepository _concoursRepository;

  /// Validates preconditions and creates the next manche.
  /// For manche 1: updates concours status from Initialisation to EnCours.
  /// For manche 2+: checks that previous manche is Terminé.
  /// Initializes deal points for all doublettes.
  Future<Manche> call(String concoursId) async {
    final trimmedId = concoursId.trim();
    if (trimmedId.isEmpty) {
      throw ArgumentError.value(
        concoursId,
        'concoursId',
        'concoursId required',
      );
    }

    final latestManche = await _mancheRepository.findLatestManche(trimmedId);

    // If a manche exists and is not finished, block creation
    if (latestManche != null && latestManche.statut != MancheStatut.termine) {
      throw Exception(
        'Vous ne pouvez pas préparer une nouvelle manche tant que la '
        "manche précédente n'est pas terminée.",
      );
    }

    // Fetch all doublettes
    var doublettes = await _doubletteRepository.findByConcoursId(trimmedId);
    if (doublettes.isEmpty) {
      throw Exception('Aucune doublette enregistrée pour créer une manche.');
    }

    // Get IDs of doublettes with Abandon history to exclude them
    final abandonedIds = await _mancheRepository
        .findDoublettesWithAbandonHistory(trimmedId);

    // Filter out abandoned doublettes
    doublettes = doublettes
        .where((d) => !abandonedIds.contains(d.doubletteId))
        .toList();

    if (doublettes.isEmpty) {
      throw Exception(
        'Aucune doublette eligible pour creer une nouvelle manche '
        '(toutes sont abandonnées).',
      );
    }

    // Sort: totalPoints desc, then by doubletteId asc
    doublettes.sort((a, b) {
      final pointsCmp = b.totalPoints.compareTo(a.totalPoints);
      if (pointsCmp != 0) return pointsCmp;
      return a.doubletteId.compareTo(b.doubletteId);
    });

    // Create manche with sorted doublettes
    final manche = await _mancheRepository.createPremiereManche(
      concoursId: trimmedId,
      doublettes: doublettes,
    );

    // Get concours to retrieve numberOfDeals
    final concours = await _concoursRepository.findById(trimmedId);
    if (concours != null) {
      // Initialize deal points for all doublettes
      await _mancheRepository.initializeDealPointsForManche(
        mancheId: manche.id,
        concoursId: trimmedId,
        numberOfDeals: concours.nombreDonnesParManche,
      );

      // Update concours status
      if (manche.numero == 1 &&
          concours.statutConcours == ConcoursStatut.initialisation) {
        final updatedConcours = Concours(
          id: concours.id,
          date: concours.date,
          lieu: concours.lieu,
          organisateur: concours.organisateur,
          nombreDonnesParManche: concours.nombreDonnesParManche,
          nombreMaxPointsParDonne: concours.nombreMaxPointsParDonne,
          nombreDoublettes: concours.nombreDoublettes,
          reglesJeu: concours.reglesJeu,
          statutConcours: ConcoursStatut.enCours,
        );
        await _concoursRepository.save(updatedConcours);
      }
    }

    return manche;
  }
}
