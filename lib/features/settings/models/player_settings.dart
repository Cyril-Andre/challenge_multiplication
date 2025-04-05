class PlayerSettings {
  final int timelimit;
  final int difficulty;
  
  PlayerSettings({
    required this.timelimit,
    required this.difficulty
  });

  factory PlayerSettings.fromMap(Map<String, dynamic> map) {
    return PlayerSettings(
      timelimit: map['timelimit'] ?? 60,
      difficulty: map['difficulty'] ?? 1
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timelimit': timelimit,
      'difficulty': difficulty
    };
  }
}
