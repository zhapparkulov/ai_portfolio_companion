import '../../../../core/error/failures.dart';
import '../entities/insight.dart';

typedef InsightsResult = ({Failure? failure, List<Insight>? insights});

abstract class InsightsRepository {
  Future<InsightsResult> getInsights();
}
