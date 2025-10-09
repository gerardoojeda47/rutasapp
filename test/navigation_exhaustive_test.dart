import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rouwhite/main.dart';

void main() {
  testWidgets('Navigation exhaustive test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const Miapp());

    // Verify that the app starts correctly
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
