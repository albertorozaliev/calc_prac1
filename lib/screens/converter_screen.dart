
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic/currency.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController amountController = TextEditingController();

  String fromCurrency = 'USD';
  String toCurrency = 'RUB';

  String? errorMessage;


@override
void initState() {
  super.initState();
  loadCurrencies();
}

Future<void> loadCurrencies() async {
  final prefs = await SharedPreferences.getInstance();

  final savedFrom = prefs.getString('from_currency') ?? 'USD';
  final savedTo = prefs.getString('to_currency') ?? 'RUB';

  if (!Currency.rates.containsKey(savedFrom) ||
      !Currency.rates.containsKey(savedTo)) {
    return;
  }

  if (!mounted) return;

  setState(() {
    fromCurrency = savedFrom;
    toCurrency = savedTo;
  });
}

Future<void> saveCurrencies() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('from_currency', fromCurrency);
  await prefs.setString('to_currency', toCurrency);
}


  void convertCurrency() {
    final text = amountController.text.trim().replaceAll(',', '.');

    if (text.isEmpty) {
      setState(() {
        errorMessage = 'Введите сумму!';
      });
      return;
    }

    final amount = double.tryParse(text);

    if (amount == null || !amount.isFinite || amount < 0) {
      setState(() {
        errorMessage = 'Введите корректную сумму!';
      });
      return;
    }

    if (fromCurrency == toCurrency) {
      setState(() {
        errorMessage = 'Выберите разные валюты!';
      });
      return;
    }

    final result = Currency.convert(
      amount,
      fromCurrency,
      toCurrency,
    );

    final formattedResult = result.toStringAsFixed(2);

    final uri = Uri(
      path: '/result',
      queryParameters: {
        'type': 'currency',
        'amount': amount.toString(),
        'from': fromCurrency,
        'to': toCurrency,
        'result': formattedResult,
      },
    );

    context.go(uri.toString());
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Конвертер валют'),
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
                  Icons.currency_exchange,
                  size: 65,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Сумма',
                    hintText: 'Например, 100',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.payments),
                  ),
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: fromCurrency,
                  decoration: const InputDecoration(
                    labelText: 'Из какой валюты',
                    border: OutlineInputBorder(),
                  ),
                  items: Currency.names.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text('${entry.key} — ${entry.value}'),
                    );
                  }).toList(),
                 onChanged: (value) {
  if (value != null) {
    setState(() {
      fromCurrency = value;
      errorMessage = null;
    });

    saveCurrencies();
  }
},
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: toCurrency,
                  decoration: const InputDecoration(
                    labelText: 'В какую валюту',
                    border: OutlineInputBorder(),
                  ),
                  items: Currency.names.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text('${entry.key} — ${entry.value}'),
                    );
                  }).toList(),
                  onChanged: (value) {
  if (value != null) {
    setState(() {
      fromCurrency = value;
      errorMessage = null;
    });

    saveCurrencies();
  }
},
                ),

                const SizedBox(height: 20),

                if (errorMessage != null)
                  Text(
                    errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),

                const SizedBox(height: 20),

                FilledButton.icon(
                  onPressed: convertCurrency,
                  icon: const Icon(Icons.currency_exchange),
                  label: const Text('Конвертировать'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
