class PlayerSettings {
  final int timelimit;
  final int difficulty;

  PlayerSettings({required this.timelimit, required this.difficulty});

  factory PlayerSettings.defaults() {
    return PlayerSettings(
      timelimit: 60,
      difficulty: 1,
    );
  }

  factory PlayerSettings.fromMap(Map<String, dynamic> map) {
    final defaults = PlayerSettings.defaults();

    return PlayerSettings(
        timelimit: map['timelimit'] ?? defaults.timelimit,
        difficulty: map['difficulty'] ?? defaults.difficulty);
  }

  Map<String, dynamic> toMap() {
    return {'timelimit': timelimit, 'difficulty': difficulty};
  }
}
