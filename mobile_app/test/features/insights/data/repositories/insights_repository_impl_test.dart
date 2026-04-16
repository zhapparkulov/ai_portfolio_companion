import 'package:ai_portfolio_companion/core/error/exceptions.dart';
import 'package:ai_portfolio_companion/core/error/failures.dart';
import 'package:ai_portfolio_companion/features/insights/data/datasources/insights_datasource.dart';
import 'package:ai_portfolio_companion/features/insights/data/models/insight_model.dart';
import 'package:ai_portfolio_companion/features/insights/data/repositories/insights_repository_impl.dart';
import 'package:ai_portfolio_companion/features/insights/domain/entities/insight_severity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns insights when data source succeeds', () async {
    final repository = InsightsRepositoryImpl(_SuccessDataSource());

    final result = await repository.getInsights();

    expect(result.failure, isNull);
    expect(result.insights?.single.title, 'Risk');
    expect(result.insights?.single.severity, InsightSeverity.risk);
  });

  test('maps NetworkException to NetworkFailure', () async {
    final repository = InsightsRepositoryImpl(
      _ThrowingDataSource(NetworkException('offline')),
    );

    final result = await repository.getInsights();

    expect(result.insights, isNull);
    expect(result.failure, const NetworkFailure('offline'));
  });

  test('maps ServerException to ServerFailure', () async {
    final repository = InsightsRepositoryImpl(
      _ThrowingDataSource(ServerException('bad gateway')),
    );

    final result = await repository.getInsights();

    expect(result.insights, isNull);
    expect(result.failure, const ServerFailure('bad gateway'));
  });
}

class _SuccessDataSource implements InsightsDataSource {
  @override
  Future<List<InsightModel>> fetchInsights() async {
    return [
      InsightModel.fromJson(const {
        'title': 'Risk',
        'body': 'Reduce concentration.',
        'severity': 'risk',
      }),
    ];
  }
}

class _ThrowingDataSource implements InsightsDataSource {
  final Object error;

  _ThrowingDataSource(this.error);

  @override
  Future<List<InsightModel>> fetchInsights() async {
    throw error;
  }
}
