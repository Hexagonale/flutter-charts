import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../styles/singleLineChartStyle.dart';
import 'chart.dart';

class SingleLineChartPainter extends ChartPainter {
  final SingleLineChartStyle style;
  final Map<double, double> rawData;
  final List<double> keys;
  final Function(
    Canvas canvas,
    Size size,
    Offset point,
    Offset drawablePoint,
    double animationValue,
  ) drawPoint;
  final Function(
    Canvas canvas,
    Size size,
    Offset point,
    Offset drawablePoint,
    double animationValue,
  ) drawPopup;
  final double popupAnimationValue;
  final double dataIntroAnimationValue;

  SingleLineChartPainter({
    @required Function(double) getVerticalAxis,
    @required Function(double) getHorizontalAxis,
    bool allowPopupOverflow = false,
    Offset tap,
    double horizontalLinesAnimationValue = 0,
    double verticalLinesAnimationValue = 0,
    @required this.style,
    @required this.rawData,
    this.drawPoint,
    this.drawPopup,
    this.popupAnimationValue = 0,
    this.dataIntroAnimationValue = 1,
  })  : keys = rawData.keys.toList()..sort(),
        super(
          style: style,
          getVerticalAxis: getVerticalAxis,
          getHorizontalAxis: getHorizontalAxis,
          allowPopupOverflow: allowPopupOverflow,
          tap: tap,
          horizontalLinesAnimationValue: horizontalLinesAnimationValue,
          verticalLinesAnimationValue: verticalLinesAnimationValue,
        );

  // Draws onTap popup
  void _drawPopup(
    Canvas canvas,
    Size size,
    Offset point,
    Offset drawablePoint,
    double animationValue,
  ) {
    // Create rectangle painter
    final Paint rectanglePainter = new Paint()
      ..color = style.popupStyle.color
      ..style = PaintingStyle.fill;

    // Get vertical painter
    final TextPainter yPainter = drawText(
      getVerticalAxis(point.dy),
      style.popupStyle.valueTextStyle,
    );

    // Get horizontal painter
    final TextPainter xPainter = drawText(
      getHorizontalAxis(point.dx),
      style.popupStyle.keyTextStyle,
    );

    // Calculate rect sizes
    final Size textSize = Size(
      max(yPainter.width, xPainter.width),
      yPainter.height + style.popupStyle.textSpacing + xPainter.height,
    );
    Size bgSize = style.popupStyle.size ??
        Size(
          textSize.width + style.popupStyle.padding.horizontal,
          textSize.height + style.popupStyle.padding.vertical + 40,
        );

    // Convert percents to canvas coords
    Offset popupCenter = drawablePoint.translate(0, -20 - (bgSize.height / 2));

    // Check if popup is overflowing canvas
    if (!allowPopupOverflow) {
      if (popupCenter.dy - (bgSize.height / 2) < 0) {
        popupCenter = drawablePoint.translate(0, 20 + (bgSize.height / 2));
      }

      if (popupCenter.dx - (bgSize.width / 2) < 0) {
        popupCenter = popupCenter.translate(
          -popupCenter.dx + (bgSize.width / 2),
          0,
        );
      }

      if (popupCenter.dx + (bgSize.width / 2) > size.width) {
        popupCenter = popupCenter.translate(
          size.width - popupCenter.dx - (bgSize.width / 2),
          0,
        );
      }
    }

    if (animationValue != 1) {
      final double originalHeight = bgSize.height;

      bgSize = Size(
        bgSize.width * animationValue,
        bgSize.height * animationValue,
      );

      if (popupCenter.dy > drawablePoint.dy)
        popupCenter = popupCenter.translate(0, bgSize.height - originalHeight);
      else
        popupCenter = popupCenter.translate(0, originalHeight - bgSize.height);
    }

    // Create rects
    final Rect textRect = _sizeAndCenterToRect(textSize, popupCenter);
    final RRect bgRect = RRect.fromRectAndCorners(
      _sizeAndCenterToRect(bgSize, popupCenter),
      topLeft: style.popupStyle.borderRadius.topLeft,
      bottomLeft: style.popupStyle.borderRadius.bottomLeft,
      bottomRight: style.popupStyle.borderRadius.bottomRight,
      topRight: style.popupStyle.borderRadius.topRight,
    );

    // Create reactangle path and draw it
    final Path rectangle = Path()..addRRect(bgRect);
    canvas.drawShadow(
      rectangle,
      style.popupStyle.shadowColor,
      style.popupStyle.elevation,
      false,
    );
    canvas.drawPath(rectangle, rectanglePainter);

    if (animationValue < 0.8) return;
    // Draw texts
    yPainter.paint(
      canvas,
      textRect.topCenter.translate(yPainter.width / -2, 0),
    );

    xPainter.paint(
      canvas,
      textRect.bottomCenter.translate(xPainter.width / -2, -xPainter.height),
    );
  }

