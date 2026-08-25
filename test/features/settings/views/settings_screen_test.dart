import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/settings/views/settings_screen.dart';
import 'package:challengemultiplication/features/settings/widgets/settings_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  group('SettingsScreen', () {
    testWidgets('asks for a player when none is selected', (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));
      await tester.pump();

      expect(find.text('Aucun joueur sélectionné'), findsOneWidget);
      expect(find.text('Choisir un joueur'), findsOneWidget);

      await tester.tap(find.text('Choisir un joueur'));
      await tester.pumpAndSettle();

      expect(find.text('player-selection-route'), findsOneWidget);
    });

    testWidgets('shows the settings form when a player is selected',
        (tester) async {
      final service = PlayerService()
        ..currentPlayer = Player(
          id: 'player-1',
          name: 'Alice',
          pin: '1234',
          settings: {
            'timelimit': 90,
            'difficulty': 2,
          },
          history: [],
        );
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(SettingsFormWidget), findsOneWidget);
      expect(find.text('90 sec'), findsOneWidget);
      expect(find.text('Ligue 1'), findsOneWidget);
    });
  });
}

Widget _app(PlayerService service) {
  final router = GoRouter(
    initialLocation: '/settings',
    routes: [
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
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

class _RouteTarget extends StatelessWidget {
  final String text;

  const _RouteTarget(this.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(text));
  }
}
