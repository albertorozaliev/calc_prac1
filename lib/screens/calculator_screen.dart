
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../logic/calculator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();

  String selectedOperation = 'add';
  String? errorMessage;

  void calculate() {
    final firstText = firstController.text.trim().replaceAll(',', '.');
    final secondText = secondController.text.trim().replaceAll(',', '.');

    if (firstText.isEmpty || secondText.isEmpty) {
      setState(() {
        errorMessage = 'Заполните оба поля!';
      });
      return;
    }

    final firstNumber = double.tryParse(firstText);
    final secondNumber = double.tryParse(secondText);

    if (firstNumber == null || secondNumber == null) {
      setState(() {
        errorMessage = 'Введите корректные числа!';
      });
      return;
    }

    if (selectedOperation == 'divide' && secondNumber == 0) {
      setState(() {
        errorMessage = 'На ноль делить нельзя!';
      });
      return;
    }

    final result = Calculator.calculate(
      firstNumber,
      secondNumber,
      selectedOperation,
    );

    final formattedResult = double.parse(
      result.toStringAsFixed(6),
    );

    context.go(
      '/result?type=calculator'
      '&first=$firstNumber'
      '&second=$secondNumber'
      '&operation=$selectedOperation'
      '&result=$formattedResult',
    );
  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор'),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.calculate,
                  size: 65,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 25),

                TextField(
                  controller: firstController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Первое число',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 18),

                DropdownButtonFormField<String>(
                  value: selectedOperation,
                  decoration: const InputDecoration(
                    labelText: 'Операция',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'add',
                      child: Text('Сложение (+)'),
                    ),
                    DropdownMenuItem(
                      value: 'subtract',
                      child: Text('Вычитание (-)'),
                    ),
                    DropdownMenuItem(
                      value: 'multiply',
                      child: Text('Умножение (×)'),
                    ),
                    DropdownMenuItem(
                      value: 'divide',
                      child: Text('Деление (÷)'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedOperation = value;
                        errorMessage = null;
                      });
                    }
                  },
                ),

                const SizedBox(height: 18),

                TextField(
                  controller: secondController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Второе число',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 20),

                FilledButton.icon(
                  onPressed: calculate,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Вычислить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
