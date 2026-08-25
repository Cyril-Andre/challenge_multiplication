import 'package:challengemultiplication/features/history/models/history_entry.dart';
import 'package:challengemultiplication/features/history/views/history_screen.dart';
import 'package:challengemultiplication/features/history/widget/score_card.dart';
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

  group('HistoryScreen', () {
    testWidgets('shows an empty state when no player is selected',
        (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));
      await tester.pump();
      await tester.pump();

      expect(find.text('Historique des scores'), findsOneWidget);
      expect(find.text('Aucun joueur sélectionné'), findsOneWidget);

      await tester.tap(find.byKey(const Key('Home')));
      await tester.pumpAndSettle();

      expect(find.text('home-route'), findsOneWidget);
    });

    testWidgets('shows an empty state when the selected player has no history',
        (tester) async {
      final player = _player(history: []);
      final service = PlayerService()..currentPlayer = player;
      addTearDown(service.dispose);

      await service.savePlayers([player]);
      await tester.pumpWidget(_app(service));
      await tester.pump();
      await tester.pump();

      expect(find.text('Aucun historique disponible'), findsOneWidget);
    });

    testWidgets('shows a chart when history exists', (tester) async {
      final player = _player(
        history: [
          HistoryEntry(date: DateTime(2026, 8, 24), score: 8),
          HistoryEntry(date: DateTime(2026, 8, 25), score: 15),
        ],
      );
      final service = PlayerService()..currentPlayer = player;
      addTearDown(service.dispose);

      await service.savePlayers([player]);
      await tester.pumpWidget(_app(service));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ScoreChart), findsOneWidget);
    });
  });
}

Widget _app(PlayerService service) {
  final router = GoRouter(
    initialLocation: '/history',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _RouteTarget('home-route'),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );

  return ChangeNotifierProvider<PlayerService>.value(
    value: service,
    child: MaterialApp.router(routerConfig: router),
  );
}

Player _player({required List<HistoryEntry> history}) {
  return Player(
    id: 'player-1',
    name: 'Alice',
    pin: '1234',
    settings: {},
    history: history,
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
