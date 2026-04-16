import '../../../../core/error/failures.dart';
import '../entities/portfolio.dart';

/// Result record — lightweight alternative to Either/dartz.
/// Exactly one of (failure, portfolio) is non-null.
typedef PortfolioResult = ({Failure? failure, Portfolio? portfolio});

/// Repository contract. Implementations live in the data layer.
abstract class PortfolioRepository {
  Future<PortfolioResult> getPortfolio();
}
