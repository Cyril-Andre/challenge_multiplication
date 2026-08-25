import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<PlayerService>(
          builder: (context, viewModel, child) {
            final String playerName = viewModel.currentPlayer?.name ?? "";
            return Text(playerName.isNotEmpty
                ? 'Challenge Multiplications - $playerName'
                : 'Challenge Multiplications');
          },
        ),
      ),
      body: Center(
          child: Padding(padding: const EdgeInsets.all(16.0), child: body)),
    );
  }
}
