import 'dart:async';

import 'package:challengemultiplication/common/widgets/app_scaffold.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challengemultiplication/features/history/models/history_entry.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/viewmodels/player_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GameResultScreen extends StatefulWidget {
  const GameResultScreen({super.key});

  @override
  State<GameResultScreen> createState() => _GameResultScreenState();
}

class _GameResultScreenState extends State<GameResultScreen> {
  bool _historySaved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_historySaved) return;

    final gamePlayViewModel = context.read<GamePlayViewModel>();
    final playerSelectionViewModel = context.read<PlayerSelectionViewModel>();
    final playerService = context.read<PlayerService>();
    final player =
        playerSelectionViewModel.selectedPlayer ?? playerService.currentPlayer;

    if (player == null || gamePlayViewModel.totalQuestions == 0) return;

    _historySaved = true;
    final score = gamePlayViewModel.ensureFinalScore();

    unawaited(
      playerService.updatePlayerHistory(
        player,
        HistoryEntry(date: DateTime.now(), score: score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<GamePlayViewModel, PlayerSelectionViewModel,
        PlayerService>(
      builder:
          (context, viewModel, playerSelectionViewModel, playerService, child) {
        final player = playerSelectionViewModel.selectedPlayer ??
            playerService.currentPlayer;
        final int totalQuestions = viewModel.totalQuestions;

        if (player == null) {
          return _buildEmptyResult(
            context,
            message: 'Aucun joueur sélectionné',
          );
        }

        if (totalQuestions == 0) {
          return _buildEmptyResult(
            context,
            message: 'Aucun résultat disponible',
          );
        }

        final int score = viewModel.ensureFinalScore();

        final sortedEntries = viewModel.errors.entries.toList();
        sortedEntries.sort((a, b) => a.key.compareTo(b.key));
        return AppScaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Résultat du Challenge',
                  style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              Text('Tu as obtenu un score de',
                  style: Theme.of(context).textTheme.headlineSmall),
              Text('$score / $totalQuestions',
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 30),
              Text("Erreurs sur les tables:"),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                children: sortedEntries
                    .map(
                      (entry) => Container(
                        padding: EdgeInsets.all(3),
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: entry.value > 1 ? Colors.red : null,
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text('${entry.key} : ${entry.value}'),
                      ),
                    )
                    .toList(), // Important ici
              ),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      key: Key("Rejouer"),
                      onPressed: () => context.go('/game'),
                      child: const Text('Rejouer'))),
              const SizedBox(height: 10),
              SizedBox(
                  width: 200,
                  child: OutlinedButton(
                      key: Key("Historique"),
                      onPressed: () => context.go('/history'),
                      child: const Text("Voir l'historique"))),
              SizedBox(
                  width: 200,
                  child: OutlinedButton(
                      key: Key("Home"),
                      onPressed: () => context.go('/'),
                      child: const Text("Retour à l'accueil"))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyResult(BuildContext context, {required String message}) {
    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              key: Key("Home"),
              onPressed: () => context.go('/'),
              child: const Text("Retour à l'accueil"),
            ),
          ),
        ],
      ),
    );
  }
}
