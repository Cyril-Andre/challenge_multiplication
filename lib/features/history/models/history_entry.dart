import 'package:intl/intl.dart';

class HistoryEntry {
  final DateTime date;
  final int score;
  HistoryEntry({required this.date, required this.score});

  Map<String, dynamic> toJson() {
    return {
      "date": date.toIso8601String(),
      "score": score,
    };
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      score: json['score'] is int
          ? json['score']
          : int.tryParse(json['score'].toString()) ?? 0,
      date: _parseDate(json['date'].toString()),
    );
  }

  static DateTime _parseDate(String value) {
    final isoDate = DateTime.tryParse(value);
    if (isoDate != null) return isoDate;

    for (final format in [
      DateFormat("yyyy-MM-dd HH:mm"),
      DateFormat("yyyy-MM-dd hh:mm"),
    ]) {
      try {
        return format.parseStrict(value);
      } on FormatException {
        // Try the next legacy format.
      }
    }

    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}
