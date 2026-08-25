import 'package:challengemultiplication/features/players/viewmodels/player_auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayerAuthViewModel', () {
    test('accepts a correct pin and ignores extra digits', () {
      var successes = 0;
      var notifications = 0;
      final viewModel = PlayerAuthViewModel(
        correctPin: '1234',
        onSuccess: () {
          successes++;
        },
      );
      addTearDown(viewModel.dispose);

      viewModel.addListener(() {
        notifications++;
      });

      for (final digit in ['1', '2', '3', '4', '5']) {
        viewModel.addDigit(digit);
      }

      expect(viewModel.enteredPin, '1234');
      expect(viewModel.isPinComplete, isTrue);
      expect(viewModel.hasError, isFalse);
      expect(successes, 1);
      expect(notifications, 4);
    });

    test('reports an error for an incorrect completed pin', () {
      var successes = 0;
      final viewModel = PlayerAuthViewModel(
        correctPin: '1234',
        onSuccess: () {
          successes++;
        },
      );
      addTearDown(viewModel.dispose);

      for (final digit in ['0', '0', '0', '0']) {
        viewModel.addDigit(digit);
      }

      expect(viewModel.enteredPin, '0000');
      expect(viewModel.isPinComplete, isTrue);
      expect(viewModel.hasError, isTrue);
      expect(successes, 0);
    });

    test('removes digits and clears the completed-pin error state', () {
      final viewModel = PlayerAuthViewModel(
        correctPin: '1234',
        onSuccess: () {},
      );
      addTearDown(viewModel.dispose);

      for (final digit in ['0', '0', '0', '0']) {
        viewModel.addDigit(digit);
      }

      viewModel.removeDigit();

      expect(viewModel.enteredPin, '000');
      expect(viewModel.isPinComplete, isFalse);
      expect(viewModel.hasError, isFalse);

      for (var i = 0; i < 3; i++) {
        viewModel.removeDigit();
      }
      viewModel.removeDigit();

      expect(viewModel.enteredPin, isEmpty);
    });
  });
}
