import 'package:challengemultiplication/common/globals.dart';
import 'package:challengemultiplication/features/settings/models/player_settings.dart';
import 'package:flutter/material.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final PlayerService playerService;
  late PlayerSettings settings;

  SettingsViewModel({required this.playerService}) {
    final player = playerService.currentPlayer!;
    settings = PlayerSettings.fromMap(player.settings);
  }

  int get timelimit => settings.timelimit;
  int get difficulty => settings.difficulty;

  void setTimelimit(int value) {
    settings = PlayerSettings(
      timelimit: value,
      difficulty: settings.difficulty,
    );
    notifyListeners();
  }

  void setDifficulty(int value) {
    settings = PlayerSettings(
      timelimit: settings.timelimit,
      difficulty: value,
    );
    notifyListeners();
  }

  Future<void> saveSettings() async {
    final currentPlayer = playerService.currentPlayer!;
    currentPlayer.settings = settings.toMap();

    final players = await playerService.getPlayers();
    final index = players.indexWhere((p) => p.id == currentPlayer.id);
    if (index != -1) {
      players[index] = currentPlayer;
      await playerService.savePlayers(players);
    }
    Globals.difficulty = settings.difficulty;
    Globals.timeLimit = settings.timelimit;
  }
}
