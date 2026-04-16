import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/insights_repository.dart';
import '../datasources/insights_datasource.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsDataSource _dataSource;

  const InsightsRepositoryImpl(this._dataSource);

  @override
  Future<InsightsResult> getInsights() async {
    try {
      final insights = await _dataSource.fetchInsights();
      return (failure: null, insights: insights);
    } on NetworkException catch (error) {
      return (failure: NetworkFailure(error.message), insights: null);
    } on ServerException catch (error) {
      return (failure: ServerFailure(error.message), insights: null);
    } catch (_) {
      return (failure: const UnknownFailure(), insights: null);
    }
  }
}
