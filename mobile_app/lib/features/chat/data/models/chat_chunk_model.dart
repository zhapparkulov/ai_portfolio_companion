class ChatChunkModel {
  final String chunk;
  final bool done;

  const ChatChunkModel({
    this.chunk = '',
    this.done = false,
  });

  factory ChatChunkModel.fromJson(Map<String, dynamic> json) {
    return ChatChunkModel(
      chunk: json['chunk'] as String? ?? '',
      done: json['done'] as bool? ?? false,
    );
  }
}
