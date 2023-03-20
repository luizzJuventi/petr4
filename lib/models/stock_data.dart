
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';

class StockData {
  final double open;
  final double close;
  final String date;

  StockData(this.open, this.close, this.date);
}

class StockChart extends StatefulWidget {
  final String symbol;

  const StockChart({Key? key, required this.symbol, required List priceList}) : super(key: key);

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  List<StockData> _stockDataList = [];
  late String _errorMessage;

  Future<List<StockData>> _getStockData() async {
    var response = await http.get(
        Uri.parse(
            'https://query2.finance.yahoo.com/v8/finance/chart/${widget.symbol}?range=1mo&interval=1d'),
        headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var quoteData = data['chart']['result'][0]['indicators']['quote'][0];
      var openData = quoteData['open'];
      var closeData = quoteData['close'];
      var dateData = data['chart']['result'][0]['timestamp'];

      List<StockData> stockDataList = [];

      for (int i = 0; i < 30; i++) {
        double open = openData[i].toDouble();
        double close = closeData[i].toDouble();
        var date = DateTime.fromMillisecondsSinceEpoch(dateData[i] * 1000);
        String formattedDate = '${date.day}/${date.month}';
        StockData stockData = StockData(open, close, formattedDate);
        stockDataList.add(stockData);
      }
      return stockDataList.reversed.toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = '';
    _getStockData().then((data) {
      setState(() {
        _stockDataList = data;
      });
    }).catchError((error) {
      setState(() {
        _errorMessage = error.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    } else if (_stockDataList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        child: Column(
          children: [
            Expanded(
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: '${widget.symbol} Stock Price'),
                series: <ChartSeries<StockData, String>>[
                  LineSeries<StockData, String>(
                    dataSource: _stockDataList,
                    xValueMapper: (StockData stock, _) => stock.date,
                    yValueMapper: (StockData stock, _) => stock.open,
                    name: 'Open',
                  ),
                  LineSeries<StockData, String>(
                    dataSource: _stockDataList,
                    xValueMapper: (StockData stock, _) => stock.date,
                    yValueMapper: (StockData stock, _) => stock.close,
                    name: 'Close',
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'Rentability: ${(100 * ((_stockDataList.last.close - _stockDataList.first.open) / _stockDataList.first.open)).toStringAsFixed(2)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

 