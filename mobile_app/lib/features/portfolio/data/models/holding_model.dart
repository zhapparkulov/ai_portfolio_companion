import '../../domain/entities/holding.dart';

/// Data-layer DTO. Extends the domain entity so mapping is free.
class HoldingModel extends Holding {
  const HoldingModel({
    required super.symbol,
    required super.name,
    required super.quantity,
    required super.avgPrice,
    required super.currentPrice,
    required super.dailyChangePercent,
  });

  factory HoldingModel.fromJson(Map<String, dynamic> json) => HoldingModel(
        symbol: json['symbol'] as String,
        name: json['name'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        avgPrice: (json['avg_price'] as num).toDouble(),
        currentPrice: (json['current_price'] as num).toDouble(),
        dailyChangePercent: (json['daily_change_percent'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'name': name,
        'quantity': quantity,
        'avg_price': avgPrice,
        'current_price': currentPrice,
        'daily_change_percent': dailyChangePercent,
      };
}
