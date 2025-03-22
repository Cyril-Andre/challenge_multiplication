import 'package:intl/intl.dart';

class HistoryEntry {
  final DateTime date;
  final int score;
  HistoryEntry({required this.date, required this.score});

  Map<String, dynamic> toJson() {
    return {
      "date": DateFormat("yyyy-MM-dd hh:mm").format( date),
      "score":score
    };
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      score: json['score'],
      date: DateFormat("yyyy-MM-dd hh:mm").parse(json['date'])
    );
  }
}
