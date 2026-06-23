import 'package:belotable/domain/manches/manche_statut.dart';

/// A round (manche) within a contest.
class Manche {
  /// Creates a manche entity.
  const Manche({
    required this.id,
    required this.concoursId,
    required this.numero,
    required this.statut,
  });

  /// Unique identifier.
  final int id;

  /// Owning concours id.
  final String concoursId;

  /// Round number starting at 1.
  final int numero;

  /// Round completion status.
  final MancheStatut statut;
}
