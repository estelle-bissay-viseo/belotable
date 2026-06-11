import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';

class InMemoryConcoursRepository implements ConcoursRepository {
  final savedConcours = <Concours>[];

  @override
  Future<void> save(Concours concours) async {
    final index = savedConcours.indexWhere((entry) => entry.id == concours.id);
    if (index == -1) {
      savedConcours.add(concours);
      return;
    }

    savedConcours[index] = concours;
  }

  @override
  Future<Concours?> findById(String id) async {
    for (final concours in savedConcours) {
      if (concours.id == id) {
        return concours;
      }
    }

    return null;
  }

  @override
  Future<List<Concours>> findAllByDateDesc() async {
    return [...savedConcours]..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<bool> delete(String id) async {
    final initialLength = savedConcours.length;
    savedConcours.removeWhere((c) => c.id == id);
    return savedConcours.length < initialLength;
  }
}
