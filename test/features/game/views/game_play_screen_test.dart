import 'package:challengemultiplication/features/game/models/multiplication.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challengemultiplication/features/game/views/game_play_screen.dart';
import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  group('GamePlayScreen', () {
    testWidgets('renders multiplications and records answers', (tester) async {
      final service = PlayerService()..currentPlayer = _player();
      final viewModel = GamePlayViewModel(playerService: service)
        ..timeLimit = 60
        ..timeRemaining = 60
        ..numberMultiplications = 1
        ..multiplicationsGenerated = true
        ..multiplications.add(Multiplication(2, 3));

      try {
        await tester.pumpWidget(_app(service, viewModel));
        await tester.pump();

        expect(find.text('60s'), findsOneWidget);
        expect(find.text('2 × 3 = '), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);

        await tester.enterText(find.byType(TextField), '6');

        expect(viewModel.multiplications.single.userAnswer, '6');
      } finally {
        viewModel.dispose();
        service.dispose();
      }
    });

    testWidgets('generates multiplications when the game is not initialized',
        (tester) async {
      final service = PlayerService()..currentPlayer = _player();
      final viewModel = GamePlayViewModel(playerService: service);

      try {
        await tester.pumpWidget(_app(service, viewModel));
        await tester.pump();

        expect(viewModel.multiplicationsGenerated, isTrue);
        expect(viewModel.multiplications, hasLength(15));
        expect(find.byType(TextField), findsNWidgets(15));
      } finally {
        viewModel.dispose();
        service.dispose();
      }
    });

    testWidgets('navigates to results when time is over', (tester) async {
      final service = PlayerService()..currentPlayer = _player();
      final viewModel = GamePlayViewModel(playerService: service)
        ..timeLimit = 60
        ..timeRemaining = 0
        ..numberMultiplications = 1
        ..multiplicationsGenerated = true
        ..multiplications.add(Multiplication(2, 3));

      try {
        await tester.pumpWidget(_app(service, viewModel));
        await tester.pump();
        await tester.pump();
        await tester.pump();

        expect(find.text('game-result-route'), findsOneWidget);
      } finally {
        viewModel.dispose();
        service.dispose();
      }
    });
  });
}

Widget _app(PlayerService service, GamePlayViewModel viewModel) {
  final router = GoRouter(
    initialLocation: '/game_play',
    routes: [
      GoRoute(
        path: '/game_play',
        builder: (context, state) => const GamePlayScreen(),
      ),
      GoRoute(
        path: '/game_result',
        builder: (context, state) => const _RouteTarget('game-result-route'),
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

Player _player() {
  return Player(
    id: 'player-1',
    name: 'Alice',
    pin: '1234',
    settings: {},
    history: [],
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
