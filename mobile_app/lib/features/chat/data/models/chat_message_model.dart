import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    required super.id,
    required super.role,
    required super.text,
    required super.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      role: (json['role'] as String) == 'assistant'
          ? ChatMessageRole.assistant
          : ChatMessageRole.user,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role == ChatMessageRole.assistant ? 'assistant' : 'user',
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
