import '../../domain/entities/portfolio.dart';
import 'holding_model.dart';

class PortfolioModel extends Portfolio {
  const PortfolioModel({
    required super.totalValue,
    required super.dailyChange,
    required super.dailyChangePercent,
    required super.holdings,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => PortfolioModel(
        totalValue: (json['total_value'] as num).toDouble(),
        dailyChange: (json['daily_change'] as num).toDouble(),
        dailyChangePercent: (json['daily_change_percent'] as num).toDouble(),
        holdings: (json['holdings'] as List<dynamic>)
            .map((e) => HoldingModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
