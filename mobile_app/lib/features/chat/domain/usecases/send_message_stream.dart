import '../repositories/chat_repository.dart';

class SendMessageStream {
  final ChatRepository _repository;

  const SendMessageStream(this._repository);

  Stream<String> call({
    required String message,
    String? conversationId,
  }) {
    return _repository.sendMessageStream(
      message: message,
      conversationId: conversationId,
    );
  }
}
