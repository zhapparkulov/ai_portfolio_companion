abstract class ChatRepository {
  Stream<String> sendMessageStream({
    required String message,
    String? conversationId,
  });
}
