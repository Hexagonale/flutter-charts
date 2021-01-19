import 'dart:math';
import 'dart:ui';

import 'custom.dart';

double _sigmoid(double x, [double power = -1]) => 1 / (1 + pow(e, power * x));

/// Sigmoid smoothing alogrithm
/// Takes range of [width] point neighbours and calculates weighted average using sigmoid function
/// returns map of smoothed points
Map<double, double> sigmoid(
  Map<double, double> input,
  int width,
  double smoothness,
) {
  smoothness = lerpDouble(width, 0.0001, smoothness);

  return custom(
    input,
    width,
    (double distance) => _sigmoid(distance, smoothness) * 2,
  );
}
