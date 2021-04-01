import 'custom.dart';

/// Linear smoothing alogrithm
/// Takes range of [width] point neighbours and calculates weighted average
/// returns map of smoothed points
Map<double, double> linear(
  Map<double, double> input,
  int? width,
  double smoothness,
) {
  smoothness += 0.001;

  return custom(
    input,
    width,
    (double distance) => (-distance / smoothness) + 1,
  );
}
