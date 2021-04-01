import 'package:flutter/material.dart';

import 'chartLineStyle.dart';
import 'chartStyle.dart';
import 'popupStyle.dart';

class MultiLineChartStyle extends ChartStyle {
  final ChartLineStyle dataLineStyle;
  final PopupStyle popupStyle;

  MultiLineChartStyle({
    Color? backgroundColor,
    ChartLineStyle? horizontalLinesStyle,
    ChartLineStyle? verticalLinesStyle,
    int? horizontalPointsCount,
    int? verticalPointsCount,
    TextStyle? horizontalAxisTextStyle,
    TextStyle? verticalAxisTextStyle,
    EdgeInsets? plotPadding,
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
