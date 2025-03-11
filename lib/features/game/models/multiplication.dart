class Multiplication {
  bool get isCorrect => userAnswer != null && int.tryParse(userAnswer!) == (a * b);
  final int a;
  final int b;
  String? userAnswer;

  Multiplication(this.a, this.b);
}
