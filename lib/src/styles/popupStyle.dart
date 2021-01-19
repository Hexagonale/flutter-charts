import 'package:flutter/material.dart';

class PopupStyle {
  final Color color, shadowColor;
  final double elevation;
  final EdgeInsets padding;
  final Size size;
  final TextStyle keyTextStyle, valueTextStyle;
  final BorderRadius borderRadius;
  final double textSpacing;

  // TODO reconsider design - maybe it's better to use polymorphism for size and padding?
  const PopupStyle({
    this.color = const Color(0xffffffff),
    this.shadowColor = const Color(0x67000000),
    this.elevation = 1.5,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 10,
    ),
    this.size,
    this.keyTextStyle = const TextStyle(
      color: const Color(0xff858b9f),
      fontSize: 10,
    ),
    this.valueTextStyle = const TextStyle(
      color: const Color(0xff858b9f),
      fontSize: 12,
    ),
    this.borderRadius = const BorderRadius.all(const Radius.circular(5)),
    this.textSpacing = 4,
  });
}
