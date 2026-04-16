import '../repositories/insights_repository.dart';

class GetInsights {
  final InsightsRepository _repository;

  const GetInsights(this._repository);

  Future<InsightsResult> call() {
    return _repository.getInsights();
  }
}
