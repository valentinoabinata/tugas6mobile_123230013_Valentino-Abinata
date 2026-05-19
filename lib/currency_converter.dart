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
    // Refactor: Mengubah return amountInBase * rates[to]!; menjadi dalam variabel result
    double result = amountInBase * rates[to]!; 

    // 3. Memastikan output rapi dengan maksimal 3 angka di belakang koma
    return double.parse(result.toStringAsFixed(3));
  }
}