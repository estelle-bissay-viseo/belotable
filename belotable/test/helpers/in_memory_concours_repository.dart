import 'package:belotable/domain/concours/concours.dart';
import 'package:belotable/domain/concours/concours_repository.dart';

class InMemoryConcoursRepository implements ConcoursRepository {
  final savedConcours = <Concours>[];

  @override
  Future<void> save(Concours concours) async {
    savedConcours.add(concours);
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
