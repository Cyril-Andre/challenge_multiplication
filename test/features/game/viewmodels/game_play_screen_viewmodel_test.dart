import 'package:challengemultiplication/features/game/viewmodels/game_play_screen_viewmodel.dart';
import 'package:challengemultiplication/features/game/models/multiplication.dart';
import 'package:challengemultiplication/features/players/models/player.dart';
import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GamePlayViewModel', () {
    test('generates multiplications from current player settings', () {
      final service = PlayerService()
        ..currentPlayer = _player(
          settings: {
            'timelimit': 90,
            'difficulty': 3,
          },
        );
      final viewModel = GamePlayViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      viewModel.resetGame();

      expect(viewModel.difficulty, 3);
      expect(viewModel.timeLimit, 90);
      expect(viewModel.timeRemaining, 90);
      expect(viewModel.totalQuestions, 20);
      expect(viewModel.multiplications, hasLength(20));

      final generatedPairs = <String>{};
      for (final multiplication in viewModel.multiplications) {
        expect(multiplication.a, inInclusiveRange(3, 9));
        expect(multiplication.b, inInclusiveRange(3, 9));
        expect(
          generatedPairs.add('${multiplication.a}-${multiplication.b}'),
          isTrue,
        );
      }
    });

    test('uses default settings when no player is selected', () {
      final service = PlayerService();
      final viewModel = GamePlayViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      viewModel.generateMultiplications();

      expect(viewModel.difficulty, 1);
      expect(viewModel.timeLimit, 60);
      expect(viewModel.timeRemaining, 60);
      expect(viewModel.totalQuestions, 15);
      expect(viewModel.multiplications, hasLength(15));
    });

    test('calculates final score and table errors', () {
      final service = PlayerService()
        ..currentPlayer = _player(
          settings: {
            'timelimit': 60,
            'difficulty': 1,
          },
        );
      final viewModel = GamePlayViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      viewModel.resetGame();

      for (var i = 0; i < viewModel.multiplications.length; i++) {
        final multiplication = viewModel.multiplications[i];
        viewModel.setAnswer(i, '${multiplication.a * multiplication.b}');
      }

      final failedMultiplication = viewModel.multiplications.first;
      viewModel.setAnswer(0, '0');

      final expectedErrors = <int, int>{};
      expectedErrors[failedMultiplication.a] =
          (expectedErrors[failedMultiplication.a] ?? 0) + 1;
      expectedErrors[failedMultiplication.b] =
          (expectedErrors[failedMultiplication.b] ?? 0) + 1;

      expect(viewModel.finalScore, viewModel.totalQuestions - 1);
      expect(viewModel.errors, expectedErrors);
    });

    test('ignores answers outside generated multiplication bounds', () {
      final service = PlayerService();
      final viewModel = GamePlayViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      viewModel.generateMultiplications();
      final originalAnswers =
          viewModel.multiplications.map((m) => m.userAnswer).toList();

      viewModel.setAnswer(-1, '12');
      viewModel.setAnswer(viewModel.multiplications.length, '12');

      expect(
        viewModel.multiplications.map((m) => m.userAnswer).toList(),
        originalAnswers,
      );
      expect(viewModel.finalScore, isNull);
    });

    test('uses configured multiplication count before generation', () {
      final service = PlayerService();
      final viewModel = GamePlayViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      viewModel.numberMultiplications = 12;

      expect(viewModel.totalQuestions, 12);
    });

    test('calculates final score lazily when needed', () {
      final service = PlayerService();
      final viewModel = GamePlayViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      viewModel.multiplications.addAll([
        Multiplication(2, 3)..userAnswer = '6',
        Multiplication(4, 5)..userAnswer = '0',
      ]);

      expect(viewModel.finalScore, isNull);
      expect(viewModel.ensureFinalScore(), 1);
      expect(viewModel.finalScore, 1);
      expect(viewModel.errors, {4: 1, 5: 1});
    });

    test('timer ticks once per second and does not start twice', () {
      fakeAsync((async) {
        final service = PlayerService();
        final viewModel = GamePlayViewModel(playerService: service);

        viewModel.generateMultiplications();
        viewModel.startTimer();
        viewModel.startTimer();

        async.elapse(const Duration(seconds: 2));

        expect(viewModel.timeRemaining, 58);

        async.elapse(const Duration(seconds: 58));

        expect(viewModel.timeRemaining, 0);

        async.elapse(const Duration(seconds: 10));

        expect(viewModel.timeRemaining, 0);

        viewModel.dispose();
        service.dispose();
      });
    });

    test('timer stops immediately when no time remains', () {
      fakeAsync((async) {
        final service = PlayerService();
        final viewModel = GamePlayViewModel(playerService: service);

        viewModel.timeRemaining = 0;
        viewModel.startTimer();

        async.elapse(const Duration(seconds: 1));

        expect(viewModel.timeRemaining, 0);

        async.elapse(const Duration(seconds: 5));

        expect(viewModel.timeRemaining, 0);

        viewModel.dispose();
        service.dispose();
      });
    });
  });
}

Player _player({required Map<String, dynamic> settings}) {
  return Player(
    id: 'player-1',
    name: 'Alice',
    pin: '1234',
    settings: settings,
    history: [],
  );
}
