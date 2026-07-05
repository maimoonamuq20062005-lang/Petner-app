import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petnerapp/main.dart';

void main() {
  testWidgets('PETNER app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PetnerApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
