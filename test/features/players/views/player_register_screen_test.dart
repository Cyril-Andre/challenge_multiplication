import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/views/player_register_screen.dart';
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

  group('PlayerRegisterScreen', () {
    testWidgets('shows an incomplete registration form', (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));

      expect(find.text('Choisis un pseudo'), findsOneWidget);
      expect(find.text('Choisis un code PIN'), findsOneWidget);

      await tester.tap(find.byKey(const Key('1')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('⌫')));
      await tester.pump();

      final button = tester
          .widget<ElevatedButton>(find.byKey(const Key('PlayerSelection')));
      expect(button.onPressed, isNull);
    });

    testWidgets('registers a player and navigates to selection',
        (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));

      await tester.enterText(find.byKey(const Key('PlayerName')), 'Alice');
      for (final digit in ['1', '2', '3', '4']) {
        await tester.tap(find.byKey(Key(digit)));
        await tester.pump();
      }

      final button = tester
          .widget<ElevatedButton>(find.byKey(const Key('PlayerSelection')));
      expect(button.onPressed, isNotNull);

      await tester.ensureVisible(find.byKey(const Key('PlayerSelection')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('PlayerSelection')));
      await tester.pumpAndSettle();

      final players = await service.getPlayers();
      expect(find.text('player-selection-route'), findsOneWidget);
      expect(players, hasLength(1));
      expect(players.single.name, 'Alice');
      expect(players.single.pin, '1234');
    });

    testWidgets('registers a player from the numpad confirmation',
        (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));

      await tester.enterText(find.byKey(const Key('PlayerName')), 'Alice');
      for (final digit in ['1', '2', '3', '4']) {
        await tester.tap(find.byKey(Key(digit)));
        await tester.pump();
      }

      await tester.ensureVisible(find.byKey(const Key('✅')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('✅')));
      await tester.pumpAndSettle();

      final players = await service.getPlayers();
      expect(find.text('player-selection-route'), findsOneWidget);
      expect(players, hasLength(1));
      expect(players.single.name, 'Alice');
    });
  });
}

Widget _app(PlayerService service) {
  final router = GoRouter(
    initialLocation: '/player_register',
    routes: [
      GoRoute(
        path: '/player_register',
        builder: (context, state) => const PlayerRegisterScreen(),
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
