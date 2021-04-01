import 'package:flutter/material.dart';

import '../styles/singleLineChartStyle.dart';
import '../data/smoothing.dart';
import 'flutterChart.dart';

class Chart extends StatefulWidget {
  final Map<double, double> data;
  final Function(double) getHorizontalAxis;
  final Function(double) getVerticalAxis;
  final SingleLineChartStyle style;
  final bool allowPopupOverflow;
  final SmoothingType? smoothing;
  final int? width;
  final double? smoothness;
  final Function(double distance)? weighting;

  const Chart({
    Key? key,
    required this.data,
    required this.getHorizontalAxis,
    required this.getVerticalAxis,
    this.style = const SingleLineChartStyle(),
    this.allowPopupOverflow = false,
  })  : smoothing = null,
        width = null,
        smoothness = null,
        weighting = null,
        super(key: key);

  const Chart.smooth({
    Key? key,
    required this.data,
    required this.getHorizontalAxis,
    required this.getVerticalAxis,
    this.style = const SingleLineChartStyle(),
    this.allowPopupOverflow = false,
    this.smoothing = SmoothingType.Linear,
    this.width = 20,
    this.smoothness = 0.4,
    this.weighting,
  })  : assert(smoothing != SmoothingType.Custom || weighting != null),
        super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Map<double, double>? data, smoothed;
  int? width;
  double? smoothness;
  Function(double)? weighting;
  bool popup = false;

  bool get smoothing => widget.smoothing != null;

  void smooth() {
    switch (widget.smoothing) {
      case SmoothingType.Linear:
        smoothed = Smoothing.linear(data!, width, smoothness!);
        break;
      case SmoothingType.LocalAverage:
        smoothed = Smoothing.localAverage(data!, width);
        break;
      case SmoothingType.Sigmoid:
        smoothed = Smoothing.sigmoid(data!, width, smoothness!);
        break;
      case SmoothingType.Custom:
        smoothed = Smoothing.custom(data!, width, weighting);
        break;
      default:
        smoothed = data;
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (smoothing &&
        (widget.data != data ||
            widget.width != width ||
            widget.smoothness != smoothness ||
            widget.weighting != weighting)) {
      data = widget.data;
      width = widget.width;
      smoothness = widget.smoothness;
      weighting = widget.weighting;
      smooth();
    }

    return FlutterChart(
      data: smoothing ? smoothed : widget.data,
      style: widget.style,
      getHorizontalAxis: widget.getHorizontalAxis,
      getVerticalAxis: widget.getVerticalAxis,
      allowPopupOverflow: widget.allowPopupOverflow,
      popup: popup ? 1 : 0,
      showPopup: () => setState(() => popup = true),
      hidePopup: () => setState(() => popup = false),
      dataDrawProgress: 1,
      horizontalLinesDrawProgress: 1,
      verticalLinesDrawProgress: 1,
    );
  }
}
