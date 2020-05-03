import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class DashboardWidget extends StatelessWidget {
  Map<String, double> dataMap = new Map();

  @override
  Widget build(BuildContext context) {
    dataMap.putIfAbsent("Flutter", () => 5);
    dataMap.putIfAbsent("React", () => 3);
    dataMap.putIfAbsent("Xamarin", () => 2);
    dataMap.putIfAbsent("Ionic", () => 2);

    return Center(
      child: PieChart(dataMap: dataMap),
    );
  }
}
