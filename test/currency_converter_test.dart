import 'package:flutter_test/flutter_test.dart';
import 'package:tugas6mobile_123230013_valentinoabinata/currency_converter.dart'; 

void main() {
  group('CurrencyConverter Tests', () {
    // Dummy exchange rates untuk pengujian
    final Map<String, double> mockRates = {
      'USD': 1.0,
      'IDR': 15000.0,
      'EUR': 0.9,
      'JPY': 150.0,
    };

    final converter = CurrencyConverter(rates: mockRates);

    test('Konversi dari Base (USD) ke mata uang lain (IDR)', () {
      double result = converter.convert(amount: 10, from: 'USD', to: 'IDR');
      expect(result, 150000.0);
    });

    test('Konversi antar mata uang non-Base (IDR ke EUR)', () {
      double result = converter.convert(amount: 150000, from: 'IDR', to: 'EUR');
      expect(result, 9.0);
    });

    test('Melempar Exception jika mata uang tidak didukung/tidak ada di rates', () {
      expect(
        () => converter.convert(amount: 100, from: 'IDR', to: 'GBP'),
        throwsArgumentError,
      );
    });
  });
}