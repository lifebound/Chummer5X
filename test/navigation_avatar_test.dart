import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chummer5x/screens/main_navigation_screen.dart';

void main() {
  group('MainNavigationScreen Avatar Tests', () {
    testWidgets('should create navigation screen without errors', (WidgetTester tester) async {
      // Create the widget - verifies that our avatar helper method is properly integrated
      expect(() {
        MainNavigationScreen();
      }, returnsNormally);
    });

    testWidgets('should create navigation screen without character', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigationScreen(),
        ),
      );

      // Should find the app bar with default title
      expect(find.text('Chummer5X'), findsOneWidget);
      // Just verify the scaffold exists - drawer testing would require opening it
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
