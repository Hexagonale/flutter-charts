import 'dart:ui' as ui;

import 'package:flutter/material.dart';

// class MultilineChartPainter extends ChartPainter {
//   final ChartStyle style;
//   final Function(double) getVerticalAxis, getHorizontalAxis;
//   final Map<double, double> rawData;
//   final List<double> keys;
//   final Offset tap;
//   final bool allowPopupOverflow;
//   final Function(Canvas canvas, Size size, Offset point) drawPoint;
//   final Function(Canvas canvas, Size size, Offset point) drawPopup;

//   EdgeInsets usableSpacePadding = const EdgeInsets.all(0);

//   ChartPainter({
//     @required this.style,
//     @required this.getVerticalAxis,
//     @required this.getHorizontalAxis,
//     @required Map<double, double> rawData,
//     this.allowPopupOverflow = false,
//     this.drawPoint,
//     this.drawPopup,
//     this.tap,
//   })  : this.rawData = rawData,
//         keys = rawData.keys.toList()..sort();

//   TextPainter _drawText(String text, TextStyle style) => TextPainter(
//         text: TextSpan(text: text, style: style),
//         textDirection: ui.TextDirection.rtl,
//       )..layout();

//   Rect _getChartRect(Size size) => Rect.fromLTRB(
//         usableSpacePadding.left,
//         usableSpacePadding.top,
//         size.width - usableSpacePadding.right,
//         size.height - usableSpacePadding.bottom,
//       );

//   Offset _getPointFromKey(double key, Size size) {
//     final chartRect = _getChartRect(size);

//     return Offset(
//       (key * chartRect.width) + chartRect.left,
//       chartRect.height - (rawData[key] * chartRect.height) + chartRect.top,
//     );
//   }

//   Offset _getPointFromOffset(Offset offset, Size size) {
//     final chartRect = _getChartRect(size);

//     return Offset(
//       (offset.dx * chartRect.width) + chartRect.left,
//       chartRect.height - (offset.dy * chartRect.height) + chartRect.top,
//     );
//   }

//   Offset _getPercent(Offset point, Size size) {
//     final chartRect = _getChartRect(size);

//     return Offset(
//       (point.dx - chartRect.left) / chartRect.width,
//       (point.dy - chartRect.top) / chartRect.height,
//     );
//   }

//   Offset _getTapPercentage(Size size) {
//     // Get percentage of touch in relation to usabe space
//     // And limit iit within space
//     final double tap = min(max(_getPercent(this.tap, size).dx, 0), 1);

//     // Array for closests neighbours
//     final List<double> neighbours = [];

//     // We need to get not closests points but neighbours
//     // If "x" is our touch and "o" are points
//     // o.o.x.......o
//     // Closests points are NOT neighbours
//     for (int i = 0; i < keys.length - 1; i++) {
//       final double key = keys[i], next = keys[i + 1];

//       // These are our neighbours
//       if (key <= tap && next >= tap) {
//         neighbours.addAll([key, next]);
//         break;
//       }
//     }

//     // Sum ting wong
//     if (neighbours.length == 0) return Offset.zero;

//     // Get percentage of touch beetwen them
//     final double percent = (tap - neighbours[0]) / (neighbours[1] - neighbours[0]);

//     // Return lerped offset
//     return Offset(
//       tap,
//       ui.lerpDouble(rawData[neighbours[0]], rawData[neighbours[1]], percent),
//     );
//   }

//   Rect _sizeAndCenterToRect(Size size, Offset center) => Rect.fromLTRB(
//         center.dx - (size.width / 2),
//         center.dy - (size.height / 2),
//         center.dx + (size.width / 2),
//         center.dy + (size.height / 2),
//       );

//   // Draws plot horzontal lines
//   void _drawHorizontalLines(Canvas canvas, Rect rect, List<double> positions) {
//     final Paint linePaint = Paint()
//       ..color = style.horizontalLinesStyle.color
//       ..strokeWidth = style.horizontalLinesStyle.width;

//     for (final double i in positions) {
//       final double l = rect.top + (rect.height * i);

//       canvas.drawLine(
//         Offset(rect.left, l),
//         Offset(rect.right, l),
//         linePaint,
//       );
//     }
//   }

