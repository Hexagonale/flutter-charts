import 'package:flutter/material.dart';

import 'chartStyle.dart';
import 'chartLineStyle.dart';
import 'popupStyle.dart';

class SingleLineChartStyle extends ChartStyle {
  final ChartLineStyle dataLineStyle;
  final PopupStyle popupStyle;

  const SingleLineChartStyle({
    Color backgroundColor = const Color(0xffffffff),
    ChartLineStyle horizontalLinesStyle = const ChartLineStyle(
      color: const Color(0xfff4f5f9),
    ),
    ChartLineStyle verticalLinesStyle = const ChartLineStyle(
      draw: false,
    ),
    int horizontalPointsCount = 5,
    int verticalPointsCount = 5,
    TextStyle horizontalAxisTextStyle = const TextStyle(
      color: const Color(0xff858b9f),
      fontSize: 10,
    ),
    TextStyle verticalAxisTextStyle = const TextStyle(
      color: const Color(0xff858b9f),
      fontSize: 10,
    ),
    EdgeInsets plotPadding = const EdgeInsets.only(left: 10, bottom: 10),
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
