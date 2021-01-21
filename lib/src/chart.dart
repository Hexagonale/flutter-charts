import 'dart:ui';

import 'package:charts/src/styles/chartLineStyle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/normalize.dart';
import 'data/smoothing/linear.dart';
import 'styles/popupStyle.dart';
import 'styles/singleLineChartStyle.dart';
import 'painters/singleLineChartPainter.dart';

//TODO find a better way to pass animation (maybe value and listener)
class Chart extends StatefulWidget {
  final SingleLineChartStyle style;
  final allowPopupOverflow;
  final double value;
  final Map<double, double> data;
  final AnimationController popupAnimationController;
  final AnimationController dataIntroAnimationController;
  final Animation popupAnimation;
  final Animation dataIntroAnimation;

  const Chart({
    this.style = const SingleLineChartStyle(),
    this.allowPopupOverflow = false,
    @required this.value,
    @required this.data,
    this.popupAnimationController,
    this.dataIntroAnimationController,
    this.popupAnimation,
    this.dataIntroAnimation,
  });

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> with TickerProviderStateMixin {
  Map<double, double> data;
  Map<double, double> smooth = Map();
  Offset tap;
  double lastValue;
  Animation dataIntroAnimation, popupAnimation;
  AnimationController dataIntroAnimationController, popupAnimationController;

  @override
  void initState() {
    super.initState();

    if (widget.dataIntroAnimationController == null) {
      dataIntroAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1500),
      );
      dataIntroAnimation = CurvedAnimation(
        curve: Curves.easeInOut,
        parent: dataIntroAnimationController,
      );
    } else {
      dataIntroAnimationController = widget.dataIntroAnimationController;
      dataIntroAnimation = widget.dataIntroAnimation;
    }

    if (widget.popupAnimationController == null) {
      popupAnimationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 225),
      );
      popupAnimation = CurvedAnimation(
        curve: Curves.easeInOut,
        parent: popupAnimationController,
      );
    } else {
      popupAnimationController = widget.popupAnimationController;
      popupAnimation = widget.popupAnimation;
    }

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => dataIntroAnimationController.forward(),
    );
  }

  String getHorizontalAxis(double percent) {
    final DateTime target = DateTime.now()
        .add(lerpDuration(Duration(hours: -3), Duration.zero, percent));

    return '${target.hour.toString().padLeft(2, '0')}:${target.minute.toString().padLeft(2, '0')}';
  }

  String getVerticalAxis(double percent) =>
      '${((percent * 100 * 100).round() / 100)}%';

  void startTap(Offset offset) {
    tap = offset;
    popupAnimationController.forward();
  }

  void updateTap(Offset offset) => setState(() => tap = offset);
  void endTap() => popupAnimationController.reverse();

  @override
  Widget build(BuildContext context) {
    if (lastValue != widget.value || data != widget.data) {
      smooth = normalize(widget.data);
      smooth = linear(widget.data, 20, widget.value);

      if (data != widget.data) dataIntroAnimationController.forward(from: 0);

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
          onTapDown: (details) => popupAnimation.value < 0.5
              ? startTap(details.localPosition)
              : null,
          onTapUp: (details) => popupAnimation.value < 0.5
              ? startTap(details.localPosition)
              : endTap(),
          onPanStart: (details) => startTap(details.localPosition),
          onPanUpdate: (details) => updateTap(details.localPosition),
          onPanEnd: (details) => endTap(),
          child: Container(
            color: Colors.white,
            child: AnimatedBuilder(
              animation: dataIntroAnimation,
              builder: (BuildContext context, Widget child) => AnimatedBuilder(
                animation: popupAnimation,
                builder: (BuildContext context, Widget child) => CustomPaint(
                  painter: SingleLineChartPainter(
                    style: SingleLineChartStyle(
                      popupStyle: PopupStyle(
                        size: Size(80, 50),
                      ),
                      verticalLinesStyle: ChartLineStyle(
                        color: Colors.black,
                        draw: true,
                        width: 1,
                      ),
                    ), //widget.style,
                    getHorizontalAxis: getHorizontalAxis,
                    getVerticalAxis: getVerticalAxis,
                    rawData: smooth,
                    tap: tap,
                    allowPopupOverflow: widget.allowPopupOverflow,
                    animationValue: dataIntroAnimationController.value,
                    popupAnimationValue: popupAnimationController.value,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
