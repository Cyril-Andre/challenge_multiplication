import 'package:challengemultiplication/features/history/models/history_entry.dart';
import 'package:challengemultiplication/features/history/viewmodels/history_viewmodel.dart';
import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('HistoryViewModel', () {
    test('clears history when no player is selected', () async {
      final service = PlayerService();
      final viewModel = HistoryViewModel(service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);
      var notifications = 0;

      viewModel.addListener(() {
        notifications++;
      });

      await viewModel.loadPlayerHistory();

      expect(viewModel.currentPlayer, isNull);
      expect(viewModel.history, isEmpty);
      expect(notifications, 1);
    });

    test('loads and sorts the selected player history', () async {
      final service = PlayerService();
      final selectedPlayer = _player(
        id: 'player-1',
        history: [
          HistoryEntry(date: DateTime(2026, 8, 25, 12), score: 8),
          HistoryEntry(date: DateTime(2026, 8, 24, 12), score: 15),
        ],
      );
      final staleSelectedPlayer = _player(id: 'player-1');
      final viewModel = HistoryViewModel(service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      await service.savePlayers([selectedPlayer]);
      service.currentPlayer = staleSelectedPlayer;

      await viewModel.loadPlayerHistory();

      expect(viewModel.currentPlayer?.id, 'player-1');
      expect(viewModel.history.map((entry) => entry.score), [15, 8]);
      expect(service.currentPlayer?.history, hasLength(2));
    });

    test('clears history when the selected player is missing from storage',
        () async {
      final service = PlayerService();
      final viewModel = HistoryViewModel(service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      await service.savePlayers([_player(id: 'player-1')]);
      service.currentPlayer = _player(id: 'missing');

      await viewModel.loadPlayerHistory();

      expect(viewModel.currentPlayer, isNull);
      expect(viewModel.history, isEmpty);
    });
  });
}

Player _player({
  required String id,
  List<HistoryEntry> history = const [],
}) {
  return Player(
    id: id,
    name: 'Alice',
    pin: '1234',
    settings: {},
    history: List.of(history),
  );
}
