import 'package:challengemultiplication/common/widgets/app_scaffold.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:challengemultiplication/features/settings/widgets/settings_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerService = context.read<PlayerService>();

    if (playerService.currentPlayer == null) {
      return AppScaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aucun joueur sélectionné',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/player_selection'),
              child: const Text('Choisir un joueur'),
            ),
          ],
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => SettingsViewModel(playerService: playerService),
      child: const AppScaffold(
        body: SettingsFormWidget(),
      ),
    );
  }
}
