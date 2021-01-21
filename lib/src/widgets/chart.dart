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
  final SmoothingType smoothing;
  final Function(double distance) weighting;

  const Chart({
    Key key,
    @required this.data,
    @required this.getHorizontalAxis,
    @required this.getVerticalAxis,
    this.style = const SingleLineChartStyle(),
    this.allowPopupOverflow = false,
  })  : smoothing = null,
        weighting = null,
        super(key: key);

  const Chart.smooth({
    Key key,
    @required this.data,
    @required this.getHorizontalAxis,
    @required this.getVerticalAxis,
    this.style = const SingleLineChartStyle(),
    this.allowPopupOverflow = false,
    this.smoothing = SmoothingType.Linear,
    this.weighting,
  })  : assert(smoothing != SmoothingType.Custom || weighting != null),
        super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  Map<double, double> data, smoothed;
  bool popup = false;

  bool get smoothing => widget.smoothing != null;

  void smooth() {
    switch (widget.smoothing) {
      case SmoothingType.Linear:
        smoothed = Smoothing.linear(data, 20, 0.3);
        break;
      case SmoothingType.LocalAverage:
        smoothed = Smoothing.localAverage(data, 20);
        break;
      case SmoothingType.Sigmoid:
        smoothed = Smoothing.sigmoid(data, 20, 0.3);
        break;
      case SmoothingType.Custom:
        smoothed = Smoothing.custom(data, 20, widget.weighting);
        break;
      default:
        smoothed = data;
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (smoothing && widget.data != data) {
      data = widget.data;
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
