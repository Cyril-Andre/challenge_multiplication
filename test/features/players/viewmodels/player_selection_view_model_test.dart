import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/viewmodels/player_selection_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PlayerSelectionViewModel', () {
    test('loads players from storage', () async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await service.savePlayers([
        _player(id: 'player-1', name: 'Alice'),
        _player(id: 'player-2', name: 'Sam'),
      ]);
      final viewModel = PlayerSelectionViewModel(service);
      addTearDown(viewModel.dispose);

      await viewModel.loadPlayers();

      expect(viewModel.players.map((player) => player.name), ['Alice', 'Sam']);
    });

    test('refresh reloads updated players', () async {
      final service = PlayerService();
      addTearDown(service.dispose);

      await service.savePlayers([_player(id: 'player-1', name: 'Alice')]);
      final viewModel = PlayerSelectionViewModel(service);
      addTearDown(viewModel.dispose);

      await viewModel.loadPlayers();

      await service.savePlayers([
        _player(id: 'player-1', name: 'Alice'),
        _player(id: 'player-2', name: 'Sam'),
      ]);
      await viewModel.refresh();

      expect(viewModel.players, hasLength(2));
    });
  });
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
