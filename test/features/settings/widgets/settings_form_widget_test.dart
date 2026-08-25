import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:challengemultiplication/features/settings/widgets/settings_form_widget.dart';
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

  group('SettingsFormWidget', () {
    testWidgets('updates and saves player settings', (tester) async {
      final player = _player();
      final service = PlayerService()..currentPlayer = player;
      final viewModel = SettingsViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      await service.savePlayers([player]);
      await tester.pumpWidget(_app(service, viewModel));
      await _openSettings(tester);

      expect(find.text('60 sec'), findsOneWidget);
      expect(find.text('Amateur'), findsOneWidget);

      tester.widget<Slider>(find.byType(Slider)).onChanged!(120);
      await tester.pump();

      expect(find.text('120 sec'), findsOneWidget);

      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Ligue des champions').last);
      await tester.pump();

      expect(viewModel.difficulty, 3);

      await tester.tap(find.text('Sauvegarder'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final storedPlayers = await service.getPlayers();
      expect(find.text('open-settings'), findsOneWidget);
      expect(storedPlayers.single.playerSettings.timelimit, 120);
      expect(storedPlayers.single.playerSettings.difficulty, 3);
    });

    testWidgets('cancels by popping the settings route', (tester) async {
      final player = _player();
      final service = PlayerService()..currentPlayer = player;
      final viewModel = SettingsViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      await service.savePlayers([player]);
      await tester.pumpWidget(_app(service, viewModel));
      await _openSettings(tester);

      await tester.tap(find.text('Annuler'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('open-settings'), findsOneWidget);
    });
  });
}

Future<void> _openSettings(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('OpenSettings')));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Widget _app(PlayerService service, SettingsViewModel viewModel) {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Scaffold(
          body: ElevatedButton(
            key: const Key('OpenSettings'),
            onPressed: () => context.push('/settings'),
            child: const Text('open-settings'),
          ),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const Scaffold(
          body: SizedBox.expand(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SettingsFormWidget(),
            ),
          ),
        ),
      ),
    ],
  );

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<PlayerService>.value(value: service),
      ChangeNotifierProvider<SettingsViewModel>.value(value: viewModel),
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
