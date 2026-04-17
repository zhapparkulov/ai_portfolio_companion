import '../models/portfolio_model.dart';

import 'portfolio_datasource.dart';

/// Mock data source. Stands in for a real remote data source while the
/// FastAPI backend is developed in parallel. The JSON contract matches
/// `GET /v1/portfolio` in docs/ARCHITECTURE.md §6, so when the real
/// data source lands the repository will not change.
class PortfolioMockDataSource implements PortfolioDataSource {
  @override
  Future<PortfolioModel> fetchPortfolio() async {
    // Simulate network latency so the UI loading state is exercised.
    await Future.delayed(const Duration(milliseconds: 600));
    return PortfolioModel.fromJson(_mockJson);
  }

  static const Map<String, dynamic> _mockJson = {
    'total_value': 124530.42,
    'daily_change': 1243.10,
    'daily_change_percent': 1.01,
    'holdings': [
      {
        'symbol': 'AAPL',
        'name': 'Apple Inc.',
        'quantity': 25,
        'avg_price': 150.22,
        'current_price': 189.50,
        'daily_change_percent': 0.82,
      },
      {
        'symbol': 'MSFT',
        'name': 'Microsoft Corp.',
        'quantity': 18,
        'avg_price': 280.10,
        'current_price': 412.35,
        'daily_change_percent': 1.45,
      },
      {
        'symbol': 'NVDA',
        'name': 'NVIDIA Corp.',
        'quantity': 12,
        'avg_price': 410.00,
        'current_price': 905.22,
        'daily_change_percent': 2.10,
      },
      {
        'symbol': 'TSLA',
        'name': 'Tesla Inc.',
        'quantity': 30,
        'avg_price': 220.15,
        'current_price': 182.40,
        'daily_change_percent': -1.22,
      },
      {
        'symbol': 'GOOGL',
        'name': 'Alphabet Inc.',
        'quantity': 15,
        'avg_price': 132.50,
        'current_price': 168.90,
        'daily_change_percent': 0.35,
      },
    ],
  };
}
