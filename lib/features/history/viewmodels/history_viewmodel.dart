import 'package:challenge_multiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:challenge_multiplication/features/history/models/history_entry.dart';
import 'package:challenge_multiplication/features/players/models/player.dart';

class HistoryViewModel extends ChangeNotifier {
  final PlayerService _playerService;
  Player? currentPlayer;
  List<HistoryEntry> history = [];

  HistoryViewModel(this._playerService);

  Future<void> loadPlayerHistory() async {
    var allPlayers = await _playerService.getPlayers();
    currentPlayer = allPlayers.firstWhere((p) => p.name == _playerService.currentPlayer?.name);
    if (currentPlayer != null) {
      history = currentPlayer!.history;
      history.sort((a, b) => a.date.compareTo(b.date)); // Tri chrono
    }
    notifyListeners();
  }
}
