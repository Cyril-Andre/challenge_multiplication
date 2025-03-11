import 'package:challenge_multiplication/common/widgets/app_scaffold.dart';
import 'package:challenge_multiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GameResultScreen extends StatelessWidget {
  const GameResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayViewModel>(
      builder: (context, viewModel, child) {
        final int score = viewModel.finalScore ?? 0;
        return AppScaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Résultat du Challenge', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),
              Text('Tu as obtenu un score de', style: Theme.of(context).textTheme.headlineSmall),
              Text('$score / 20', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 30),
              SizedBox(width: 200, child: ElevatedButton(onPressed: () => context.go('/game'), child: const Text('Rejouer'))),
              const SizedBox(height: 10),
              SizedBox(width: 200, child: OutlinedButton(onPressed: () => context.go('/history'), child: const Text("Voir l'historique"))),
              SizedBox(width: 200, child: OutlinedButton(onPressed: () => context.go('/'), child: const Text("Retour à l'accueil"))),
            ],
          ),
        );
      },
    );
  }
}
