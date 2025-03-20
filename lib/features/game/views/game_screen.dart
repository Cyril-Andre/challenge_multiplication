import 'package:challenge_multiplication/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:challenge_multiplication/features/game/viewmodels/game_viewmodel.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  void showCountdownDialog(BuildContext context) {
    final gameViewModel = Provider.of<GameViewModel>(context, listen: false);
    gameViewModel.startCountdown(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && context.canPop()) {
          context.pop();
        }
        GoRouter.of(context).refresh();
        Future.microtask(() {
          if (context.mounted) {
            context.go("/game_play");
          }
        });
      });
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: gameViewModel,
          child: Consumer<GameViewModel>(
            builder: (context, viewModel, child) {
              return AlertDialog(
                title: const Text('Prépare-toi !'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Concentre-toi, le challenge va commencer', textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Text('${viewModel.countdown}', style: Theme.of(context).textTheme.displayLarge),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Réponds aux multiplications le plus vite possible !', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          SizedBox(width: 200, child: ElevatedButton(onPressed: () => showCountdownDialog(context), child: const Text('Commencer'))),
          const SizedBox(height: 10),
          SizedBox(width: 200, child: OutlinedButton(onPressed: () => context.go('/'), child: const Text("Retour à l'accueil"))),
        ],
      ),
    );
  }
}
