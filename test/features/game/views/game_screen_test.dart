import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_viewmodel.dart';
import 'package:challengemultiplication/features/game/views/game_screen.dart';
import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('GameScreen', () {
    testWidgets('asks for a player before starting a game', (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));

      expect(
        find.text('Choisis un joueur avant de lancer une partie'),
        findsOneWidget,
      );
      expect(find.text('Choisir un joueur'), findsOneWidget);
      expect(find.text('Commencer'), findsNothing);
    });

    testWidgets('shows the start action when a player is selected',
        (tester) async {
      final service = PlayerService()
        ..currentPlayer = Player(
          id: 'player-1',
          name: 'Alice',
          pin: '1234',
          settings: {},
          history: [],
        );
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));

      expect(find.text('Commencer'), findsOneWidget);
      expect(find.text('Choisir un joueur'), findsNothing);
    });
  });
}

Widget _app(PlayerService service) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayerService>.value(value: service),
      ChangeNotifierProvider(create: (_) => GameViewModel()),
      ChangeNotifierProvider(
        create: (_) => GamePlayViewModel(playerService: service),
      ),
    ],
    child: const MaterialApp(
      home: GameScreen(),
    ),
  );
}
