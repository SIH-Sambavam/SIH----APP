// This is a basic Flutter widget test for BlueGuard app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:blueguard_app/main.dart';

void main() {
  testWidgets('BlueGuard app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BlueGuardApp());

    // Verify that our app loads with the BlueGuard Dashboard title
    expect(find.text('BlueGuard Dashboard'), findsOneWidget);

    // Verify that the dashboard screen loads with welcome message
    expect(find.text('Welcome, Marine Guardian!'), findsOneWidget);

    // Verify navigation bar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}
