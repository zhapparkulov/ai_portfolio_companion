import '../repositories/portfolio_repository.dart';

/// Single-responsibility use case: fetch the current portfolio snapshot.
/// Kept intentionally thin — validation/transform logic goes here when needed.
class GetPortfolio {
  final PortfolioRepository _repository;

  GetPortfolio(this._repository);

  Future<PortfolioResult> call() => _repository.getPortfolio();
}
