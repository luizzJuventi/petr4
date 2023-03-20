import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:petr4/screens/home_screen.dart';
import 'package:petr4/models/stock_data.dart';

class MockStockData extends Mock implements StockData {}

void main() {
  testWidgets('HomeScreen displays stock data', (WidgetTester tester) async {
    // Create a mock StockData object
    final mockStockData = MockStockData();

    // Create a mock stock price to be returned by the mock StockData object
    final stockPrice = 42.0;

    // Set up the mock to return the mock stock price when getStockPrice is called
    when(mockStockData.getStockPrice()).thenAnswer((_) async => stockPrice);

    // Create a MaterialApp containing a HomeScreen that depends on the mock StockData object
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(stockData: mockStockData),
      ),
    );

    // Verify that the HomeScreen displays the mock stock price
    expect(find.text('$stockPrice'), findsOneWidget);
  });

  testWidgets('HomeScreen displays error message when stock price cannot be fetched', (WidgetTester tester) async {
    // Create a mock StockData object
    final mockStockData = MockStockData();

    // Set up the mock to throw an exception when getStockPrice is called
    when(mockStockData.getStockPrice()).thenThrow(Exception('Failed to fetch stock price'));

    // Create a MaterialApp containing a HomeScreen that depends on the mock StockData object
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(stockData: mockStockData),
      ),
    );

    // Verify that the HomeScreen displays an error message
    expect(find.text('Failed to fetch stock price'), findsOneWidget);
  });
}