  // Draws onTap point
  void _drawPoint(
    Canvas canvas,
    Size size,
    Offset point,
    Offset drawablePoint,
    double animationValue,
  ) {
    // Create painters
    final outerPointPainter = new Paint()
      ..color = style.dataLineStyle.color
      ..strokeWidth = style.dataLineStyle.width
      ..style = PaintingStyle.stroke;
    final pointPainter = new Paint()
      ..color = style.backgroundColor
      ..style = PaintingStyle.fill;

    // Draw circles
    canvas.drawCircle(
      drawablePoint,
      8 * animationValue,
      outerPointPainter,
    );
    canvas.drawCircle(
      drawablePoint,
      4 * animationValue,
      outerPointPainter..strokeWidth = 1,
    );
    canvas.drawCircle(
      drawablePoint,
      4 * animationValue,
      pointPainter,
    );
  }

  // Returns point percentage position in relation to chart
  Offset _getPointPercent(Offset point) => Offset(
        (point.dx - chartRect.left) / chartRect.width,
        (point.dy - chartRect.top) / chartRect.height,
      );

  Offset _getTapPoint(Size size) {
    // Get percentage of touch in relation to chart
    // And limit it within space
    final double tap = min(max(_getPointPercent(this.tap).dx, 0), 1);

    // Array for closests neighbours
    final List<double> neighbours = [];

    // We need to get not closests points but neighbours
    // If "x" is our touch and "o" are points
    // o.o.x.......o
    // Closests points are NOT neighbours
    for (int i = 0; i < keys.length - 1; i++) {
      final double key = keys[i], next = keys[i + 1];

      // These are our neighbours
      if (key <= tap && next >= tap) {
        neighbours.addAll([key, next]);
        break;
      }
    }

    // Sum ting wong
    if (neighbours.length == 0) return Offset.zero;

    // Get percentage of touch beetwen them
    final double percent =
        (tap - neighbours[0]) / (neighbours[1] - neighbours[0]);

    // Return lerped offset
    return Offset(
      tap,
      ui.lerpDouble(rawData[neighbours[0]], rawData[neighbours[1]], percent),
    );
  }

  Rect _sizeAndCenterToRect(Size size, Offset center) => Rect.fromLTRB(
        center.dx - (size.width / 2),
        center.dy - (size.height / 2),
        center.dx + (size.width / 2),
        center.dy + (size.height / 2),
      );

  Offset _getPointFromKey(double key) => Offset(
        (key * chartRect.width) + chartRect.left,
        chartRect.height - (rawData[key] * chartRect.height) + chartRect.top,
      );

  Offset _getPointFromOffset(Offset offset, Size size) => Offset(
        (offset.dx * chartRect.width) + chartRect.left,
        chartRect.height - (offset.dy * chartRect.height) + chartRect.top,
      );

  // Draws data line
  @override
  void drawChart(Canvas canvas, Size size) {
    final Paint dataPaint = Paint()
      ..color = style.dataLineStyle.color
      ..strokeWidth = style.dataLineStyle.width
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    final start = _getPointFromKey(keys.first);
    path.moveTo(start.dx, start.dy);

    final int maxKey = (keys.length * (dataIntroAnimationValue ?? 1)).ceil();
    for (int i = 1; i < maxKey; i++) {
      final Offset point = _getPointFromKey(keys[i]);
      path.lineTo(point.dx, point.dy);
    }

    canvas.drawPath(path, dataPaint);
  }

  // Draws onTap popup and point
  @override
  void drawTap(Canvas canvas, Size size) {
    if (popupAnimationValue <= 0) return;

    // Get touch offset in percents of chart
    final Offset point = _getTapPoint(size);
    final Offset drawablePoint = _getPointFromOffset(point, size);

    // Draw point and rectangle
    (drawPoint ?? _drawPoint)(
      canvas,
      size,
      point,
      drawablePoint,
      popupAnimationValue,
    );

    (drawPopup ?? _drawPopup)(
      canvas,
      size,
      point,
      drawablePoint,
      popupAnimationValue,
    );
  }

  @override
  bool shouldRepaint(covariant SingleLineChartPainter oldDelegate) {
    if (oldDelegate.style != style) return true;
    if (oldDelegate.rawData != rawData) return true;
    if (oldDelegate.drawPoint != drawPoint) return true;
    if (oldDelegate.drawPopup != drawPopup) return true;
    if (oldDelegate.popupAnimationValue != popupAnimationValue) return true;
    if (oldDelegate.dataIntroAnimationValue != dataIntroAnimationValue)
      return true;
    if (super.shouldRepaint(oldDelegate)) return true;

    return false;
  }
}
