import 'package:ai_portfolio_companion/core/error/failures.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/entities/portfolio.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/repositories/portfolio_repository.dart';
import 'package:ai_portfolio_companion/features/portfolio/domain/usecases/get_portfolio.dart';
import 'package:ai_portfolio_companion/features/portfolio/presentation/cubit/portfolio_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  blocTest<PortfolioCubit, PortfolioState>(
    'emits loading then loaded when portfolio loads',
    build: () => PortfolioCubit(
      GetPortfolio(_FakePortfolioRepository(portfolio: _samplePortfolio())),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      const PortfolioLoading(),
      PortfolioLoaded(_samplePortfolio()),
    ],
  );

  blocTest<PortfolioCubit, PortfolioState>(
    'emits loading then error when repository fails',
    build: () => PortfolioCubit(
      const GetPortfolio(
        _FakePortfolioRepository(
          failure: NetworkFailure('offline'),
        ),
      ),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      const PortfolioLoading(),
      const PortfolioError('offline'),
    ],
  );
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
