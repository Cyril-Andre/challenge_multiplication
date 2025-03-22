import 'package:challengemultiplication/features/history/models/history_entry.dart';

class Player {
  final String id;
  final String name;
  final String pin;
  Map<String, dynamic> settings; // Contiendra les réglages futurs
  List<HistoryEntry> history;

  Player({
    required this.id,
    required this.name,
    required this.pin,
    required this.settings,
    required this.history,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      pin: json['pin'],
      settings: json['settings'] ?? {},
      history: (json['history'] as List?)?.map((e) => HistoryEntry.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pin': pin,
      'settings': settings,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }
}
