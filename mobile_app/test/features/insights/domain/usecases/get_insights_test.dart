import 'package:ai_portfolio_companion/core/error/failures.dart';
import 'package:ai_portfolio_companion/features/insights/domain/entities/insight.dart';
import 'package:ai_portfolio_companion/features/insights/domain/entities/insight_severity.dart';
import 'package:ai_portfolio_companion/features/insights/domain/repositories/insights_repository.dart';
import 'package:ai_portfolio_companion/features/insights/domain/usecases/get_insights.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns insights from repository', () async {
    final insights = [_sampleInsight()];
    const failure = null;
    final useCase = GetInsights(
      _FakeInsightsRepository(insights: insights, failure: failure),
    );

    final result = await useCase();

    expect(result.insights, insights);
    expect(result.failure, isNull);
  });

  test('returns failure from repository', () async {
    const failure = NetworkFailure('offline');
    const useCase = GetInsights(_FakeInsightsRepository(failure: failure));

    final result = await useCase();

    expect(result.insights, isNull);
    expect(result.failure, failure);
  });
}

class _FakeInsightsRepository implements InsightsRepository {
  final List<Insight>? insights;
  final Failure? failure;

  const _FakeInsightsRepository({
    this.insights,
    this.failure,
  });

  @override
  Future<InsightsResult> getInsights() async {
    return (failure: failure, insights: insights);
  }
}

Insight _sampleInsight() {
  return const Insight(
    title: 'Risk',
    body: 'Reduce concentration.',
    severity: InsightSeverity.risk,
  );
}
