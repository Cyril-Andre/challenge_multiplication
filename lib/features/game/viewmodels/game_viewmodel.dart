import 'dart:async';
import 'package:flutter/material.dart';

class GameViewModel extends ChangeNotifier {
  int countdown = 10;
  Timer? _timer;
  VoidCallback? onCountdownEnd;

  void startCountdown(VoidCallback callback) {
    countdown = 10;
    onCountdownEnd = callback;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
        notifyListeners();
      } else {
        timer.cancel();
        notifyListeners();
        onCountdownEnd?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
