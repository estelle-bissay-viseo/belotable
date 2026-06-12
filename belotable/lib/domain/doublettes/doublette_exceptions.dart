/// Error thrown when team name is not unique for a contest.
class DuplicateTeamNameException implements Exception {
  /// Creates exception with conflicting team name.
  const DuplicateTeamNameException(this.nomEquipe);

  /// Team name that already exists.
  final String nomEquipe;

  @override
  String toString() {
    return 'DuplicateTeamNameException: nomEquipe already exists: $nomEquipe';
  }
}
