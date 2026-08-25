import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/player.dart';
import '../views/player_auth_screen.dart';

class PlayerSelectionViewModel extends ChangeNotifier {
  final PlayerService _playerService;
  List<Player> _players = [];

  List<Player> get players => _players;

  PlayerSelectionViewModel(this._playerService) {
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    _players = await _playerService.getPlayers();
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadPlayers();
  }

  void selectPlayer(Player player, BuildContext context) {
    final parentContext = context;

    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true, // si tu veux un bottomsheet plein écran
      builder: (sheetContext) => PlayerAuthScreen(
        playerName: player.name,
        correctPin: player.pin,
        onSuccess: () {
          sheetContext.pop(); // Ferme le bottomsheet
          _playerService.currentPlayer = player;

          if (parentContext.mounted) {
            parentContext.go("/");
          }
        },
      ),
    );
  }
}
