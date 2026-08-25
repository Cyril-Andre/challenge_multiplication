import 'package:challengemultiplication/features/home/views/home_screen.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('shows the main actions', (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));

      expect(find.text('Jouer'), findsOneWidget);
      expect(find.text('Historique'), findsOneWidget);
      expect(find.text('Paramètres'), findsOneWidget);
      expect(find.text('Autre joueur'), findsOneWidget);
    });

    for (final destination in [
      _Destination(find.byKey(const Key('Jouer')), 'game-route'),
      _Destination(find.byKey(const Key('Historique')), 'history-route'),
      _Destination(find.text('Paramètres'), 'settings-route'),
      _Destination(find.text('Autre joueur'), 'player-selection-route'),
    ]) {
      testWidgets('navigates to ${destination.targetText}', (tester) async {
        final service = PlayerService();
        addTearDown(service.dispose);

        await tester.pumpWidget(_app(service));

        await tester.tap(destination.finder);
        await tester.pumpAndSettle();

        expect(find.text(destination.targetText), findsOneWidget);
      });
    }
  });
}

Widget _app(PlayerService service) {
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/game',
        builder: (context, state) => const _RouteTarget('game-route'),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const _RouteTarget('history-route'),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const _RouteTarget('settings-route'),
      ),
      GoRoute(
        path: '/player_selection',
        builder: (context, state) =>
            const _RouteTarget('player-selection-route'),
      ),
    ],
  );

  return ChangeNotifierProvider<PlayerService>.value(
    value: service,
    child: MaterialApp.router(routerConfig: router),
  );
}

class _Destination {
  final Finder finder;
  final String targetText;

  const _Destination(this.finder, this.targetText);
}

class _RouteTarget extends StatelessWidget {
  final String text;

  const _RouteTarget(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(text));
  }
}
