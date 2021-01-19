import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../styles/chartStyle.dart';

//TODO _getChartRect save state as it's immutable after setting usableSpacePadding
abstract class ChartPainter extends CustomPainter {
  final ChartStyle style;
  final Function(double) getVerticalAxis, getHorizontalAxis;
  final Offset tap;
  final bool allowPopupOverflow;

  EdgeInsets usableSpacePadding = const EdgeInsets.all(0);

  ChartPainter({
    @required this.style,
    @required this.getVerticalAxis,
    @required this.getHorizontalAxis,
    @required this.allowPopupOverflow,
    @required this.tap,
  });

  // Draws horzontal plot lines
  void _drawHorizontalLines(Canvas canvas, Rect rect, List<double> positions) {
    final Paint linePaint = Paint()
      ..color = style.horizontalLinesStyle.color
      ..strokeWidth = style.horizontalLinesStyle.width;

    for (final double i in positions) {
      final double l = rect.top + (rect.height * i);

      canvas.drawLine(
        Offset(rect.left, l),
        Offset(rect.right, l),
        linePaint,
      );
    }
  }

  // Draws vertical plot lines
  void _drawVerticalLines(Canvas canvas, Rect rect, List<double> positions) {
    final Paint linePaint = Paint()
      ..color = style.verticalLinesStyle.color
      ..strokeWidth = style.verticalLinesStyle.width;

    for (final double i in positions) {
      final double l = rect.left + (rect.width * i);

      canvas.drawLine(
        Offset(l, rect.top),
        Offset(l, rect.bottom),
        linePaint,
      );
    }
  }

  // Draws plot (vertical lins, horizontal lines, vertical axis and horizontal axis)
  void _drawPlot(Canvas canvas, Size size) {
    // Generate vertical and horizontal positons
    final List<double> verticalPositions = List.generate(
      style.verticalPointsCount,
      (i) => 1 - (i / (style.verticalPointsCount - 1)),
    );
    final List<double> horizontalPositions = List.generate(
      style.horizontalPointsCount,
      (i) => i / (style.horizontalPointsCount - 1),
    );

    // Generate vertical and horizontal text painters
    final List<TextPainter> verticalPainters = verticalPositions
        .map(
          (e) => drawText(
            getVerticalAxis(e),
            style.verticalAxisTextStyle,
          ),
        )
        .toList();
    final List<TextPainter> horizontalPainters = horizontalPositions
        .map(
          (e) => drawText(
            getHorizontalAxis(e),
            style.horizontalAxisTextStyle,
          ),
        )
        .toList();

    // Calculate usable space padding by finding largest text
    usableSpacePadding = EdgeInsets.only(
      top: verticalPainters.first.height / 2,
      right: verticalPainters.last.width / 2,
      bottom: horizontalPainters.fold(
            0.0,
            (acc, e) => max<double>(acc, e.height),
          ) +
          style.plotPadding.bottom,
      left: verticalPainters.fold(
            0.0,
            (acc, e) => max<double>(acc, e.width),
          ) +
          style.plotPadding.left,
    );

    // Get usable space rect
    final Rect rect = getChartRect(size);

    // Draw horizontal and vertical lines if needed
    if (style.verticalLinesStyle.draw)
      _drawVerticalLines(canvas, rect, horizontalPositions);
    if (style.horizontalLinesStyle.draw)
      _drawHorizontalLines(canvas, rect, verticalPositions);

    for (final TextPainter painter in verticalPainters) {
      final i = verticalPainters.indexOf(painter);

      painter.paint(
        canvas,
        Offset(
          rect.left - style.plotPadding.left,
          rect.top + rect.height - (rect.height * verticalPositions[i]),
        ).translate(-painter.width, painter.height / -2),
      );
    }

    for (final TextPainter painter in horizontalPainters) {
      final i = horizontalPainters.indexOf(painter);

      painter.paint(
        canvas,
        Offset(
          rect.left + rect.width * horizontalPositions[i],
          rect.height + style.plotPadding.bottom,
        ).translate(-painter.width / 2, painter.height / 2),
      );
    }
  }

  TextPainter drawText(String text, TextStyle style) => TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: ui.TextDirection.rtl,
      )..layout();

  Rect getChartRect(Size size) => Rect.fromLTRB(
        usableSpacePadding.left,
        usableSpacePadding.top,
        size.width - usableSpacePadding.right,
        size.height - usableSpacePadding.bottom,
      );

  // Draws data line
  void drawChart(Canvas canvas, Size size);

  // Draws onTap popup and point
  void drawTap(Canvas canvas, Size size);

  @override
  void paint(Canvas canvas, Size size) {
    try {
    _drawPlot(canvas, size);
    drawChart(canvas, size);

    if (tap != null) drawTap(canvas, size);
    } catch(e, st) {
      print(e);
      print(st);
    }
  }

  @override
  bool shouldRepaint(covariant ChartPainter oldDelegate) {
    // TODO implement some basic field checking for optimization
    return true;
  }
}
