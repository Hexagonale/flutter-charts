import 'package:flutter/material.dart';

import 'chartLineStyle.dart';

abstract class ChartStyle {
  final Color backgroundColor;
  final ChartLineStyle horizontalLinesStyle, verticalLinesStyle;
  final int horizontalPointsCount, verticalPointsCount;
  final TextStyle horizontalAxisTextStyle, verticalAxisTextStyle;
  final EdgeInsets plotPadding;

  const ChartStyle({
    this.backgroundColor = const Color(0xffffffff),
    this.horizontalLinesStyle = const ChartLineStyle(
      color: const Color(0xfff4f5f9),
    ),
    this.verticalLinesStyle = const ChartLineStyle(
      draw: false,
    ),
    this.horizontalPointsCount = 5,
    this.verticalPointsCount = 5,
    this.horizontalAxisTextStyle = const TextStyle(
      color: const Color(0xff858b9f),
      fontSize: 10,
    ),
    this.verticalAxisTextStyle = const TextStyle(
      color: const Color(0xff858b9f),
      fontSize: 10,
    ),
    this.plotPadding = const EdgeInsets.only(left: 10, bottom: 10),
  });
}