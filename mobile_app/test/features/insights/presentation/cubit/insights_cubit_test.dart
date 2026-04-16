import 'package:ai_portfolio_companion/core/error/failures.dart';
import 'package:ai_portfolio_companion/features/insights/domain/entities/insight.dart';
import 'package:ai_portfolio_companion/features/insights/domain/entities/insight_severity.dart';
import 'package:ai_portfolio_companion/features/insights/domain/repositories/insights_repository.dart';
import 'package:ai_portfolio_companion/features/insights/domain/usecases/get_insights.dart';
import 'package:ai_portfolio_companion/features/insights/presentation/cubit/insights_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  blocTest<InsightsCubit, InsightsState>(
    'emits loading then loaded when insights load',
    build: () => InsightsCubit(
      GetInsights(_FakeInsightsRepository(insights: [_sampleInsight()])),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      const InsightsLoading(),
      InsightsLoaded([_sampleInsight()]),
    ],
  );

  blocTest<InsightsCubit, InsightsState>(
    'emits loading then empty when repository returns no insights',
    build: () => InsightsCubit(
      const GetInsights(_FakeInsightsRepository(insights: [])),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      const InsightsLoading(),
      const InsightsEmpty(),
    ],
  );

  blocTest<InsightsCubit, InsightsState>(
    'emits loading then error when repository fails',
    build: () => InsightsCubit(
      const GetInsights(
        _FakeInsightsRepository(failure: NetworkFailure('offline')),
      ),
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      const InsightsLoading(),
      const InsightsError('offline'),
    ],
  );
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
