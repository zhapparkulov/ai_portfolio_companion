import 'package:intl/intl.dart';

/// Centralised formatters so UI never rolls its own.
class Formatters {
  Formatters._();

  static final NumberFormat _currency =
      NumberFormat.currency(locale: 'en_US', symbol: r'$');

  static final NumberFormat _percent = NumberFormat.decimalPattern('en_US')
    ..minimumFractionDigits = 2;

  static String currency(double value) => _currency.format(value);

  static String percent(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${_percent.format(value)}%';
  }
}
