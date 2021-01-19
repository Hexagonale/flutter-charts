import 'package:flutter/material.dart';

import 'chartLineStyle.dart';

abstract class ChartStyle {
  final Color backgroundColor;
  final ChartLineStyle horizontalLinesStyle, verticalLinesStyle;
  final int horizontalPointsCount, verticalPointsCount;
  final TextStyle horizontalAxisTextStyle, verticalAxisTextStyle;
  final EdgeInsets plotPadding;

  const ChartStyle({
    @required this.backgroundColor,
    @required this.horizontalLinesStyle,
    @required this.verticalLinesStyle,
    @required this.horizontalPointsCount,
    @required this.verticalPointsCount,
    @required this.horizontalAxisTextStyle,
    @required this.verticalAxisTextStyle,
    @required this.plotPadding,
  });
}
