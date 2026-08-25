import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/viewmodels/player_selection_view_model.dart';
import 'package:challengemultiplication/features/players/views/player_selection_screen.dart';
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

  group('PlayerSelectionScreen', () {
    testWidgets('offers to create a player when the list is empty',
        (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await tester.pumpWidget(_app(service));
      await tester.pump();
      await tester.pump();

      expect(find.text('Créer un joueur'), findsOneWidget);

      await tester.tap(find.byKey(const Key('PlayerRegister')));
      await tester.pumpAndSettle();

      expect(find.text('player-register-route'), findsOneWidget);
    });

    testWidgets('navigates to player creation from a populated list',
        (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await service.savePlayers([_player(id: 'player-1', name: 'Alice')]);

      await tester.pumpWidget(_app(service));
      await tester.pump();
      await tester.pump();

      await tester.tap(find.byKey(const Key('PlayerRegister')));
      await tester.pumpAndSettle();

      expect(find.text('player-register-route'), findsOneWidget);
    });

    testWidgets('shows players and selects one after pin entry',
        (tester) async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await service.savePlayers([
        _player(id: 'player-1', name: 'Alice'),
        _player(id: 'player-2', name: 'Sam'),
      ]);

      await tester.pumpWidget(_app(service));
      await tester.pump();
      await tester.pump();

      expect(find.text('Nouveau joueur'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Sam'), findsOneWidget);

      await tester.tap(find.byKey(const Key('Alice')));
      await tester.pumpAndSettle();

      expect(find.text('Entrez le PIN de Alice'), findsOneWidget);

      for (final digit in ['1', '2', '3', '4']) {
        await tester.tap(find.text(digit).last);
        await tester.pump();
      }
      await tester.pumpAndSettle();

      expect(service.currentPlayer?.name, 'Alice');
      expect(find.text('home-route'), findsOneWidget);
    });
  });
}

Widget _app(PlayerService service) {
  final router = GoRouter(
    initialLocation: '/player_selection',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _RouteTarget('home-route'),
      ),
      GoRoute(
        path: '/player_selection',
        builder: (context, state) => const PlayerSelectionScreen(),
      ),
      GoRoute(
        path: '/player_register',
        builder: (context, state) =>
            const _RouteTarget('player-register-route'),
      ),
    ],
  );

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayerService>.value(value: service),
      ChangeNotifierProvider(
        create: (_) => PlayerSelectionViewModel(service),
      ),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

Player _player({required String id, required String name}) {
  return Player(
    id: id,
    name: name,
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