//   // Draws plot vertical lines
//   void _drawVerticalLines(Canvas canvas, Rect rect, List<double> positions) {
//     final Paint linePaint = Paint()
//       ..color = style.verticalLinesStyle.color
//       ..strokeWidth = style.verticalLinesStyle.width;

//     for (final double i in positions) {
//       final double l = rect.left + (rect.width * i);

//       canvas.drawLine(
//         Offset(l, rect.top),
//         Offset(l, rect.bottom),
//         linePaint,
//       );
//     }
//   }

//   // Draws plot (vertical lins, horizontal lines, vertical axis and horizontal axis)
//   void _drawPlot(Canvas canvas, Size size) {
//     // Generate vertical and horizontal positons
//     final List<double> verticalPositions = List.generate(
//       style.verticalPointsCount,
//       (i) => 1 - (i / (style.verticalPointsCount - 1)),
//     );
//     final List<double> horizontalPositions = List.generate(
//       style.horizontalPointsCount,
//       (i) => i / (style.horizontalPointsCount - 1),
//     );

//     // Generate vertical and horizontal text painters
//     final List<TextPainter> verticalPainters = verticalPositions
//         .map(
//           (e) => _drawText(
//             getVerticalAxis(e),
//             style.verticalAxisTextStyle,
//           ),
//         )
//         .toList();
//     final List<TextPainter> horizontalPainters = horizontalPositions
//         .map(
//           (e) => _drawText(
//             getHorizontalAxis(e),
//             style.horizontalAxisTextStyle,
//           ),
//         )
//         .toList();

//     // Calculate usable space padding by finding largest text
//     usableSpacePadding = EdgeInsets.only(
//       top: verticalPainters.first.height / 2,
//       right: verticalPainters.last.width / 2,
//       bottom: horizontalPainters.fold(
//             0.0,
//             (acc, e) => max<double>(acc, e.height),
//           ) +
//           style.plotPadding.bottom,
//       left: verticalPainters.fold(
//             0.0,
//             (acc, e) => max<double>(acc, e.width),
//           ) +
//           style.plotPadding.left,
//     );

//     // Get usable space rect
//     final Rect rect = _getChartRect(size);

//     // Draw horizontal and vertical lines if needed
//     if (style.verticalLinesStyle.draw)
//       _drawVerticalLines(canvas, rect, horizontalPositions);
//     if (style.horizontalLinesStyle.draw)
//       _drawHorizontalLines(canvas, rect, verticalPositions);

//     for (final TextPainter painter in verticalPainters) {
//       final i = verticalPainters.indexOf(painter);

//       painter.paint(
//         canvas,
//         Offset(
//           rect.left - style.plotPadding.left,
//           rect.top + rect.height - (rect.height * verticalPositions[i]),
//         ).translate(-painter.width, painter.height / -2),
//       );
//     }

//     for (final TextPainter painter in horizontalPainters) {
//       final i = horizontalPainters.indexOf(painter);

//       painter.paint(
//         canvas,
//         Offset(
//           rect.left + rect.width * horizontalPositions[i],
//           rect.height + style.plotPadding.bottom,
//         ).translate(-painter.width / 2, painter.height / 2),
//       );
//     }
//   }

//   // Draws data line
//   void _drawChart(Canvas canvas, Size size) {
//     final Paint dataPaint = Paint()
//       ..color = style.dataLineStyle.color
//       ..strokeWidth = style.dataLineStyle.width
//       ..style = PaintingStyle.stroke;

//     final Path path = Path();

//     final start = _getPointFromKey(keys.first, size);
//     path.moveTo(start.dx, start.dy);

//     // Offset last = _getPointFromKey(keys.first, size);

//     for (final double key in keys.getRange(1, keys.length)) {
//       final Offset point = _getPointFromKey(key, size);
//       path.lineTo(point.dx, point.dy);
//       // canvas.drawLine(last, point, dataPaint);
//       // last = point;
//     }

//     canvas.drawPath(path, dataPaint);
//   }

//   // Draws onTap point
//   void _drawPoint(Canvas canvas, Size size, Offset point) {
//     // Convert percents to canvas coords
//     final Offset drawablePoint = _getPointFromOffset(point, size);

