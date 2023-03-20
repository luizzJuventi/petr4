import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petr4/main.dart';
import 'package:petr4/screens/chart_screen.dart';

void main() {
  testWidgets('Stock screen should display a chart', (WidgetTester tester) async {
    await tester.pumpWidget(Petr4App());
    
    // Tap the button to navigate to the stock screen
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that the stock screen contains a chart
    expect(find.byType(LineChart), findsOneWidget);
  });
}
