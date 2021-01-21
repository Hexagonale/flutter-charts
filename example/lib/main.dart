import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  double value = 0.5;
  int length = 200;
  Map<double, double> data = Map();
  Animation popupAnimation;
  Animation dataIntroAnimation;
  AnimationController popupAnimationController;
  AnimationController dataIntroAnimationController;

  @override
  void initState() {
    super.initState();
    data = getData();
    popupAnimationController = AnimationController(
      duration: Duration(milliseconds: 750),
      vsync: this,
    );
    popupAnimation = CurvedAnimation(
      curve: Curves.easeInCirc,
      parent: popupAnimationController,
    );

    dataIntroAnimationController = AnimationController(
      duration: Duration(milliseconds: 1750),
      vsync: this,
    );
    dataIntroAnimation = CurvedAnimation(
      curve: Curves.easeInCirc,
      parent: dataIntroAnimationController,
    );
  }

  Map<double, double> getData() {
    final Random r = Random();

    List<double> values = List.generate(
      length, //lerpDouble(100, 1000, widget.value).round(),
      (i) => sin(i / 13) * r.nextDouble() / 2 + 0.5,
    ).toList();

    Map<double, double> data = Map();

    for (final double v in values)
      data.putIfAbsent(values.indexOf(v) / (values.length - 1), () => v);

    return data;
  }

  void regenerate() {
    data = getData();

    setState(() {});
  }

  String getHorizontalAxis(double percent) {
    final DateTime target = DateTime.now()
        .add(lerpDuration(Duration(hours: -3), Duration.zero, percent));

    return '${target.hour.toString().padLeft(2, '0')}:${target.minute.toString().padLeft(2, '0')}';
  }

  String getVerticalAxis(double percent) =>
      '${((percent * 100 * 100).round() / 100)}%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 350,
            padding: const EdgeInsets.all(16),
            child: Container(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
                child: Chart.smooth(
                  data: data,
                  getHorizontalAxis: getHorizontalAxis,
                  getVerticalAxis: getVerticalAxis,
                  smoothing: SmoothingType.Linear,
                  smoothness: value,
                ),
              ),
            ),
          ),
          Slider(onChanged: (v) => setState(() => value = v), value: value),
          Row(
            children: [
              Expanded(
                  child: Slider(
                      onChanged: (v) => setState(() => length = v.round()),
                      value: length.toDouble(),
                      min: 1,
                      max: 8000)),
              Text('$length'),
            ],
          ),
          FlatButton(
            child: Text('regenerate'),
            onPressed: regenerate,
          ),
        ],
      ),
    );
  }
}
