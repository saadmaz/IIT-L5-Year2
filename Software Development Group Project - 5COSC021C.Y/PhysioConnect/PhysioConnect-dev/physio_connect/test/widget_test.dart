import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fe/main.dart'; // Make sure 'fe' matches your pubspec.yaml project name

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build the PhysioConnect app and trigger a frame.
    await tester.pumpWidget(const PhysioConnectApp());

    // Verify that the counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the counter has incremented to 1.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}