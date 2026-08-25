import 'package:challengemultiplication/features/history/models/history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HistoryEntry', () {
    test('serializes dates as ISO-8601', () {
      final date = DateTime(2026, 8, 25, 13, 5, 20);
      final entry = HistoryEntry(date: date, score: 14);

      final json = entry.toJson();

      expect(json['date'], date.toIso8601String());
      expect(json['score'], 14);
    });

    test('parses ISO-8601 dates and numeric scores from json', () {
      final entry = HistoryEntry.fromJson({
        'date': '2026-08-25T13:05:20.000',
        'score': '17',
      });

      expect(entry.date, DateTime(2026, 8, 25, 13, 5, 20));
      expect(entry.score, 17);
    });

    test('parses legacy date formats', () {
      final legacy24Hour = HistoryEntry.fromJson({
        'date': '2025-03-21 13:26',
        'score': 8,
      });
      final legacy12Hour = HistoryEntry.fromJson({
        'date': '2025-03-21 09:08',
        'score': 9,
      });

      expect(legacy24Hour.date, DateTime(2025, 3, 21, 13, 26));
      expect(legacy12Hour.date, DateTime(2025, 3, 21, 9, 8));
    });

    test('falls back safely for invalid dates and scores', () {
      final entry = HistoryEntry.fromJson({
        'date': 'not-a-date',
        'score': 'not-a-score',
      });

      expect(entry.date, DateTime.fromMillisecondsSinceEpoch(0));
      expect(entry.score, 0);
    });
  });
}
