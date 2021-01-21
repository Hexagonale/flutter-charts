import 'package:flutter/material.dart';

import '../styles/singleLineChartStyle.dart';
import 'flutterChart.dart';

class AnimatedChart extends StatefulWidget {
  final Map<double, double> data;
  final Function(double) getHorizontalAxis;
  final Function(double) getVerticalAxis;
  final SingleLineChartStyle style;
  final bool allowPopupOverflow;
  final bool animatePopup;
  final bool animateData;
  final bool animateVerticalLines;
  final bool animateHorizontalLines;
  final bool animateDataChange;

  const AnimatedChart({
    Key key,
    @required this.data,
    @required this.getHorizontalAxis,
    @required this.getVerticalAxis,
    this.style = const SingleLineChartStyle(),
    this.allowPopupOverflow = false,
    this.animatePopup = true,
    this.animateData = true,
    this.animateVerticalLines = true,
    this.animateHorizontalLines = true,
    this.animateDataChange = true,
  }) : super(key: key);

  // TODO custom animated chart. Pass animations and controllers / callbacks
  // factory AnimatedChart.custom({
  //   Key key,
  //   @required data,
  //   @required getHorizontalAxis,
  //   @required getVerticalAxis,
  //   this.style = const SingleLineChartStyle(),
  //   this.allowPopupOverflow = false,
  //   this.animatePopup = true,
  //   this.animateData = true,
  //   this.animateVerticalLines = true,
  //   this.animateHorizontalLines = true,
  //   this.animateDataChange = true,
  // }) =>
  //     AnimatedChart(
  //       key: key,
  //       data: data,
  //       getHorizontalAxis: getHorizontalAxis,
  //       getVerticalAxis: getVerticalAxis,
  //     );

  @override
  _AnimatedChartState createState() => _AnimatedChartState();
}

class _AnimatedChartState extends State<AnimatedChart>
    with TickerProviderStateMixin {
  Map<double, double> data;
  AnimationController popupAnimationController;
  AnimationController dataIntroAnimationController;
  AnimationController horizontalLinesAnimationController;
  AnimationController verticalLinesAnimationController;
  Animation popupAnimation;
  Animation dataIntroAnimation;
  Animation horizontalLinesAnimation;
  Animation verticalLinesAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.animatePopup) _initPopupAnimation();
    if (widget.animateData) _initDataAnimation();
    if (widget.animateVerticalLines) _initHorizontalLinesAnimation();
    if (widget.animateHorizontalLines) _initVerticalLinesAnimation();
  }

  void _initPopupAnimation() {
    popupAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 225),
    );
    popupAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: popupAnimationController,
    );

    popupAnimation.addListener(() => setState(() {}));
  }

  void _initDataAnimation() {
    dataIntroAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    dataIntroAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: dataIntroAnimationController,
    );

    dataIntroAnimation.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => dataIntroAnimationController.forward(),
    );
  }

  void _initHorizontalLinesAnimation() {
    horizontalLinesAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    horizontalLinesAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: horizontalLinesAnimationController,
    );

    horizontalLinesAnimation.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => horizontalLinesAnimationController.forward(),
    );
  }

  void _initVerticalLinesAnimation() {
    verticalLinesAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    verticalLinesAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: verticalLinesAnimationController,
    );

    verticalLinesAnimation.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => verticalLinesAnimationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animateDataChange && data != widget.data) {
      dataIntroAnimationController.forward(from: 0);
      data = widget.data;
    }

    return FlutterChart(
      data: widget.data,
      style: widget.style,
      getHorizontalAxis: widget.getHorizontalAxis,
      getVerticalAxis: widget.getVerticalAxis,
      allowPopupOverflow: widget.allowPopupOverflow,
      popup: popupAnimationController.value,
      showPopup: () => popupAnimationController.forward(),
      hidePopup: () => popupAnimationController.reverse(),
      dataDrawProgress: dataIntroAnimation.value,
      horizontalLinesDrawProgress: horizontalLinesAnimation.value,
      verticalLinesDrawProgress: verticalLinesAnimation.value,
    );
  }
}
