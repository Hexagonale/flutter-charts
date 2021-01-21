import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../styles/singleLineChartStyle.dart';
import '../painters/singleLineChartPainter.dart';

class FlutterChart extends StatefulWidget {
  final Map<double, double> data;
  final Function(double) getHorizontalAxis;
  final Function(double) getVerticalAxis;
  final SingleLineChartStyle style;
  final bool allowPopupOverflow;
  final double popup;
  final Function showPopup;
  final Function hidePopup;
  final double dataDrawProgress;
  final double horizontalLinesDrawProgress;
  final double verticalLinesDrawProgress;

  const FlutterChart({
    @required this.data,
    @required this.getHorizontalAxis,
    @required this.getVerticalAxis,
    @required this.style,
    @required this.allowPopupOverflow,
    @required this.popup,
    @required this.showPopup,
    @required this.hidePopup,
    @required this.dataDrawProgress,
    @required this.horizontalLinesDrawProgress,
    @required this.verticalLinesDrawProgress,
  });

  @override
  _FlutterChartState createState() => _FlutterChartState();
}

class _FlutterChartState extends State<FlutterChart>
    with TickerProviderStateMixin {
  Map<double, double> data;
  Map<double, double> smooth = Map();
  Offset tap;
  double lastValue;

  void startTap(Offset offset) {
    tap = offset;
    widget.showPopup();
  }

  void updateTap(Offset offset) => setState(() => tap = offset);
  void endTap() => widget.hidePopup();

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (details) =>
            widget.popup < 0.5 ? startTap(details.localPosition) : null,
        onTapUp: (details) =>
            widget.popup < 0.5 ? startTap(details.localPosition) : endTap(),
        onPanStart: (details) => startTap(details.localPosition),
        onPanUpdate: (details) => updateTap(details.localPosition),
        onPanEnd: (details) => endTap(),
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            painter: SingleLineChartPainter(
              style: widget.style, //widget.style,
              getHorizontalAxis: widget.getHorizontalAxis,
              getVerticalAxis: widget.getVerticalAxis,
              rawData: widget.data,
              tap: tap,
              allowPopupOverflow: widget.allowPopupOverflow,
              horizontalLinesAnimationValue: widget
                  .horizontalLinesDrawProgress, //dataIntroAnimation.value,
              verticalLinesAnimationValue:
                  widget.verticalLinesDrawProgress, //dataIntroAnimation.value,
              dataIntroAnimationValue: widget.dataDrawProgress,
              popupAnimationValue: widget.popup,
            ),
          ),
        ),
      );
}
