import 'package:equatable/equatable.dart';

import 'holding.dart';

/// Aggregate domain entity representing the user's portfolio snapshot.
class Portfolio extends Equatable {
  final double totalValue;
  final double dailyChange;
  final double dailyChangePercent;
  final List<Holding> holdings;

  const Portfolio({
    required this.totalValue,
    required this.dailyChange,
    required this.dailyChangePercent,
    required this.holdings,
  });

  @override
  List<Object?> get props =>
      [totalValue, dailyChange, dailyChangePercent, holdings];
}
