import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:challengemultiplication/features/history/models/history_entry.dart';
import 'package:challengemultiplication/features/players/models/player.dart';

class HistoryViewModel extends ChangeNotifier {
  final PlayerService _playerService;
  Player? currentPlayer;
  List<HistoryEntry> history = [];

  HistoryViewModel(this._playerService);

  Future<void> loadPlayerHistory() async {
    final currentPlayerId = _playerService.currentPlayer?.id;

    if (currentPlayerId == null) {
      currentPlayer = null;
      history = [];
      notifyListeners();
      return;
    }

    final allPlayers = await _playerService.getPlayers();
    final matchingPlayers = allPlayers.where((p) => p.id == currentPlayerId);

    currentPlayer = matchingPlayers.isEmpty ? null : matchingPlayers.first;

    if (currentPlayer != null) {
      history = List.of(currentPlayer!.history);
      history.sort((a, b) => a.date.compareTo(b.date)); // Tri chrono
      _playerService.currentPlayer = currentPlayer;
    } else {
      history = [];
    }

    notifyListeners();
  }
}
