import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/settings/models/player_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Player', () {
    test('updates the settings map through the typed settings setter', () {
      final player = Player(
        id: 'player-1',
        name: 'Alice',
        pin: '1234',
        settings: {},
        history: [],
      );

      player.playerSettings = PlayerSettings(timelimit: 90, difficulty: 3);

      expect(player.settings, {
        'timelimit': 90,
        'difficulty': 3,
      });
      expect(player.playerSettings.timelimit, 90);
      expect(player.playerSettings.difficulty, 3);
    });
  });
}
