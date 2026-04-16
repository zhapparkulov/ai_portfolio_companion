import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_remote_datasource.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioRemoteDataSource _dataSource;

  PortfolioRepositoryImpl(this._dataSource);

  @override
  Future<PortfolioResult> getPortfolio() async {
    try {
      final model = await _dataSource.fetchPortfolio();
      return (failure: null, portfolio: model);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), portfolio: null);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message), portfolio: null);
    } catch (_) {
      return (failure: const UnknownFailure(), portfolio: null);
    }
  }
}
