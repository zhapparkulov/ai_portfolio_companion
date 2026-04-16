import 'package:ai_portfolio_companion/core/error/exceptions.dart';
import 'package:ai_portfolio_companion/core/error/failures.dart';
import 'package:ai_portfolio_companion/features/portfolio/data/datasources/portfolio_datasource.dart';
import 'package:ai_portfolio_companion/features/portfolio/data/models/portfolio_model.dart';
import 'package:ai_portfolio_companion/features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns portfolio when data source succeeds', () async {
    final repository = PortfolioRepositoryImpl(_SuccessDataSource());

    final result = await repository.getPortfolio();

    expect(result.failure, isNull);
    expect(result.portfolio?.totalValue, 1000);
    expect(result.portfolio?.holdings.single.symbol, 'AAPL');
  });

  test('maps NetworkException to NetworkFailure', () async {
    final repository = PortfolioRepositoryImpl(
      _ThrowingDataSource(NetworkException('offline')),
    );

    final result = await repository.getPortfolio();

    expect(result.portfolio, isNull);
    expect(result.failure, const NetworkFailure('offline'));
  });

  test('maps ServerException to ServerFailure', () async {
    final repository = PortfolioRepositoryImpl(
      _ThrowingDataSource(ServerException('bad gateway')),
    );

    final result = await repository.getPortfolio();

    expect(result.portfolio, isNull);
    expect(result.failure, const ServerFailure('bad gateway'));
  });
}

class _SuccessDataSource implements PortfolioDataSource {
  @override
  Future<PortfolioModel> fetchPortfolio() async {
    return PortfolioModel.fromJson(const {
      'total_value': 1000,
      'daily_change': 12,
      'daily_change_percent': 1.2,
      'holdings': [
        {
          'symbol': 'AAPL',
          'name': 'Apple Inc.',
          'quantity': 2,
          'avg_price': 100,
          'current_price': 150,
          'daily_change_percent': 0.8,
        },
      ],
    });
  }
}

class _ThrowingDataSource implements PortfolioDataSource {
  final Object error;

  _ThrowingDataSource(this.error);

  @override
  Future<PortfolioModel> fetchPortfolio() async {
    throw error;
  }
}
