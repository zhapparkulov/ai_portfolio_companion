import '../../../../core/error/exceptions.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/sse_client.dart';
import '../models/chat_chunk_model.dart';

class ChatRemoteDataSource {
  final SseClient _sseClient;

  const ChatRemoteDataSource(this._sseClient);

  Stream<ChatChunkModel> sendMessageStream({
    required String message,
    String? conversationId,
  }) async* {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      throw ServerException('Message cannot be empty.');
    }

    final body = <String, dynamic>{
      'message': trimmed,
      if (conversationId != null && conversationId.trim().isNotEmpty)
        'conversation_id': conversationId.trim(),
    };

    await for (final event in _sseClient.postJsonStream(
      ApiEndpoints.chatStream,
      body: body,
    )) {
      final chunk = ChatChunkModel.fromJson(event);
      yield chunk;
      if (chunk.done) return;
    }
  }
}
