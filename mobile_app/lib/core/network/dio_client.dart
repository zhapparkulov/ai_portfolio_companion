import 'package:dio/dio.dart';

import '../config/app_config.dart';

class DioClient {
  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 10),
        headers: const {
          'Accept': 'application/json',
        },
      ),
    );
  }
}
