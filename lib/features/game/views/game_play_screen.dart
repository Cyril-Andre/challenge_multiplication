import 'package:challenge_multiplication/common/widgets/app_scaffold.dart';
import 'package:challenge_multiplication/features/game/models/multiplication.dart';
import 'package:challenge_multiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class GamePlayScreen extends StatelessWidget {
  const GamePlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GamePlayViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.timeRemaining == 60) {
          // Vérifier que le timer n'a pas déjà démarré
          viewModel.startTimer();
        }

        if (viewModel.timeRemaining == 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go("/game_result");
          });
        }

        return AppScaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(value: viewModel.timeRemaining / 60, strokeWidth: 8, color: Colors.blue, backgroundColor: Colors.grey[300]),
                    ),
                    Text('${viewModel.timeRemaining}s', style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: viewModel.multiplications.map((multiplication) {
                      int index = viewModel.multiplications.indexOf(multiplication);
                      return buildMultiplicationCard(context, viewModel, multiplication, index);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMultiplicationCard(BuildContext context, GamePlayViewModel viewModel, Multiplication multiplication, int index) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4, // Adaptatif selon la largeur de l'écran
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceVariant, // Adapte au thème
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${multiplication.a} × ${multiplication.b} = ',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Container(
            width: 50,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              cursorHeight: 20,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) => viewModel.setAnswer(index, value),
              enabled: viewModel.timeRemaining > 0,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
