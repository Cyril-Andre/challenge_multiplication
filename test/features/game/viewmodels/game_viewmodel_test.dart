import 'package:challengemultiplication/features/game/viewmodels/game_viewmodel.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameViewModel', () {
    test('counts down and calls the completion callback once', () {
      fakeAsync((async) {
        final viewModel = GameViewModel();
        var completions = 0;
        var notifications = 0;

        viewModel.addListener(() {
          notifications++;
        });

        viewModel.startCountdown(() {
          completions++;
        });

        expect(viewModel.countdown, 10);

        async.elapse(const Duration(seconds: 1));

        expect(viewModel.countdown, 9);
        expect(notifications, 1);

        async.elapse(const Duration(seconds: 10));

        expect(viewModel.countdown, 0);
        expect(completions, 1);

        async.elapse(const Duration(seconds: 5));

        expect(completions, 1);

        viewModel.dispose();
      });
    });

    test('restarting countdown cancels the previous timer', () {
      fakeAsync((async) {
        final viewModel = GameViewModel();
        var firstCompletions = 0;
        var secondCompletions = 0;

        viewModel.startCountdown(() {
          firstCompletions++;
        });

        async.elapse(const Duration(seconds: 3));

        expect(viewModel.countdown, 7);

        viewModel.startCountdown(() {
          secondCompletions++;
        });

        expect(viewModel.countdown, 10);

        async.elapse(const Duration(seconds: 11));

        expect(firstCompletions, 0);
        expect(secondCompletions, 1);

        viewModel.dispose();
      });
    });

    test('dispose cancels an active countdown', () {
      fakeAsync((async) {
        final viewModel = GameViewModel();
        var completions = 0;

        viewModel.startCountdown(() {
          completions++;
        });

        async.elapse(const Duration(seconds: 2));
        viewModel.dispose();
        async.elapse(const Duration(seconds: 20));

        expect(viewModel.countdown, 8);
        expect(completions, 0);
      });
    });
  });
}
