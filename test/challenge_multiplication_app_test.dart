import 'package:challengemultiplication/challenge_multiplication_app.dart';
import 'package:challengemultiplication/common/services/router.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challengemultiplication/features/game/viewmodels/game_viewmodel.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/viewmodels/player_selection_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('builds the app with the configured router', (tester) async {
    setupRouter('/');
    final playerService = PlayerService();
    final gameViewModel = GameViewModel();
    final gamePlayViewModel = GamePlayViewModel(playerService: playerService);
    final playerSelectionViewModel = PlayerSelectionViewModel(playerService);
    addTearDown(playerSelectionViewModel.dispose);
    addTearDown(gamePlayViewModel.dispose);
    addTearDown(gameViewModel.dispose);
    addTearDown(playerService.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayerService>.value(value: playerService),
          ChangeNotifierProvider<GameViewModel>.value(value: gameViewModel),
          ChangeNotifierProvider<GamePlayViewModel>.value(
            value: gamePlayViewModel,
          ),
          ChangeNotifierProvider<PlayerSelectionViewModel>.value(
            value: playerSelectionViewModel,
          ),
        ],
        child: const ChallengeMultiplicationApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Challenge Multiplications'), findsOneWidget);
    expect(find.text('Jouer'), findsOneWidget);
  });

  testWidgets('configured router can build each application route',
      (tester) async {
    setupRouter('/');
    final playerService = PlayerService();
    final gameViewModel = GameViewModel();
    final gamePlayViewModel = GamePlayViewModel(playerService: playerService);
    final playerSelectionViewModel = PlayerSelectionViewModel(playerService);
    addTearDown(playerSelectionViewModel.dispose);
    addTearDown(gamePlayViewModel.dispose);
    addTearDown(gameViewModel.dispose);
    addTearDown(playerService.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PlayerService>.value(value: playerService),
          ChangeNotifierProvider<GameViewModel>.value(value: gameViewModel),
          ChangeNotifierProvider<GamePlayViewModel>.value(
            value: gamePlayViewModel,
          ),
          ChangeNotifierProvider<PlayerSelectionViewModel>.value(
            value: playerSelectionViewModel,
          ),
        ],
        child: const ChallengeMultiplicationApp(),
      ),
    );

    router.go('/player_register');
    await tester.pumpAndSettle();
    expect(find.text('Choisis un pseudo'), findsOneWidget);

    router.go('/player_selection');
    await tester.pumpAndSettle();
    expect(find.text('Créer un joueur'), findsOneWidget);

    router.go('/game');
    await tester.pumpAndSettle();
    expect(find.text('Choisis un joueur avant de lancer une partie'),
        findsOneWidget);

    router.go('/game_result');
    await tester.pumpAndSettle();
    expect(find.text('Aucun joueur sélectionné'), findsOneWidget);

    router.go('/history');
    await tester.pumpAndSettle();
    expect(find.text('Historique des scores'), findsOneWidget);

    router.go('/settings');
    await tester.pumpAndSettle();
    expect(find.text('Aucun joueur sélectionné'), findsWidgets);
  });
}
