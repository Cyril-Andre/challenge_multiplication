import 'package:challengemultiplication/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Réponds correctement au maximum de multiplications et améliore ton score !', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          SizedBox(width: 200, child: ElevatedButton(key:Key("Jouer"), onPressed: () => context.go('/game'), child: const Text('Jouer'))),
          const SizedBox(height: 10),
          SizedBox(width: 200, child: ElevatedButton(key: Key("Historique"), onPressed: () => context.go('/history'), child: const Text('Historique'))),
//          const SizedBox(height: 10),
//          SizedBox(width: 200, child: ElevatedButton(onPressed: () => context.go('/settings'), child: const Text('Paramètres'))),
          const SizedBox(height: 10),
          SizedBox(width: 200, child: ElevatedButton(onPressed: () => context.go('/player_selection'), child: const Text('Autre joueur'))),
        ],
      ),
    );
  }
}
