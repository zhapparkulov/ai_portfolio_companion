import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/insight_model.dart';
import 'insights_datasource.dart';

class InsightsRemoteDataSource implements InsightsDataSource {
  final Dio _dio;

  const InsightsRemoteDataSource(this._dio);

  @override
  Future<List<InsightModel>> fetchInsights() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.insights,
      );
      final data = response.data;

      if (data == null) {
        throw ServerException('Insights response was empty.');
      }

      return ((data['insights'] as List<dynamic>?) ?? const [])
          .map((item) => InsightModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Unable to parse insights response.');
    }
  }

  Exception _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return ServerException(
          'Insights request failed with status $statusCode.');
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        NetworkException('Unable to connect to insights service.'),
      _ => ServerException('Insights request failed.'),
    };
  }
}
