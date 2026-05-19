import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tugas6mobile_123230013_valentinoabinata/currency_converter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Currency Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          background: const Color(0xFFF3F4F6),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final String exchangeRateApiKey = 'd0b43d16288820adc0e90f0e';
  final String exchangeRateBaseUrl = 'https://v6.exchangerate-api.com/v6';

  // Daftar mata uang dari API ditampilkan 
  final List<String> importantCurrencies = [
    'USD', 'IDR', 'EUR', 'SGD', 'MYR', 'JPY', 'KRW', 'GBP', 'AUD', 'CNY', 'SAR'
  ];

  CurrencyConverter? converter;
  Map<String, double> realRates = {};
  bool isLoading = true;
  String errorMessage = '';

  final TextEditingController amountController = TextEditingController();
  String fromCurrency = 'USD';
  String toCurrency = 'IDR';
  String resultText = '0.000';

  @override
  void initState() {
    super.initState();
    amountController.text = '1';
    fetchRatesFromApi();
  }

  Future<void> fetchRatesFromApi() async {
    try {
      final url = Uri.parse('$exchangeRateBaseUrl/$exchangeRateApiKey/latest/USD');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> ratesData = data['conversion_rates'];
        
        ratesData.forEach((key, value) {
          if (importantCurrencies.contains(key)) {
            realRates[key] = (value as num).toDouble();
          }
        });

        setState(() {
          converter = CurrencyConverter(rates: realRates);
          isLoading = false;
        });
        
        calculateConversion();
      } else {
        setState(() {
          errorMessage = 'Gagal mengambil data server.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Tidak ada koneksi internet.';
        isLoading = false;
      });
    }
  }

  void calculateConversion() {
    if (converter == null) return;
    
    if (amountController.text.isEmpty) {
      setState(() => resultText = '0.00');
      return;
    }

    double? inputAmount = double.tryParse(amountController.text);
    if (inputAmount == null) return;

    try {
      double result = converter!.convert(
        amount: inputAmount,
        from: fromCurrency,
        to: toCurrency,
      );
      
      setState(() {
        resultText = result.toStringAsFixed(3);
      });
    } catch (e) {
      setState(() => resultText = 'Error');
    }
  }

  void swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
    });
    calculateConversion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Currency Exchange',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? _buildErrorState()
              : _buildMainUI(),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(errorMessage, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() => isLoading = true);
              fetchRatesFromApi();
            },
            child: const Text('Coba Lagi'),
          )
        ],
      ),
    );
  }

  Widget _buildMainUI() {
    final List<String> currencies = realRates.keys.toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            // Card Input (Pengirim)
            _buildCurrencyCard(
              label: 'You Send',
              currencyValue: fromCurrency,
              currencies: currencies,
              onCurrencyChanged: (val) {
                setState(() => fromCurrency = val!);
                calculateConversion();
              },
              child: TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) => calculateConversion(),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: '0.000',
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Tombol Swap
            InkWell(
              onTap: swapCurrencies,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.swap_vert, color: Colors.white, size: 32),
              ),
            ),

            const SizedBox(height: 24),

            // Card Output (Penerima)
            _buildCurrencyCard(
              label: 'You Get',
              currencyValue: toCurrency,
              currencies: currencies,
              onCurrencyChanged: (val) {
                setState(() => toCurrency = val!);
                calculateConversion();
              },
              child: Text(
                resultText,
                style: const TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F46E5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyCard({
    required String label,
    required String currencyValue,
    required List<String> currencies,
    required ValueChanged<String?> onCurrencyChanged,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: child),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currencyValue,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 22),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                    items: currencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: onCurrencyChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}