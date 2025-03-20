import 'package:challenge_multiplication/features/history/viewmodels/history_viewmodel.dart';
import 'package:challenge_multiplication/features/history/widget/score_card.dart';
import 'package:challenge_multiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HistoryViewModel(
        Provider.of<PlayerService>(context, listen: false),
      )..loadPlayerHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Historique des scores"),
        ),
        body: Consumer<HistoryViewModel>(
          builder: (context, viewModel, child) {
            Widget content;

            if (viewModel.currentPlayer == null) {
              content = const Center(child: Text("Aucun joueur sélectionné"));
            } else if (viewModel.history.isEmpty) {
              content = const Center(child: Text("Aucun historique disponible"));
            } else {
              content = ScoreChart(entries: viewModel.history);
            }

            return Column(
              children: [
                Expanded(child: content),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      context.go("/");
                    },
                    child: const Text("Retour à l'accueil"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}