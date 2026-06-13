import 'package:belotable/domain/doublettes/doublette.dart';
import 'package:belotable/domain/doublettes/doublette_exceptions.dart';
import 'package:belotable/domain/doublettes/doublette_repository.dart';
import 'package:belotable/domain/doublettes/team_name_dictionary.dart';
import 'package:belotable/domain/manches/manche_repository.dart';

/// Creates a new doublette in a contest.
class CreateDoubletteUseCase {
  /// Creates use case with required repository and optional manche repository.
  CreateDoubletteUseCase(
    this._repository, {
    this.mancheRepository,
  });

  final DoubletteRepository _repository;

  /// Optional manche repository for auto-assignment when manche exists.
  final MancheRepository? mancheRepository;

  /// Creates and persists new doublette.
  Future<Doublette> call({
    required String concoursId,
    required String joueurA,
    required String joueurB,
    String? nomEquipe,
  }) async {
    final trimmedConcoursId = concoursId.trim();
    final trimmedJoueurA = joueurA.trim();
    final trimmedJoueurB = joueurB.trim();

    if (trimmedConcoursId.isEmpty) {
      throw ArgumentError.value(
        concoursId,
        'concoursId',
        'concoursId required',
      );
    }
    if (trimmedJoueurA.isEmpty) {
      throw ArgumentError.value(joueurA, 'joueurA', 'joueurA required');
    }
    if (trimmedJoueurB.isEmpty) {
      throw ArgumentError.value(joueurB, 'joueurB', 'joueurB required');
    }

    var teamName = nomEquipe?.trim() ?? '';
    if (teamName.isEmpty) {
      teamName = await suggestTeamName(trimmedConcoursId);
    }

    final exists = await _repository.teamNameExists(
      concoursId: trimmedConcoursId,
      nomEquipe: teamName,
    );
    if (exists) {
      throw DuplicateTeamNameException(teamName);
    }

    return _createAndAssign(
      concoursId: trimmedConcoursId,
      joueurA: trimmedJoueurA,
      joueurB: trimmedJoueurB,
      nomEquipe: teamName,
    );
  }

  Future<Doublette> _createAndAssign({
    required String concoursId,
    required String joueurA,
    required String joueurB,
    required String nomEquipe,
  }) async {
    final doublette = await _repository.create(
      concoursId: concoursId,
      joueurA: joueurA,
      joueurB: joueurB,
      nomEquipe: nomEquipe,
    );

    final mancheRepo = mancheRepository;
    if (mancheRepo != null) {
      await mancheRepo.assignDoubletteToLatestManche(
        concoursId: concoursId,
        doubletteId: doublette.doubletteId,
      );
    }

    return doublette;
  }

  /// Returns first available team name from dictionary or fallback.
  Future<String> suggestTeamName(String concoursId) async {
    for (final candidate in teamNameDictionary) {
      final exists = await _repository.teamNameExists(
        concoursId: concoursId,
        nomEquipe: candidate,
      );
      if (!exists) {
        return candidate;
      }
    }

    var suffix = 1;
    while (true) {
      final fallback = 'Equipe $suffix';
      final exists = await _repository.teamNameExists(
        concoursId: concoursId,
        nomEquipe: fallback,
      );
      if (!exists) {
        return fallback;
      }
      suffix++;
    }
  }
}
