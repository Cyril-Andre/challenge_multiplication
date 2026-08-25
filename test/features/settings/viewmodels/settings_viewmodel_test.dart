import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('SettingsViewModel', () {
    test('uses defaults when no player is selected', () {
      final service = PlayerService();
      final viewModel = SettingsViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      expect(viewModel.timelimit, 60);
      expect(viewModel.difficulty, 1);
    });

    test('uses selected player settings', () {
      final service = PlayerService()
        ..currentPlayer = _player(
          id: 'player-1',
          settings: {
            'timelimit': 90,
            'difficulty': 3,
          },
        );
      final viewModel = SettingsViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      expect(viewModel.timelimit, 90);
      expect(viewModel.difficulty, 3);
    });

    test('updates settings values and notifies listeners', () {
      final service = PlayerService();
      final viewModel = SettingsViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);
      var notifications = 0;

      viewModel.addListener(() {
        notifications++;
      });

      viewModel.setTimelimit(120);
      viewModel.setDifficulty(2);

      expect(viewModel.timelimit, 120);
      expect(viewModel.difficulty, 2);
      expect(notifications, 2);
    });

    test('refuses to save without a selected player', () async {
      final service = PlayerService();
      final viewModel = SettingsViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      expect(await viewModel.saveSettings(), isFalse);
    });

    test('refuses to save when the selected player is not stored', () async {
      final service = PlayerService()
        ..currentPlayer = _player(id: 'missing', settings: {});
      final viewModel = SettingsViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      await service.savePlayers([_player(id: 'player-1', settings: {})]);

      expect(await viewModel.saveSettings(), isFalse);
    });

    test('persists settings and refreshes the current player', () async {
      final service = PlayerService();
      final currentPlayer = _player(
        id: 'player-2',
        settings: {
          'timelimit': 60,
          'difficulty': 1,
        },
      );
      addTearDown(service.dispose);

      await service.savePlayers([
        _player(id: 'player-1', settings: {}),
        currentPlayer,
      ]);
      service.currentPlayer = currentPlayer;
      final selectedSettingsViewModel =
          SettingsViewModel(playerService: service);
      addTearDown(selectedSettingsViewModel.dispose);

      selectedSettingsViewModel.setTimelimit(90);
      selectedSettingsViewModel.setDifficulty(3);

      expect(await selectedSettingsViewModel.saveSettings(), isTrue);

      final storedPlayers = await service.getPlayers();
      final storedCurrent =
          storedPlayers.firstWhere((player) => player.id == 'player-2');

      expect(storedCurrent.playerSettings.timelimit, 90);
      expect(storedCurrent.playerSettings.difficulty, 3);
      expect(service.currentPlayer?.playerSettings.timelimit, 90);
      expect(service.currentPlayer?.playerSettings.difficulty, 3);
    });
  });
}

Player _player({
  required String id,
  required Map<String, dynamic> settings,
}) {
  return Player(
    id: id,
    name: 'Alice',
    pin: '1234',
    settings: settings,
    history: [],
  );
}
