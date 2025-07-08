// This is a basic Flutter widget test for Chummer5X.

import 'package:flutter_test/flutter_test.dart';

import 'package:chummer5x/main.dart';

void main() {
  testWidgets('App loads home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Chummer5XApp());

    // Verify that our app title is displayed.
    expect(find.text('Chummer5X'), findsOneWidget);
    expect(find.text('Welcome to Chummer5X'), findsOneWidget);
    expect(find.text('Load Character File'), findsOneWidget);
  });
}
