import 'package:flutter/material.dart';

class PlayerAuthViewModel extends ChangeNotifier {
  final String correctPin;
  final VoidCallback onSuccess;
  String _enteredPin = "";

  PlayerAuthViewModel({required this.correctPin, required this.onSuccess});

  String get enteredPin => _enteredPin;
  bool get isPinComplete => _enteredPin.length == 4;
  bool get hasError => _enteredPin.length == 4 && _enteredPin != correctPin;

  void addDigit(String digit) {
    if (_enteredPin.length < 4) {
      _enteredPin += digit;
      notifyListeners();

      if (_enteredPin.length == 4) {
        _validatePin();
      }
    }
  }

  void removeDigit() {
    if (_enteredPin.isNotEmpty) {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      notifyListeners();
    }
  }

  void _validatePin() {
    if (_enteredPin == correctPin) {
      onSuccess();
    }
    // L'erreur est gérée directement dans la UI en fonction de hasError
  }
}
