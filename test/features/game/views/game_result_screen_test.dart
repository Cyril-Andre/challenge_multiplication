import 'package:challengemultiplication/features/game/models/multiplication.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challengemultiplication/features/game/views/game_result_screen.dart';
import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('GameResultScreen', () {
    testWidgets('shows an empty state when no player is selected',
        (tester) async {
      final service = PlayerService();
      final viewModel = GamePlayViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service, viewModel));

      expect(find.text('Aucun joueur sélectionné'), findsOneWidget);
      expect(find.text("Retour à l'accueil"), findsOneWidget);

      await tester.tap(find.byKey(const Key('Home')));
      await tester.pumpAndSettle();

      expect(find.text('home-route'), findsOneWidget);
    });

    testWidgets('shows an empty state when there is no result', (tester) async {
      final service = PlayerService()..currentPlayer = _player();
      final viewModel = GamePlayViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service, viewModel));

      expect(find.text('Aucun résultat disponible'), findsOneWidget);
      expect(find.text("Retour à l'accueil"), findsOneWidget);
    });

    testWidgets('shows the score, errors and saves history once',
        (tester) async {
      final player = _player();
      final service = PlayerService()..currentPlayer = player;
      final viewModel = _scoredViewModel(service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      await service.savePlayers([player]);
      await tester.pumpWidget(_app(service, viewModel));
      await tester.pumpAndSettle();

      expect(find.text('Résultat du Challenge'), findsOneWidget);
      expect(find.text('1 / 2'), findsOneWidget);
      expect(find.text('2 : 1'), findsOneWidget);
      expect(find.text('3 : 1'), findsOneWidget);

      service.currentPlayer = service.currentPlayer;
      await tester.pump();

      final storedPlayers = await service.getPlayers();
      expect(storedPlayers.single.history, hasLength(1));
      expect(storedPlayers.single.history.single.score, 1);
    });

    for (final destination in [
      _Destination(const Key('Rejouer'), 'game-route'),
      _Destination(const Key('Historique'), 'history-route'),
      _Destination(const Key('Home'), 'home-route'),
    ]) {
      testWidgets('navigates to ${destination.targetText}', (tester) async {
        final player = _player();
        final service = PlayerService()..currentPlayer = player;
        final viewModel = _scoredViewModel(service);
        addTearDown(viewModel.dispose);
        addTearDown(service.dispose);

        await service.savePlayers([player]);
        await tester.pumpWidget(_app(service, viewModel));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(destination.key));
        await tester.pumpAndSettle();

        expect(find.text(destination.targetText), findsOneWidget);
      });
    }
  });
}

Widget _app(PlayerService service, GamePlayViewModel viewModel) {
  final router = GoRouter(
    initialLocation: '/game_result',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _RouteTarget('home-route'),
      ),
      GoRoute(
        path: '/game',
        builder: (context, state) => const _RouteTarget('game-route'),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const _RouteTarget('history-route'),
      ),
      GoRoute(
        path: '/game_result',
        builder: (context, state) => const GameResultScreen(),
      ),
    ],
  );

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayerService>.value(value: service),
      ChangeNotifierProvider<GamePlayViewModel>.value(value: viewModel),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

GamePlayViewModel _scoredViewModel(PlayerService service) {
  return GamePlayViewModel(playerService: service)
    ..multiplicationsGenerated = true
    ..numberMultiplications = 2
    ..multiplications.addAll([
      Multiplication(2, 2)..userAnswer = '4',
      Multiplication(2, 3)..userAnswer = '0',
    ]);
}

Player _player() {
  return Player(
    id: 'player-1',
    name: 'Alice',
    pin: '1234',
    settings: {},
    history: [],
  );
}

class _Destination {
  final Key key;
  final String targetText;

  const _Destination(this.key, this.targetText);
}

class _RouteTarget extends StatelessWidget {
  final String text;

  const _RouteTarget(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(text));
  }
}
