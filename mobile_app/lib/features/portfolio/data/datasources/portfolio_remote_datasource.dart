import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../models/portfolio_model.dart';

class PortfolioRemoteDataSource {
  final Dio _dio;

  const PortfolioRemoteDataSource(this._dio);

  Future<PortfolioModel> fetchPortfolio() async {
    try {
      final response = await _dio.get(ApiEndpoints.portfolio);
      return PortfolioModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(e.response?.statusMessage ?? 'Server error');
      } else {
        throw NetworkException(e.message ?? 'Network error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
