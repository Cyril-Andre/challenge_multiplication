import 'package:challenge_multiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/player.dart';
import '../views/player_auth_screen.dart';

class PlayerSelectionViewModel extends ChangeNotifier {
  final PlayerService _playerService;
  List<Player> _players = [];

  List<Player> get players => _players;

  Player? _selectedPlayer;
  Player? get selectedPlayer => _selectedPlayer;

  PlayerSelectionViewModel(this._playerService) {
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    _players = await _playerService.getPlayers();
    notifyListeners();
  }

  void selectPlayer(Player player, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // si tu veux un bottomsheet plein écran
      builder:
          (context) => PlayerAuthScreen(
            playerName: player.name,
            correctPin: player.pin,
            onSuccess: () {
              context.pop(); // Ferme le bottomsheet
              _selectedPlayer = player;
              _loadPlayerData(player, context);
              _playerService.currentPlayer = player;
            },
          ),
    );
  }

  void _loadPlayerData(Player player, BuildContext context) {
    // Ici, nous pouvons charger les settings et l'historique du joueur
    context.go("/", extra: player);
  }
}