//     // Create painters
//     final outerPointPainter = new Paint()
//       ..color = style.dataLineStyle.color
//       ..strokeWidth = style.dataLineStyle.width
//       ..style = PaintingStyle.stroke;
//     final pointPainter = new Paint()
//       ..color = style.backgroundColor
//       ..style = PaintingStyle.fill;

//     // Draw circles
//     canvas.drawCircle(drawablePoint, 8, outerPointPainter);
//     canvas.drawCircle(drawablePoint, 4, outerPointPainter..strokeWidth = 1);
//     canvas.drawCircle(drawablePoint, 4, pointPainter);
//   }

//   // Draws onTap popup
//   void _drawPopup(Canvas canvas, Size size, Offset point) {
//     // Create rectangle painter
//     final rectanglePainter = new Paint()
//       ..color = style.popupStyle.color
//       ..style = PaintingStyle.fill;

//     // Get vertical painter
//     final TextPainter yPainter = _drawText(
//       getVerticalAxis(point.dy),
//       style.popupStyle.valueTextStyle,
//     );

//     // Get horizontal painter
//     final TextPainter xPainter = _drawText(
//       getHorizontalAxis(point.dx),
//       style.popupStyle.keyTextStyle,
//     );

//     // Calculate rect sizes
//     final Size textSize = Size(
//       max(yPainter.width, xPainter.width),
//       yPainter.height + style.popupStyle.textSpacing + xPainter.height,
//     );
//     final Size bgSize = style.popupStyle.size ??
//         Size(
//           textSize.width + style.popupStyle.padding.horizontal,
//           textSize.height + style.popupStyle.padding.vertical + 40,
//         );

//     // Convert percents to canvas coords
//     Offset drawablePoint = _getPointFromOffset(point, size).translate(
//       0,
//       -20 - (bgSize.height / 2),
//     );

//     // Check if popup is overflowing canvas
//     if (!allowPopupOverflow) {
//       if (drawablePoint.dy - (bgSize.height / 2) < 0)
//         drawablePoint = _getPointFromOffset(point, size).translate(
//           0,
//           20 + (bgSize.height / 2),
//         );
//       if (drawablePoint.dx - (bgSize.width / 2) < 0)
//         drawablePoint = drawablePoint.translate(
//           -drawablePoint.dx + (bgSize.width / 2),
//           0,
//         );
//       if (drawablePoint.dx + (bgSize.width / 2) > size.width)
//         drawablePoint = drawablePoint.translate(
//           size.width - drawablePoint.dx - (bgSize.width / 2),
//           0,
//         );
//     }

//     // Create rects
//     final Rect textRect = _sizeAndCenterToRect(textSize, drawablePoint);
//     final RRect bgRect = RRect.fromRectAndCorners(
//       _sizeAndCenterToRect(bgSize, drawablePoint),
//       topLeft: style.popupStyle.borderRadius.topLeft,
//       bottomLeft: style.popupStyle.borderRadius.bottomLeft,
//       bottomRight: style.popupStyle.borderRadius.bottomRight,
//       topRight: style.popupStyle.borderRadius.topRight,
//     );

//     // Create reactangle path and draw it
//     final Path rectangle = Path()..addRRect(bgRect);
//     canvas.drawShadow(
//       rectangle,
//       style.popupStyle.shadowColor,
//       style.popupStyle.elevation,
//       true,
//     );
//     canvas.drawPath(rectangle, rectanglePainter);

//     // Draw texts
//     yPainter.paint(
//       canvas,
//       textRect.topCenter.translate(yPainter.width / -2, 0),
//     );

//     xPainter.paint(
//       canvas,
//       textRect.bottomCenter.translate(xPainter.width / -2, -xPainter.height),
//     );
//   }

//   // Draws onTap popup and point
//   void _drawTap(Canvas canvas, Size size) {
//     // Get touch offset in percents of usable space
//     final Offset point = _getTapPercentage(size);

//     // Draw point and rectangle
//     (drawPoint ?? _drawPoint)(canvas, size, point);
//     (drawPopup ?? _drawPopup)(canvas, size, point);
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     _drawPlot(canvas, size);
//     _drawChart(canvas, size);

//     if (tap != null) _drawTap(canvas, size);
//   }

//   @override
//   bool shouldRepaint(covariant ChartPainter oldDelegate) {
// }
