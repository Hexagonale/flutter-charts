import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../styles/singleLineChartStyle.dart';
import 'chart.dart';

class SingleLineChartPainter extends ChartPainter {
  final SingleLineChartStyle style;
  final Map<double, double> rawData;
  final List<double> keys;
  final Function(Canvas canvas, Size size, Offset point) drawPoint;
  final Function(Canvas canvas, Size size, Offset point) drawPopup;

  SingleLineChartPainter({
    @required Function(double) getVerticalAxis,
    @required Function(double) getHorizontalAxis,
    bool allowPopupOverflow = false,
    Offset tap,
    @required this.style,
    @required this.rawData,
    @required this.drawPoint,
    @required this.drawPopup,
  })  : keys = rawData.keys.toList()..sort(),
        super(
          style: style,
          getVerticalAxis: getVerticalAxis,
          getHorizontalAxis: getHorizontalAxis,
          allowPopupOverflow: allowPopupOverflow,
          tap: tap,
        );

  // Draws data line
  @override
  void drawChart(Canvas canvas, Size size) {
    final Paint dataPaint = Paint()
      ..color = style.dataLineStyle.color
      ..strokeWidth = style.dataLineStyle.width
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    final start = _getPointFromKey(keys.first, size);
    path.moveTo(start.dx, start.dy);

    // Offset last = _getPointFromKey(keys.first, size);

    for (final double key in keys.getRange(1, keys.length)) {
      final Offset point = _getPointFromKey(key, size);
      path.lineTo(point.dx, point.dy);
      // canvas.drawLine(last, point, dataPaint);
      // last = point;
    }

    canvas.drawPath(path, dataPaint);
  }

  // Draws onTap popup and point
  @override
  void drawTap(Canvas canvas, Size size) {
    // Get touch offset in percents of usable space
    final Offset point = _getTapPercentage(size);

    // Draw point and rectangle
    (drawPoint ?? _drawPoint)(canvas, size, point);
    (drawPopup ?? _drawPopup)(canvas, size, point);
  }

  // Draws onTap popup
  void _drawPopup(Canvas canvas, Size size, Offset point) {
    // Create rectangle painter
    final rectanglePainter = new Paint()
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
    final Size bgSize = style.popupStyle.size ??
        Size(
          textSize.width + style.popupStyle.padding.horizontal,
          textSize.height + style.popupStyle.padding.vertical + 40,
        );

    // Convert percents to canvas coords
    Offset drawablePoint = _getPointFromOffset(point, size).translate(
      0,
      -20 - (bgSize.height / 2),
    );

    // Check if popup is overflowing canvas
    if (!allowPopupOverflow) {
      if (drawablePoint.dy - (bgSize.height / 2) < 0)
        drawablePoint = _getPointFromOffset(point, size).translate(
          0,
          20 + (bgSize.height / 2),
        );
      if (drawablePoint.dx - (bgSize.width / 2) < 0)
        drawablePoint = drawablePoint.translate(
          -drawablePoint.dx + (bgSize.width / 2),
          0,
        );
      if (drawablePoint.dx + (bgSize.width / 2) > size.width)
        drawablePoint = drawablePoint.translate(
          size.width - drawablePoint.dx - (bgSize.width / 2),
          0,
        );
    }

    // Create rects
    final Rect textRect = _sizeAndCenterToRect(textSize, drawablePoint);
    final RRect bgRect = RRect.fromRectAndCorners(
      _sizeAndCenterToRect(bgSize, drawablePoint),
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
      true,
    );
    canvas.drawPath(rectangle, rectanglePainter);

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
  void _drawPoint(Canvas canvas, Size size, Offset point) {
    // Convert percents to canvas coords
    final Offset drawablePoint = _getPointFromOffset(point, size);

    // Create painters
    final outerPointPainter = new Paint()
      ..color = style.dataLineStyle.color
      ..strokeWidth = style.dataLineStyle.width
      ..style = PaintingStyle.stroke;
    final pointPainter = new Paint()
      ..color = style.backgroundColor
      ..style = PaintingStyle.fill;

    // Draw circles
    canvas.drawCircle(drawablePoint, 8, outerPointPainter);
    canvas.drawCircle(drawablePoint, 4, outerPointPainter..strokeWidth = 1);
    canvas.drawCircle(drawablePoint, 4, pointPainter);
  }

  Offset _getTapPercentage(Size size) {
    // Get percentage of touch in relation to usabe space
    // And limit iit within space
    final double tap = min(max(_getPercent(this.tap, size).dx, 0), 1);

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

  Offset _getPointFromKey(double key, Size size) {
    final chartRect = getChartRect(size);

    return Offset(
      (key * chartRect.width) + chartRect.left,
      chartRect.height - (rawData[key] * chartRect.height) + chartRect.top,
    );
  }

  Offset _getPointFromOffset(Offset offset, Size size) {
    final chartRect = getChartRect(size);

    return Offset(
      (offset.dx * chartRect.width) + chartRect.left,
      chartRect.height - (offset.dy * chartRect.height) + chartRect.top,
    );
  }

  Offset _getPercent(Offset point, Size size) {
    final chartRect = getChartRect(size);

    return Offset(
      (point.dx - chartRect.left) / chartRect.width,
      (point.dy - chartRect.top) / chartRect.height,
    );
  }

  @override
  bool shouldRepaint(covariant SingleLineChartPainter oldDelegate) {
    if (oldDelegate.style != style) return true;
    if (oldDelegate.rawData != rawData) return true;
    if (oldDelegate.drawPoint != drawPoint) return true;
    if (oldDelegate.drawPopup != drawPopup) return true;
    if (super.shouldRepaint(oldDelegate)) return true;

    return false;
  }
}
