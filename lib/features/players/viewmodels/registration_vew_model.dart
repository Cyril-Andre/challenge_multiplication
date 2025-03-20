import 'package:challenge_multiplication/features/players/models/player.dart';
import 'package:challenge_multiplication/features/players/services/player_service.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PlayerRegisterViewModel extends ChangeNotifier {
  String _name = "";
  String _enteredPin = "";

  String get name => _name;
  String get enteredPin => _enteredPin;
  bool get isPinComplete => _enteredPin.length == 4;
  bool get canRegister => _name.isNotEmpty && _enteredPin.length == 4;
  final PlayerService playerService;

  PlayerRegisterViewModel({required this.playerService});

  void setName(String value) {
    _name = value;
    notifyListeners();
  }

  void addDigit(String digit) {
    if (_enteredPin.length < 4) {
      _enteredPin += digit;
      notifyListeners();
    }
  }

  void removeDigit() {
    if (_enteredPin.isNotEmpty) {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      notifyListeners();
    }
  }

  Future<void> registerPlayer() async {
    if (!canRegister) return;

    final player = Player(id: const Uuid().v4(), name: _name, pin: _enteredPin, settings: {"difficulty": 1}, history: []);
    playerService.addPlayer(player);    
    notifyListeners();
  }
}
