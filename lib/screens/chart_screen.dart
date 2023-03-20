import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatelessWidget {
  final List<dynamic> stockData;

  ChartScreen({required this.stockData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Chart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryXAxis: NumericAxis(),
          primaryYAxis: NumericAxis(),
          series: <LineSeries<dynamic, num>>[
            LineSeries<dynamic, num>(
              dataSource: stockData.map((price) => {'y': price}).toList(),
              xValueMapper: (data, _) => data['x'],
              yValueMapper: (data, _) => data['y'],
            ),
          ],
        ),
      ),
    );
  }
}
