import 'dart:math';

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

class _HomeState extends State<Home> {
  double value = 0.5;
  int length = 200;
  Map<double, double> data = Map();

  @override
  void initState() {
    super.initState();
    data = getData();
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
            child: Chart(value: value, data: data),
          ),
          Slider(onChanged: (v) => setState(() => value = v), value: value),
          Row(
            children: [
              Expanded(child: Slider(onChanged: (v) => setState(() => length = v.round()), value: length.toDouble(), min: 1, max: 8000)),
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
