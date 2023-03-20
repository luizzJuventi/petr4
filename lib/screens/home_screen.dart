
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:petr4/models/stock_data.dart';
import 'package:petr4/screens/chart_screen.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  late Map<String, dynamic> _stockData;
  late List<dynamic> _priceList;

  void _openNativeView() async {
    // platform method channel
    const platform = const MethodChannel('com.example.flutter_app/nativeView');

    try {
      await platform.invokeMethod('openMyCustomScreen');
    } on PlatformException catch (e) {
      print("Failed to open native view: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchStockData();
  }

  Future<void> _fetchStockData() async {
    setState(() {
      _isLoading = true;
    });

    final url =
        'https://query2.finance.yahoo.com/v8/finance/chart/PETR4.SA?range=1mo&interval=1d';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _stockData = data['chart']['result'][0];
        _priceList = _stockData['indicators']['quote'][0]['open'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  double _calculateProfitability() {
    final double openingPrice = _priceList.last.toDouble();
    final double closingPrice = _priceList.first.toDouble();
    return ((closingPrice - openingPrice) / openingPrice) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock App'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'PETR4.SA',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    '${_calculateProfitability().toStringAsFixed(2)}%',
                    style: TextStyle(
                      fontSize: 18,
                      color: _calculateProfitability() >= 0
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                     child: StockChart(priceList: _priceList, symbol: 'PETR4.SA'),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    onPressed: _openNativeView, // call platform method channel to open MyCustomScreen
                    child: Text('Open My Custom Screen'),
                  ),
                ),
              ],
            ),
    );
  }
}

