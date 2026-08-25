import 'package:challengemultiplication/features/history/models/history_entry.dart';
import 'package:challengemultiplication/features/history/widget/score_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a score chart from history entries', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScoreChart(
            entries: [
              HistoryEntry(date: DateTime(2026, 8, 24), score: 8),
              HistoryEntry(date: DateTime(2026, 8, 25), score: 15),
            ],
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(LineChart), findsOneWidget);
  });
}
