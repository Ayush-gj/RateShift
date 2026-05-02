class CurrencyRates {
  final double amount;
  final String base;
  final String date;
  final Map<String, dynamic> rates;

  CurrencyRates({
    required this.amount,
    required this.base,
    required this.date,
    required this.rates,
  });

  factory CurrencyRates.fromJson(Map<String, dynamic> json) {
    return CurrencyRates(
      amount: (json['amount'] as num).toDouble(),
      base: json['base'],
      date: json['date'],
      rates: json['rates'],
    );
  }
}