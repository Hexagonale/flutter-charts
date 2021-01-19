import 'package:flutter/material.dart';

class ChartLineStyle {
  final bool draw;
  final Color color;
  final double width;

  const ChartLineStyle({
    this.draw = true,
    this.color = const Color(0),
    this.width = 2,
  });
}
