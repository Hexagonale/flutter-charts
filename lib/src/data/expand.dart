import 'dart:math';

import 'dart:ui';

Map<double, double?> expand(Map<double, double> input, double factor) {
  final Map<double, double?> expanded = Map();

  final Iterator<double> keys = input.keys.iterator;
  final double minX = input.keys.fold(0, (acc, e) => min(e, acc));
  final double maxX = input.keys.fold(0, (acc, e) => max(e, acc));
  final double timeSpan = maxX - minX;
  // final double minY = input.values.fold(0, (acc, e) => min(e, acc));
  // final double maxY = input.values.fold(0, (acc, e) => max(e, acc));
  // final double valueSpan = maxY - minY;
  final int length = (input.length * factor).round();

  keys.moveNext();
  double prev = keys.current;
  keys.moveNext();

  for (int i = 0; i < length; i++) {
    final double percent = i / (length - 1);
    final double key = lerpDouble(minX, maxX, percent)!;

    if (key > keys.current) {
      prev = keys.current;
      keys.moveNext();
    }

    expanded.putIfAbsent(
      key,
      () => lerpDouble(input[prev], input[keys.current], percent),
    );
  }

  return expanded;
}
