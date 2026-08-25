import 'package:challengemultiplication/features/settings/models/player_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerSettings', () {
    test('exposes default values', () {
      final settings = PlayerSettings.defaults();

      expect(settings.timelimit, 60);
      expect(settings.difficulty, 1);
    });

    test('uses defaults when values are missing', () {
      final settings = PlayerSettings.fromMap({});

      expect(settings.timelimit, 60);
      expect(settings.difficulty, 1);
    });

    test('round-trips to and from a map', () {
      final settings = PlayerSettings(
        timelimit: 120,
        difficulty: 3,
      );

      final restored = PlayerSettings.fromMap(settings.toMap());

      expect(restored.timelimit, 120);
      expect(restored.difficulty, 3);
    });
  });
}
