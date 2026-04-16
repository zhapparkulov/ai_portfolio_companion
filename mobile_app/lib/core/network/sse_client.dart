import 'dart:convert';

import 'package:dio/dio.dart';

import '../error/exceptions.dart';

abstract class SseClient {
  Stream<Map<String, dynamic>> postJsonStream(
    String path, {
    required Map<String, dynamic> body,
  });
}

class DioSseClient implements SseClient {
  final Dio _dio;

  const DioSseClient(this._dio);

  @override
  Stream<Map<String, dynamic>> postJsonStream(
    String path, {
    required Map<String, dynamic> body,
  }) async* {
    try {
      final response = await _dio.post<ResponseBody>(
        path,
        data: body,
        options: Options(
          responseType: ResponseType.stream,
          headers: const {
            'Accept': 'text/event-stream',
            'Content-Type': 'application/json',
          },
        ),
      );

      final statusCode = response.statusCode ?? 0;
      if (statusCode < 200 || statusCode >= 300) {
        throw ServerException('SSE request failed with status $statusCode.');
      }

      final responseBody = response.data;
      if (responseBody == null) {
        throw ServerException('SSE response was empty.');
      }

      await for (final line in responseBody.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (!line.startsWith('data:')) continue;

        final payload = line.substring(5).trim();
        if (payload.isEmpty) continue;

        if (payload == '[DONE]') {
          yield const {'done': true};
          continue;
        }

        final decoded = jsonDecode(payload);
        if (decoded is! Map<String, dynamic>) {
          throw ServerException('SSE event payload must be a JSON object.');
        }

        yield decoded;
      }
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException {
      throw ServerException('SSE event payload is not valid JSON.');
    } on NetworkException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException('Unable to read SSE stream.');
    }
  }

  Exception _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode != null) {
      return ServerException('SSE request failed with status $statusCode.');
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        NetworkException('Unable to connect to the chat stream.'),
      _ => ServerException('Chat stream request failed.'),
    };
  }
}
