// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:genealogy_app/app.dart';

void main() {
  testWidgets('App builds without crashing smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(GenealogyApp());

    // Verify that our app renders by finding a specific widget (or at least no crash)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
