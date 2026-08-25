import 'package:challengemultiplication/common/widgets/animated_time_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the animated timer icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AnimatedTimerIcon(),
        ),
      ),
    );

    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
  });
}
