import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riatlas_task/main.dart';

void main() {
  testWidgets('RiAtlasTaskApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const RiAtlasTaskApp());
    await tester.pumpAndSettle();

    final welcomeFinder = find.textContaining('Marhaba');
    final homeFinder = find.textContaining('Home');

    expect(
      welcomeFinder.evaluate().isNotEmpty || homeFinder.evaluate().isNotEmpty,
      isTrue,
      reason: 'App should render either WelcomeScreen or MainScreen',
    );
  });

  testWidgets('App has correct title and theme', (WidgetTester tester) async {
    await tester.pumpWidget(const RiAtlasTaskApp());
    await tester.pumpAndSettle();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.title, equals('RiAtlas Task'));
    expect(materialApp.debugShowCheckedModeBanner, isFalse);
  });
}
