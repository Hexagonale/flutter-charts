import 'dart:math';

/// Local average smoothing alogrithm
/// Takes range of [width] point neighbours and calculates average
/// returns map of smoothed points
Map<double, double> localAverage(Map<double, double> input, int width) {
  final Map<double, double> smoothed = Map();

  final List<MapEntry<double, double>> entries = input.entries.toList();

  for (int i = 0; i < input.entries.length; i++) {
    final MapEntry<double, double> point = entries[i];
    final Iterable<MapEntry<double, double>> neighbours = entries.getRange(
      max(0, i - width),
      min(i + width, input.length - 1),
    );

    final double sum = neighbours.fold(0, (acc, e) => acc + e.value);
    smoothed.putIfAbsent(point.key, () => sum / neighbours.length);
  }

  return smoothed;
}
