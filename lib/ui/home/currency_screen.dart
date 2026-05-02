import 'package:flutter/material.dart';
import '../../data/services/api_service.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  // Pre-loaded full list so it works instantly even if the API is slow
  List<String> currencies = [
    'USD', 'EUR', 'GBP', 'INR', 'JPY', 'AUD', 'CAD', 'CHF', 'CNY',
    'NZD', 'ZAR', 'SGD', 'HKD', 'SEK', 'KRW', 'NOK', 'MXN', 'BRL'
  ];
  String fromCurrency = 'USD';
  String toCurrency = 'INR';
  String result = '0.00';
  bool isLoading = false;
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  void _loadCurrencies() async {
    try {
      var fetched = await ApiService.getCurrencies();
      setState(() => currencies = fetched);
    } catch (e) {
      // Keep using default list if API fails
    }
  }

  void _convert() async {
    if (amountController.text.isEmpty) return;
    FocusScope.of(context).unfocus(); // Close keyboard
    setState(() => isLoading = true);

    try {
      double amount = double.parse(amountController.text.replaceAll(',', '.'));
      double converted = await ApiService.convertCurrency(fromCurrency, toCurrency, amount);
      setState(() {
        result = converted.toStringAsFixed(2);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid number or network error')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      result = '0.00';
    });
    _convert();
  }

  // --- NEW FEATURE: Shows the Currency Dictionary ---
  void _showCurrencyDictionary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return CurrencyDictionarySheet(scrollController: scrollController);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, spreadRadius: 5)],
            ),
            child: Column(
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  // SMOOTHER TEXT: Adjusted font weights and letter spacing
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, letterSpacing: 1.2, color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                    border: InputBorder.none,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDropdown(fromCurrency, (val) => setState(() => fromCurrency = val!)),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.swap_horiz, color: Theme.of(context).colorScheme.secondary, size: 28),
                        onPressed: _swapCurrencies,
                      ),
                    ),
                    _buildDropdown(toCurrency, (val) => setState(() => toCurrency = val!)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // NEW FEATURE BUTTON: Opens the Dictionary
          Center(
            child: TextButton.icon(
              onPressed: _showCurrencyDictionary,
              icon: Icon(Icons.menu_book_rounded, size: 20, color: Theme.of(context).colorScheme.secondary),
              label: Text(
                'Currency Guide',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: isLoading
                ? CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary)
                : Text(
              result,
              // SMOOTHER TEXT: w800 instead of w900, added letter spacing
              style: TextStyle(fontSize: 54, fontWeight: FontWeight.w800, letterSpacing: 1.0, color: Theme.of(context).colorScheme.secondary),
            ),
          ),
          Center(
            child: Text(
              toCurrency,
              style: const TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 1.0),
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 5,
              ),
              onPressed: _convert,
              child: const Text('CONVERT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDropdown(String value, void Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        dropdownColor: Theme.of(context).colorScheme.surface,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
        items: currencies.map((String cur) {
          return DropdownMenuItem(value: cur, child: Text(cur));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}

// --- NEW CLASS: The Searchable Dictionary Bottom Sheet ---
class CurrencyDictionarySheet extends StatefulWidget {
  final ScrollController scrollController;
  const CurrencyDictionarySheet({super.key, required this.scrollController});

  @override
  State<CurrencyDictionarySheet> createState() => _CurrencyDictionarySheetState();
}

class _CurrencyDictionarySheetState extends State<CurrencyDictionarySheet> {
  String searchQuery = '';

  // Hardcoded dictionary of common global currencies
  final List<Map<String, String>> dictionary = [
    {'code': 'USD', 'name': 'US Dollar', 'country': 'United States 🇺🇸'},
    {'code': 'EUR', 'name': 'Euro', 'country': 'European Union 🇪🇺'},
    {'code': 'GBP', 'name': 'British Pound', 'country': 'United Kingdom 🇬🇧'},
    {'code': 'INR', 'name': 'Indian Rupee', 'country': 'India 🇮🇳'},
    {'code': 'JPY', 'name': 'Japanese Yen', 'country': 'Japan 🇯🇵'},
    {'code': 'AUD', 'name': 'Australian Dollar', 'country': 'Australia 🇦🇺'},
    {'code': 'CAD', 'name': 'Canadian Dollar', 'country': 'Canada 🇨🇦'},
    {'code': 'CHF', 'name': 'Swiss Franc', 'country': 'Switzerland 🇨🇭'},
    {'code': 'CNY', 'name': 'Chinese Yuan', 'country': 'China 🇨🇳'},
    {'code': 'NZD', 'name': 'New Zealand Dollar', 'country': 'New Zealand 🇳🇿'},
    {'code': 'ZAR', 'name': 'South African Rand', 'country': 'South Africa 🇿🇦'},
    {'code': 'SGD', 'name': 'Singapore Dollar', 'country': 'Singapore 🇸🇬'},
    {'code': 'HKD', 'name': 'Hong Kong Dollar', 'country': 'Hong Kong 🇭🇰'},
    {'code': 'SEK', 'name': 'Swedish Krona', 'country': 'Sweden 🇸🇪'},
    {'code': 'KRW', 'name': 'South Korean Won', 'country': 'South Korea 🇰🇷'},
    {'code': 'NOK', 'name': 'Norwegian Krone', 'country': 'Norway 🇳🇴'},
    {'code': 'MXN', 'name': 'Mexican Peso', 'country': 'Mexico 🇲🇽'},
    {'code': 'BRL', 'name': 'Brazilian Real', 'country': 'Brazil 🇧🇷'},
    {'code': 'AED', 'name': 'UAE Dirham', 'country': 'United Arab Emirates 🇦🇪'},
    {'code': 'SAR', 'name': 'Saudi Riyal', 'country': 'Saudi Arabia 🇸🇦'},
  ];

  @override
  Widget build(BuildContext context) {
    // Filter logic based on the search box
    final filteredList = dictionary.where((item) {
      final query = searchQuery.toLowerCase();
      return item['code']!.toLowerCase().contains(query) ||
          item['name']!.toLowerCase().contains(query) ||
          item['country']!.toLowerCase().contains(query);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Drag handle pill
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            'Currency Guide',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Search Box
          TextField(
            onChanged: (value) => setState(() => searchQuery = value),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
            decoration: InputDecoration(
              hintText: 'Search country or code...',
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // The scrollable list of currencies
          Expanded(
            child: ListView.separated(
              controller: widget.scrollController,
              itemCount: filteredList.length,
              separatorBuilder: (context, index) => Divider(color: Colors.grey.withValues(alpha: 0.1)),
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return ListTile(
                  title: Text(
                    item['country']!,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.3),
                  ),
                  subtitle: Text(
                    item['name']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['code']!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}