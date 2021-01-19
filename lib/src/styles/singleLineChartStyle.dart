import 'package:flutter/material.dart';

import 'chartStyle.dart';
import 'chartLineStyle.dart';
import 'popupStyle.dart';

class SingleLineChartStyle extends ChartStyle {
  final ChartLineStyle dataLineStyle;
  final PopupStyle popupStyle;

  const SingleLineChartStyle({
    Color backgroundColor,
    ChartLineStyle horizontalLinesStyle,
    ChartLineStyle verticalLinesStyle,
    int horizontalPointsCount,
    int verticalPointsCount,
    TextStyle horizontalAxisTextStyle,
    TextStyle verticalAxisTextStyle,
    EdgeInsets plotPadding,
    this.dataLineStyle = const ChartLineStyle(
      color: const Color(0xfffb6280),
    ),
    this.popupStyle = const PopupStyle(),
  }) : super(
          backgroundColor: backgroundColor,
          horizontalLinesStyle: horizontalLinesStyle,
          verticalLinesStyle: verticalLinesStyle,
          horizontalPointsCount: horizontalPointsCount,
          verticalPointsCount: verticalPointsCount,
          horizontalAxisTextStyle: horizontalAxisTextStyle,
          verticalAxisTextStyle: verticalAxisTextStyle,
          plotPadding: plotPadding,
        );
}