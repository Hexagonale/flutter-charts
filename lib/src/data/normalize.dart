import 'dart:math';

// TODO test performance
/// Normalizes input map
/// returns Map of doubles beetwen 0..1 inclusive
Map<double, double> normalize(Map<double, double> input) {
  final Map<double, double> normalized = Map();

  List<double> minMaxX = input.keys.fold(
    [0, 0],
    (acc, e) => [min(e, acc[0]), max(e, acc[1])],
  );
  final double minX = minMaxX[0];
  final double maxX = minMaxX[1];
  // final double minX = input.keys.fold(0, (acc, e) => min(e, acc));
  // final double maxX = input.keys.fold(0, (acc, e) => max(e, acc));
  final double timeSpan = maxX - minX;

  List<double> minMaxY = input.values.fold(
    [0, 0],
    (acc, e) => [min(e, acc[0]), max(e, acc[1])],
  );
  final double minY = minMaxY[0];
  final double maxY = minMaxY[1];
  // final double minY = input.values.fold(0, (acc, e) => min(e, acc));
  // final double maxY = input.values.fold(0, (acc, e) => max(e, acc));
  final double valueSpan = maxY - minY;

  for (MapEntry<double, double> point in input.entries) {
    final double key = (point.key - minX) / timeSpan;
    final double value = (point.value - minY) / valueSpan;

    normalized[key] = value;
  }

  return normalized;
}
