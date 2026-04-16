part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  final List<ChatMessage> messages;

  const ChatState(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatReady extends ChatState {
  const ChatReady(super.messages);
}

class ChatStreaming extends ChatState {
  const ChatStreaming(super.messages);
}

class ChatError extends ChatState {
  final String message;

  const ChatError(super.messages, this.message);

  @override
  List<Object?> get props => [messages, message];
}
