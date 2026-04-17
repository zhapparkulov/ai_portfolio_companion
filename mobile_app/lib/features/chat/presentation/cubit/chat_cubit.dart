import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/send_message_stream.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageStream _sendMessageStream;

  ChatCubit(this._sendMessageStream) : super(const ChatReady([]));

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final currentMessages = state.messages;
    final userMessage = ChatMessage(
      id: 'user-${now.microsecondsSinceEpoch}',
      role: ChatMessageRole.user,
      text: trimmed,
      createdAt: now,
    );
    final assistantMessage = ChatMessage(
      id: 'assistant-${now.microsecondsSinceEpoch}',
      role: ChatMessageRole.assistant,
      text: '',
      createdAt: now,
    );

    var messages = [...currentMessages, userMessage, assistantMessage];
    var assistantText = '';
    emit(ChatStreaming(messages));

    try {
      await for (final chunk in _sendMessageStream(message: trimmed)) {
        assistantText += chunk;
        messages = [
          ...messages.take(messages.length - 1),
          assistantMessage.copyWith(text: assistantText),
        ];
        emit(ChatStreaming(messages));
      }

      emit(ChatReady(messages));
    } catch (error) {
      final message = error is Failure
          ? error.message
          : 'Unable to reach the AI assistant.';
      emit(ChatError(messages, message));
    }
  }

  void retryLastMessage() {
    if (state is! ChatError) return;

    final messages = List<ChatMessage>.from(state.messages);

    if (messages.isNotEmpty &&
        messages.last.role == ChatMessageRole.assistant) {
      messages.removeLast();
    }

    String? failedText;
    if (messages.isNotEmpty && messages.last.role == ChatMessageRole.user) {
      failedText = messages.removeLast().text;
    }

    if (failedText == null) return;

    emit(ChatReady(messages));
    sendMessage(failedText);
  }
}
