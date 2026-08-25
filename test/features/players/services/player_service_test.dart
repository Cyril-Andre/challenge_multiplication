import 'package:challengemultiplication/features/history/models/history_entry.dart';
import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/settings/models/player_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PlayerService', () {
    test('adds and reads players from shared preferences', () async {
      final service = PlayerService();
      addTearDown(service.dispose);

      final player = _player(id: 'player-1', name: 'Alice');

      await service.addPlayer(player);

      final players = await service.getPlayers();

      expect(players, hasLength(1));
      expect(players.single.id, 'player-1');
      expect(players.single.name, 'Alice');
      expect(players.single.playerSettings.timelimit, 60);
    });

    test('updates history by player id when names are duplicated', () async {
      final service = PlayerService();
      addTearDown(service.dispose);

      final firstPlayer = _player(id: 'player-1', name: 'Sam');
      final secondPlayer = _player(id: 'player-2', name: 'Sam');
      final entry = HistoryEntry(
        date: DateTime(2026, 8, 25, 13, 30),
        score: 12,
      );

      await service.savePlayers([firstPlayer, secondPlayer]);
      service.currentPlayer = secondPlayer;

      await service.updatePlayerHistory(secondPlayer, entry);

      final players = await service.getPlayers();

      expect(players.firstWhere((p) => p.id == 'player-1').history, isEmpty);
      expect(
          players.firstWhere((p) => p.id == 'player-2').history, hasLength(1));
      expect(service.currentPlayer?.history.single.score, 12);
    });

    test('ignores history updates for unknown players', () async {
      final service = PlayerService();
      addTearDown(service.dispose);

      final storedPlayer = _player(id: 'player-1', name: 'Alice');
      final unknownPlayer = _player(id: 'unknown', name: 'Alice');
      final entry = HistoryEntry(
        date: DateTime(2026, 8, 25, 13, 30),
        score: 12,
      );

      await service.savePlayers([storedPlayer]);

      await service.updatePlayerHistory(unknownPlayer, entry);

      final players = await service.getPlayers();

      expect(players.single.history, isEmpty);
    });

    test('notifies listeners when current player changes', () {
      final service = PlayerService();
      addTearDown(service.dispose);
      var notifications = 0;

      service.addListener(() {
        notifications++;
      });

      service.currentPlayer = _player(id: 'player-1', name: 'Alice');

      expect(notifications, 1);
    });
  });
}

Player _player({
  required String id,
  required String name,
  Map<String, dynamic>? settings,
}) {
  return Player(
    id: id,
    name: name,
    pin: '1234',
    settings: settings ?? PlayerSettings.defaults().toMap(),
    history: [],
  );
}
