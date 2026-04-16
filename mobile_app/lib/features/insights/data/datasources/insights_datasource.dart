import '../models/insight_model.dart';

abstract class InsightsDataSource {
  Future<List<InsightModel>> fetchInsights();
}
