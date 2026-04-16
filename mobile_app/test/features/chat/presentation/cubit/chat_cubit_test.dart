import 'package:ai_portfolio_companion/core/error/failures.dart';
import 'package:ai_portfolio_companion/features/chat/domain/repositories/chat_repository.dart';
import 'package:ai_portfolio_companion/features/chat/domain/usecases/send_message_stream.dart';
import 'package:ai_portfolio_companion/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('streams assistant response into the last message', () async {
    final cubit = ChatCubit(
      const SendMessageStream(
        _FakeChatRepository(chunks: ['Hello ', 'there']),
      ),
    );
    final states = <ChatState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.sendMessage('Hi');
    await subscription.cancel();

    expect(states.first, isA<ChatStreaming>());
    expect(cubit.state, isA<ChatReady>());
    expect(cubit.state.messages.last.text, 'Hello there');
  });

  test('emits ChatError when repository emits a failure', () async {
    final cubit = ChatCubit(
      const SendMessageStream(
        _FakeChatRepository(error: NetworkFailure('offline')),
      ),
    );
    final states = <ChatState>[];
    final subscription = cubit.stream.listen(states.add);

    await cubit.sendMessage('Hi');
    await subscription.cancel();

    expect(states.first, isA<ChatStreaming>());
    expect(cubit.state, isA<ChatError>());
    expect((cubit.state as ChatError).message, 'offline');
  });
}

class _FakeChatRepository implements ChatRepository {
  final List<String> chunks;
  final Object? error;

  const _FakeChatRepository({
    this.chunks = const [],
    this.error,
  });

  @override
  Stream<String> sendMessageStream({
    required String message,
    String? conversationId,
  }) async* {
    if (error != null) throw error!;
    for (final chunk in chunks) {
      yield chunk;
    }
  }
}
