import 'package:challengemultiplication/common/widgets/animated_time_icon.dart';
import 'package:challengemultiplication/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsFormWidget extends StatelessWidget {
  const SettingsFormWidget({super.key});

  final Map<int, String> difficultyLabels = const {
    1: 'Amateur',
    2: 'Ligue 1',
    3: 'Ligue des champions',
  };

  final Map<int, IconData> difficultyIcons = const {
    1: Icons.military_tech,
    2: Icons.emoji_events,
    3: Icons.star,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            // TEMPS LIMITE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    AnimatedTimerIcon(),
                    SizedBox(width: 8),
                    Text('Temps limite :'),
                  ],
                ),
                Text('${viewModel.timelimit} sec'),
              ],
            ),
            Slider(
              min: 60,
              max: 120,
              divisions: 2,
              label: '${viewModel.timelimit} secondes',
              value: viewModel.timelimit.toDouble(),
              onChanged: (value) {
                viewModel.setTimelimit(value.toInt());
              },
            ),
            const SizedBox(height: 24),

            // DIFFICULTÉ
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(difficultyIcons[viewModel.difficulty]!),
                    const SizedBox(width: 8),
                    const Text('Difficulté :'),
                  ],
                ),
                DropdownButton<int>(
                  value: viewModel.difficulty,
                  items: difficultyLabels.entries
                      .map((e) => DropdownMenuItem<int>(
                            value: e.key,
                            child: Text(e.value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) viewModel.setDifficulty(value);
                  },
                ),
              ],
            ),
            const Spacer(),

            // BOUTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.cancel),
                  label: const Text('Annuler'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await viewModel.saveSettings();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Paramètres sauvegardés !')),
                      );
                      context.pop();
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Sauvegarder'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
