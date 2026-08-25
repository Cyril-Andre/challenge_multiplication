import 'package:challengemultiplication/features/players/services/player_service.dart';
import 'package:challengemultiplication/features/players/viewmodels/registration_vew_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PlayerRegisterViewModel', () {
    test('updates registration state and limits pin length', () {
      final service = PlayerService();
      final viewModel = PlayerRegisterViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);
      var notifications = 0;

      viewModel.addListener(() {
        notifications++;
      });

      viewModel.setName('Alice');
      for (final digit in ['1', '2', '3', '4', '5']) {
        viewModel.addDigit(digit);
      }

      expect(viewModel.name, 'Alice');
      expect(viewModel.enteredPin, '1234');
      expect(viewModel.isPinComplete, isTrue);
      expect(viewModel.canRegister, isTrue);
      expect(notifications, 5);

      viewModel.removeDigit();

      expect(viewModel.enteredPin, '123');
      expect(viewModel.canRegister, isFalse);
    });

    test('does not register while the form is incomplete', () async {
      final service = PlayerService();
      final viewModel = PlayerRegisterViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      viewModel.setName('Alice');

      await viewModel.registerPlayer();

      expect(await service.getPlayers(), isEmpty);
    });

    test('registers a player with default difficulty settings', () async {
      final service = PlayerService();
      final viewModel = PlayerRegisterViewModel(playerService: service);
      addTearDown(viewModel.dispose);
      addTearDown(service.dispose);

      viewModel.setName('Alice');
      for (final digit in ['1', '2', '3', '4']) {
        viewModel.addDigit(digit);
      }

      await viewModel.registerPlayer();

      final players = await service.getPlayers();

      expect(players, hasLength(1));
      expect(players.single.id, isNotEmpty);
      expect(players.single.name, 'Alice');
      expect(players.single.pin, '1234');
      expect(players.single.playerSettings.difficulty, 1);
      expect(players.single.playerSettings.timelimit, 60);
    });
  });
}
