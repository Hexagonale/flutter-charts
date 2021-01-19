import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'data/normalize.dart';
import 'data/smoothing/linear.dart';
import 'styles/popupStyle.dart';
import 'styles/singleLineChartStyle.dart';
import 'painters/singleLineChartPainter.dart';

class Chart extends StatefulWidget {
  final SingleLineChartStyle style;
  final allowPopupOverflow;
  final double value;
  final Map<double, double> data;

  const Chart({
    this.style = const SingleLineChartStyle(),
    this.allowPopupOverflow = false,
    @required this.value,
    @required this.data,
  });

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Map<double, double> data;
  Map<double, double> smooth = Map();
  Offset tap;
  double lastValue;

  String getHorizontalAxis(double percent) {
    final DateTime target = DateTime.now()
        .add(lerpDuration(Duration(hours: -3), Duration.zero, percent));

    return '${target.hour.toString().padLeft(2, '0')}:${target.minute.toString().padLeft(2, '0')}';
  }

  String getVerticalAxis(double percent) =>
      '${((percent * 100 * 100).round() / 100)}%';

  @override
  Widget build(BuildContext context) {
    if (lastValue != widget.value || data != widget.data) {
      smooth = normalize(widget.data);
      smooth = linear(widget.data, 20, widget.value);

      lastValue = widget.value;
      data = widget.data;
    }

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
        child: GestureDetector(
          onTapUp: (details) =>
              setState(() => tap = tap == null ? details.localPosition : null),
          onPanStart: (details) => setState(() => tap = details.localPosition),
          onPanUpdate: (details) => setState(() => tap = details.localPosition),
          onPanEnd: (details) => setState(() => tap = null),
          child: Container(
            color: Colors.white,
            child: CustomPaint(
              painter: SingleLineChartPainter(
                style: SingleLineChartStyle(
                  popupStyle: PopupStyle(
                    size: Size(80, 50),
                  ),
                ), //widget.style,
                getHorizontalAxis: getHorizontalAxis,
                getVerticalAxis: getVerticalAxis,
                rawData: smooth,
                tap: tap,
                allowPopupOverflow: widget.allowPopupOverflow,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
