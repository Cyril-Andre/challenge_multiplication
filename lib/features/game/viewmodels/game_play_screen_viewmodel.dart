import 'dart:async';
import 'package:challengemultiplication/common/globals.dart';
import 'package:challengemultiplication/features/game/models/multiplication.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GamePlayViewModel extends ChangeNotifier {
  int? finalScore;
  late int timeRemaining;
  late int difficulty;
  Timer? _timer;
  final List<Multiplication> multiplications = [];
  final Map<int, int> errors = {};
  late int numberMultiplications;
  bool multiplicationsGenerated = false;
  void generateMultiplications() {
    multiplicationsGenerated = true;
    difficulty = Globals.difficulty;
    timeRemaining = Globals.timeLimit;
    numberMultiplications = switch (difficulty) { 1 => 15, 2 => 18, 3 => 20, _ => 18 };
    final Set<String> generatedPairs = {}; // Utilisation d'un Set pour éviter les doublons
    final random = Random();
    int i = 0;
    while (i < numberMultiplications) {
      int a = random.nextInt(7) + difficulty; // Selon la difficulté : 1 => Nombres entre 1 et 6, 2=> 2 et 8, 3 => 3 et 9
      int b = random.nextInt(7) + difficulty;
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
    finalScore = 0;
    errors.clear();
    for (Multiplication multiplication in multiplications) {
      if (multiplication.isCorrect) {
        finalScore = finalScore! + 1;
      } else {
        errors[multiplication.a] = (errors[multiplication.a] ?? 0) + 1;
        errors[multiplication.b] = (errors[multiplication.b] ?? 0) + 1;
      }
    }
    return finalScore!;
  }

  void resetGame() {
    timeRemaining = Globals.timeLimit;
    finalScore = null;
    multiplications.clear();
    errors.clear();
    generateMultiplications();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
