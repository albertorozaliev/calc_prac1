
class Currency {
  static const Map<String, double> rates = {
    'RUB': 1.0,
    'USD': 90.0,
    'EUR': 98.0,
    'GBP': 115.0,
    'CNY': 12.5,
  };

  static const Map<String, String> names = {
    'RUB': 'Российский рубль',
    'USD': 'Доллар США',
    'EUR': 'Евро',
    'GBP': 'Фунт стерлингов',
    'CNY': 'Китайский юань',
  };

  static double convert(
    double amount,
    String from,
    String to,
  ) {
    if (amount < 0) {
      throw Exception('Сумма не может быть отрицательной');
    }

    if (!rates.containsKey(from) || !rates.containsKey(to)) {
      throw Exception('Неизвестная валюта');
    }

    // Сначала переводим сумму в рубли,
    // затем из рублей в выбранную валюту.
    final amountInRubles = amount * rates[from]!;

    return amountInRubles / rates[to]!;
  }
}
