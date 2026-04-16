import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _dataSource;

  ChatRepositoryImpl(this._dataSource);

  @override
  Stream<String> sendMessageStream({
    required String message,
    String? conversationId,
  }) async* {
    try {
      await for (final chunk in _dataSource.sendMessageStream(
        message: message,
        conversationId: conversationId,
      )) {
        if (chunk.done) return;
        yield chunk.chunk;
      }
    } on NetworkException catch (e) {
      throw NetworkFailure(e.message);
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
