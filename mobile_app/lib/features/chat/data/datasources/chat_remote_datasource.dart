import '../../../../core/error/exceptions.dart';
import '../models/chat_chunk_model.dart';

class ChatRemoteDataSource {
  Stream<ChatChunkModel> sendMessageStream({
    required String message,
    String? conversationId,
  }) async* {
    if (message.trim().isEmpty) {
      throw ServerException('Message cannot be empty.');
    }

    final chunks = _mockResponseFor(message);
    for (final chunk in chunks) {
      await Future<void>.delayed(const Duration(milliseconds: 90));
      yield ChatChunkModel(chunk: chunk);
    }

    yield const ChatChunkModel(done: true);
  }

  List<String> _mockResponseFor(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('risk') || lower.contains('tech')) {
      return const [
        'Your portfolio is currently ',
        '65% tech-heavy. ',
        'AAPL and NVDA are driving most of the upside, ',
        'but your downside risk is concentrated in one sector. ',
        'Consider shifting 7% toward healthcare or dividend-income assets.',
      ];
    }

    return const [
      'Your portfolio is up today, ',
      'with broad strength in mega-cap technology. ',
      'The AI recommendation is to keep winners, ',
      'but rebalance gradually if tech exposure moves above your target range.',
    ];
  }
}
