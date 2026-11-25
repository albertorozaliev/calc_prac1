
class Calculator {
  static double calculate(
    double firstNumber,
    double secondNumber,
    String operation,
  ) {
    switch (operation) {
      case 'add':
        return firstNumber + secondNumber;

      case 'subtract':
        return firstNumber - secondNumber;

      case 'multiply':
        return firstNumber * secondNumber;

      case 'divide':
        if (secondNumber == 0) {
          throw Exception('На ноль делить нельзя!');
        }
        return firstNumber / secondNumber;

      default:
        throw Exception('Неизвестная операция');
    }
  }
}
