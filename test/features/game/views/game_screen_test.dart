import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_viewmodel.dart';
import 'package:challengemultiplication/features/game/views/game_screen.dart';
import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  group('GameScreen', () {
    testWidgets('asks for a player before starting a game', (tester) async {
      final service = PlayerService();
      final gameViewModel = GameViewModel();
      addTearDown(gameViewModel.dispose);
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service, gameViewModel));

      expect(
        find.text('Choisis un joueur avant de lancer une partie'),
        findsOneWidget,
      );
      expect(find.text('Choisir un joueur'), findsOneWidget);
      expect(find.text('Commencer'), findsNothing);
    });

    testWidgets('shows the start action when a player is selected',
        (tester) async {
      final gameViewModel = GameViewModel();
      final service = PlayerService()
        ..currentPlayer = Player(
          id: 'player-1',
          name: 'Alice',
          pin: '1234',
          settings: {},
          history: [],
        );
      addTearDown(gameViewModel.dispose);
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service, gameViewModel));

      expect(find.text('Commencer'), findsOneWidget);
      expect(find.text('Choisir un joueur'), findsNothing);
    });

    testWidgets('opens the countdown dialog from the start action',
        (tester) async {
      final gameViewModel = GameViewModel();
      final service = PlayerService()
        ..currentPlayer = Player(
          id: 'player-1',
          name: 'Alice',
          pin: '1234',
          settings: {},
          history: [],
        );
      final gamePlayViewModel = GamePlayViewModel(playerService: service);

      try {
        await tester.pumpWidget(
          _countdownRouterApp(service, gameViewModel, gamePlayViewModel),
        );

        await tester.tap(find.byKey(const Key('Start')));
        await tester.pump();

        expect(find.text('Prépare-toi !'), findsOneWidget);
        expect(
          find.text('Concentre-toi, le challenge va commencer'),
          findsOneWidget,
        );
        expect(find.text('10'), findsOneWidget);

        await tester.pump(const Duration(seconds: 11));
        await tester.pump();
        await tester.pump();

        expect(gamePlayViewModel.multiplicationsGenerated, isTrue);
        expect(find.text('game-play-route'), findsOneWidget);
      } finally {
        gameViewModel.dispose();
        gamePlayViewModel.dispose();
        service.dispose();
      }
    });

    testWidgets('navigates from empty and selected player actions',
        (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_routerApp(service));

      await tester.tap(find.text('Choisir un joueur'));
      await tester.pumpAndSettle();

      expect(find.text('player-selection-route'), findsOneWidget);

      service.currentPlayer = Player(
        id: 'player-1',
        name: 'Alice',
        pin: '1234',
        settings: {},
        history: [],
      );
      _testRouter.go('/game');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('Home')));
      await tester.pumpAndSettle();

      expect(find.text('home-route'), findsOneWidget);
    });
  });
}

late GoRouter _testRouter;

Widget _app(PlayerService service, GameViewModel gameViewModel) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayerService>.value(value: service),
      ChangeNotifierProvider<GameViewModel>.value(value: gameViewModel),
      ChangeNotifierProvider(
        create: (_) => GamePlayViewModel(playerService: service),
      ),
    ],
    child: const MaterialApp(
      home: GameScreen(),
    ),
  );
}

Widget _countdownRouterApp(
  PlayerService service,
  GameViewModel gameViewModel,
  GamePlayViewModel gamePlayViewModel,
) {
  final router = GoRouter(
    initialLocation: '/game',
    routes: [
      GoRoute(
        path: '/game',
        builder: (context, state) => const GameScreen(),
      ),
      GoRoute(
        path: '/game_play',
        builder: (context, state) => const _RouteTarget('game-play-route'),
      ),
    ],
  );

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayerService>.value(value: service),
      ChangeNotifierProvider<GameViewModel>.value(value: gameViewModel),
      ChangeNotifierProvider<GamePlayViewModel>.value(value: gamePlayViewModel),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

Widget _routerApp(PlayerService service) {
  _testRouter = GoRouter(
    initialLocation: '/game',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _RouteTarget('home-route'),
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) => const GameScreen(),
      ),
      GoRoute(
        path: '/player_selection',
        builder: (context, state) =>
            const _RouteTarget('player-selection-route'),
      ),
    ],
  );

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayerService>.value(value: service),
      ChangeNotifierProvider(create: (_) => GameViewModel()),
      ChangeNotifierProvider(
        create: (_) => GamePlayViewModel(playerService: service),
      ),
    ],
    child: MaterialApp.router(routerConfig: _testRouter),
  );
}

class _RouteTarget extends StatelessWidget {
  final String text;

  const _RouteTarget(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(text));
  }
}
