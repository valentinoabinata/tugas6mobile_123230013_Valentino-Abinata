class CurrencyConverter {
  final Map<String, double> rates;

  CurrencyConverter({required this.rates});

  double convert({required double amount, required String from, required String to}) {
    // 1. Cek apakah mata uang ada di database mockRates
    if (!rates.containsKey(from) || !rates.containsKey(to)) {
      throw ArgumentError('Mata uang tidak didukung');
    }

    // 2. Lakukan perhitungan konversi via Base Currency (USD)
    double amountInBase = amount / rates[from]!;
    return amountInBase * rates[to]!;
  }
}