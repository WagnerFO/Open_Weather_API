import 'package:flutter/material.dart';
import 'package:flutter_application/presentation/widgets/app_bar_menu.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppBarMenu renders its title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(appBar: AppBarMenu(title: 'Alertas')),
      ),
    );

    expect(find.text('Alertas'), findsOneWidget);
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}
