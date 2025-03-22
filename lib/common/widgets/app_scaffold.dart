import 'package:challengemultiplication/features/players/viewmodels/player_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<PlayerSelectionViewModel>(
          builder: (context, viewModel, child) {
            final String playerName = viewModel.selectedPlayer?.name ?? "";
            return Text(playerName.isNotEmpty ? 'Challenge Multiplications - $playerName' : 'Challenge Multiplications');
          },
        ),
      ),
      body: Center(child: Padding(padding: const EdgeInsets.all(16.0), child: body)),
    );
  }
}
