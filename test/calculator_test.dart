
import 'package:flutter_test/flutter_test.dart';

import '../lib/logic/calculator.dart';
import '../lib/logic/currency.dart';

void main() {
  group('Тестирование калькулятора', () {
    test('Сложение двух чисел', () {
      final result = Calculator.calculate(10, 5, 'add');

      expect(result, 15);
    });

    test('Вычитание двух чисел', () {
      final result = Calculator.calculate(10, 5, 'subtract');

      expect(result, 5);
    });

    test('Умножение двух чисел', () {
      final result = Calculator.calculate(10, 5, 'multiply');

      expect(result, 50);
    });

    test('Деление двух чисел', () {
      final result = Calculator.calculate(10, 5, 'divide');

      expect(result, 2);
    });

    test('Деление на ноль вызывает ошибку', () {
      expect(
        () => Calculator.calculate(10, 0, 'divide'),
        throwsException,
      );
    });

    test('Неизвестная операция вызывает ошибку', () {
      expect(
        () => Calculator.calculate(10, 5, 'unknown'),
        throwsException,
      );
    });
  });

  group('Тестирование конвертера валют', () {
    test('Перевод долларов в рубли', () {
      final result = Currency.convert(100, 'USD', 'RUB');

      expect(result, 9000);
    });

    test('Перевод евро в доллары', () {
  final result = Currency.convert(100, 'EUR', 'USD');

  expect(result, closeTo(108.89, 0.01));
});

    test('Неизвестная валюта вызывает ошибку', () {
      expect(
        () => Currency.convert(100, 'ABC', 'RUB'),
        throwsException,
      );
    });

    test('Отрицательная сумма вызывает ошибку', () {
      expect(
        () => Currency.convert(-100, 'USD', 'RUB'),
        throwsException,
      );
    });
  });
}
