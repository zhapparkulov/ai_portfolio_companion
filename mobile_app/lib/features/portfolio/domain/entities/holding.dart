import 'package:equatable/equatable.dart';

/// Pure domain entity for a single holding. No JSON, no Flutter.
class Holding extends Equatable {
  final String symbol;
  final String name;
  final double quantity;
  final double avgPrice;
  final double currentPrice;
  final double dailyChangePercent;

  const Holding({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.avgPrice,
    required this.currentPrice,
    required this.dailyChangePercent,
  });

  double get value => quantity * currentPrice;

  @override
  List<Object?> get props => [
        symbol,
        name,
        quantity,
        avgPrice,
        currentPrice,
        dailyChangePercent,
      ];
}
