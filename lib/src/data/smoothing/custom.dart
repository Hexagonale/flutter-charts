import 'dart:math';

/// Custom smoothing alogrithm
/// Takes range of [width] point neighbours and calculates weighted average using [weighting] function
/// returns map of smoothed points
Map<double, double> custom(
  Map<double, double> input,
  int? width,
  Function(double distance)? weighting,
) {
  Map<double, double> smoothed = Map();

  final List<MapEntry<double, double>> entries = input.entries.toList();

  for (int i = 0; i < input.entries.length; i++) {
    final MapEntry<double, double> point = entries[i];
    final Iterable<MapEntry<double, double>> neighbours = entries.getRange(
      max(0, i - width!),
      min(i + width, input.length - 1),
    );
    final int localCenter = min(i, width);

    double counter = 0;
    double sum = 0;

    for (int j = 0; j < neighbours.length; j++) {
      final int distance = (localCenter - j).abs();
      final double percent = distance / width;
      final double weight = weighting!(percent);

      if (weight <= 0.01) {
        if (i < j) break;
        continue;
      }

      sum += weight * neighbours.elementAt(j).value;
      counter += weight;
    }

    counter == 0 ? sum = point.value : sum /= counter;
    smoothed[point.key] = sum;
  }

  return smoothed;
}
