import 'smoothing/linear.dart' as s;
import 'smoothing/localAverage.dart' as s;
import 'smoothing/sigmoid.dart' as s;
import 'smoothing/custom.dart' as s;

class Smoothing {
  static Map<double, double> linear(
    Map<double, double> input,
    int width,
    double smoothness,
  ) =>
      s.linear(input, width, smoothness);

  static Map<double, double> localAverage(
    Map<double, double> input,
    int width,
  ) =>
      s.localAverage(input, width);

  static Map<double, double> sigmoid(
    Map<double, double> input,
    int width,
    double smoothness,
  ) =>
      s.sigmoid(input, width, smoothness);

  static Map<double, double> custom(
    Map<double, double> input,
    int width,
    Function(double distance) weighting,
  ) =>
      s.custom(input, width, weighting);
}

enum SmoothingType { Linear, LocalAverage, Sigmoid, Custom }
