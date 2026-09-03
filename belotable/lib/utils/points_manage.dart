/// Generates all possible pairs of non-negative integers (x, y)
/// such that x + y = a + b.
List<(int, int)> generatePairs(int a, int b) {
  final sum = a + b;
  final result = <(int, int)>[];

  for (var first = 0; first <= sum ~/ 2; first++) {
    result.add((first, sum - first));
  }

  return result;
}
