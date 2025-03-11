import 'dart:async';
import 'package:challenge_multiplication/features/game/models/multiplication.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GamePlayViewModel extends ChangeNotifier {
  int? finalScore;
  int timeRemaining = 60;
  Timer? _timer;
  final List<Multiplication> multiplications = [];

  GamePlayViewModel() {
    generateMultiplications();
  }

  void generateMultiplications() {
    final Set<String> generatedPairs = {}; // Utilisation d'un Set pour éviter les doublons
    final random = Random();
    int i = 0;
    while (i < 20) {
      int a = random.nextInt(7) + 3; // Nombres entre 3 et 9
      int b = random.nextInt(7) + 3;
      String pairKey = "$a-$b"; // Nombres entre 1 et 10
      if (!generatedPairs.contains(pairKey)) {
        multiplications.add(Multiplication(a, b));
        generatedPairs.add(pairKey);
        i++;
      }
    }
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining > 0) {
        timeRemaining--;
        Future.microtask(() => notifyListeners()); // Empêche les erreurs pendant le build
      } else {
        timer.cancel();
      }
    });
  }

  void setAnswer(int index, String value) {
    if (index >= 0 && index < multiplications.length) {
      multiplications[index].userAnswer = value;
      calculateFinalScore();
    }
    if (index >= 0 && index < multiplications.length) {
      multiplications[index].userAnswer = value;
    }
  }

  int calculateFinalScore() {
    finalScore = multiplications.where((m) => m.isCorrect).length;
    debugPrint("finalScore = $finalScore");
    return finalScore ?? 0;
  }
void resetGame() {
  timeRemaining = 60;
  finalScore = null;
  multiplications.clear();
  generateMultiplications();
  notifyListeners();
}
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
