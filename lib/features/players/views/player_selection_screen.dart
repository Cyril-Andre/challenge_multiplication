import 'package:challengemultiplication/common/widgets/app_scaffold.dart';
import 'package:challengemultiplication/features/players/viewmodels/player_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/player_card.dart';

class PlayerSelectionScreen extends StatelessWidget {
  const PlayerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PlayerSelectionViewModel>(context, listen: false);

    // Déclencher le refresh sans StatefulWidget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.refresh();
    });

    return AppScaffold(
      body: Consumer<PlayerSelectionViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.players.isEmpty) {
            // Aucun joueur enregistré, proposer d'en créer un
            return Center(
              child: ElevatedButton(
                key: Key("PlayerRegister"),
                onPressed: () => context.push('/player_register'),
                child: Text("Créer un joueur"),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  key: Key("PlayerRegister"),
                  onPressed: () => context.push('/player_register'),
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: Text("Nouveau joueur"),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: viewModel.players.map((player) {
                        return PlayerCard(
                          key: Key(player.name),
                          player: player,
                          onTap: () => viewModel.selectPlayer(player, context),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
