import 'dart:convert';
import 'package:challenge_multiplication/features/history/models/history_entry.dart';
import 'package:challenge_multiplication/features/players/models/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerService {
  static const String _playersKey = 'players';
  Player? currentPlayer;

  Future<List<Player>> getPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = prefs.getString(_playersKey);
    if (playersJson != null) {
      List<dynamic> decoded = jsonDecode(playersJson);
      return decoded.map((e) => Player.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> savePlayers(List<Player> players) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_playersKey, jsonEncode(players.map((e) => e.toJson()).toList()));
  }

  Future<void> updatePlayerHistory(Player player, HistoryEntry historyEntry) async {
    List<Player> allPlayers = await getPlayers();
    allPlayers.firstWhere((p) => p.name == player.name).history.add(historyEntry);
    savePlayers(allPlayers);
  }

  Future<void> addPlayer(Player player) async {
    List<Player> players = await getPlayers();
    players.add(player);
    await savePlayers(players);
  }
}
