import 'package:ai_portfolio_companion/core/error/failures.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/entities/portfolio.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/usecases/get_portfolio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns portfolio from repository', () async {
    final portfolio = _samplePortfolio();
    final useCase =
        GetPortfolio(_FakePortfolioRepository(portfolio: portfolio));

    final result = await useCase();

    expect(result.portfolio, portfolio);
    expect(result.failure, isNull);
  });

  test('returns failure from repository', () async {
    const failure = NetworkFailure('offline');
    const useCase = GetPortfolio(_FakePortfolioRepository(failure: failure));

    final result = await useCase();

    expect(result.portfolio, isNull);
    expect(result.failure, failure);
  });
}

class _FakePortfolioRepository implements PortfolioRepository {
  final Portfolio? portfolio;
  final Failure? failure;

  const _FakePortfolioRepository({this.portfolio, this.failure});

  @override
  Future<PortfolioResult> getPortfolio() async {
    return (failure: failure, portfolio: portfolio);
  }
}

Portfolio _samplePortfolio() {
  return const Portfolio(
    totalValue: 1000,
    dailyChange: 12,
    dailyChangePercent: 1.2,
    holdings: [],
  );
}
