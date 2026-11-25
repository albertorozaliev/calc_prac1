
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';
import '../logic/currency.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final params = GoRouterState.of(context).uri.queryParameters;

    String? error;
    double? result;
    String? description;
    String? title;

    try {
      final type = params['type'];
      final resultText = params['result'];

      if (resultText == null) {
        throw Exception('Отсутствует результат в URL');
      }

      final urlResult = double.tryParse(resultText);

      if (urlResult == null || !urlResult.isFinite) {
        throw Exception('Некорректный результат');
      }

      if (type == 'calculator') {
        final firstText = params['first'];
        final secondText = params['second'];
        final operation = params['operation'];

        if (firstText == null ||
            secondText == null ||
            operation == null) {
          throw Exception('Не хватает параметров калькулятора');
        }

        final first = double.tryParse(firstText);
        final second = double.tryParse(secondText);

        if (first == null ||
            second == null ||
            !first.isFinite ||
            !second.isFinite) {
          throw Exception('Некорректные числа');
        }

        final calculated = Calculator.calculate(
          first,
          second,
          operation,
        );

        if (!calculated.isFinite ||
            (calculated - urlResult).abs() > 0.000001) {
          throw Exception('Результат не соответствует вычислению');
        }

        final operationName = switch (operation) {
          'add' => 'Сложение (+)',
          'subtract' => 'Вычитание (-)',
          'multiply' => 'Умножение (×)',
          'divide' => 'Деление (÷)',
          _ => throw Exception('Неизвестная операция'),
        };

        title = 'Результат вычисления';
        description =
            '$first $operationName $second';
        result = urlResult;
      } else if (type == 'currency') {
        final amountText = params['amount'];
        final from = params['from'];
        final to = params['to'];

        if (amountText == null || from == null || to == null) {
          throw Exception('Не хватает параметров конвертера');
        }

        final amount = double.tryParse(amountText);

        if (amount == null || !amount.isFinite || amount < 0) {
          throw Exception('Некорректная сумма');
        }

        if (from == to) {
          throw Exception('Валюты должны различаться');
        }

        final calculated = Currency.convert(amount, from, to);

        if (!calculated.isFinite ||
            (calculated - urlResult).abs() > 0.005) {
          throw Exception('Результат конвертации некорректен');
        }

        title = 'Результат конвертации';
        description =
            '${amount.toStringAsFixed(2)} $from → $to';
        result = urlResult;
      } else {
        throw Exception('Неизвестный тип результата');
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: error != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 70,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 25),
                      FilledButton(
                        onPressed: () => context.go('/'),
                        child: const Text('На главную'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 75,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        title!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        result!.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 30),
                      FilledButton.icon(
                        onPressed: () => context.go(
                          params['type'] == 'currency'
                              ? '/converter'
                              : '/calculator',
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Новый расчёт'),
                      ),
                      TextButton(
                        onPressed: () => context.go('/'),
                        child: const Text('На главную'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
