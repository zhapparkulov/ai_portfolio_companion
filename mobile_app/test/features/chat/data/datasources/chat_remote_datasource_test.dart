import 'package:ai_portfolio_companion/core/constants/api_endpoints.dart';
import 'package:ai_portfolio_companion/core/error/exceptions.dart';
import 'package:ai_portfolio_companion/core/network/sse_client.dart';
import 'package:ai_portfolio_companion/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('streams chunks from SSE events', () async {
    final sseClient = _FakeSseClient(events: [
      {'chunk': 'Hello '},
      {'chunk': 'there'},
      {'done': true},
      {'chunk': 'ignored'},
    ]);
    final dataSource = ChatRemoteDataSource(sseClient);

    final chunks = await dataSource
        .sendMessageStream(message: ' Hi ', conversationId: ' abc ')
        .toList();

    expect(sseClient.path, ApiEndpoints.chatStream);
    expect(sseClient.body, {
      'message': 'Hi',
      'conversation_id': 'abc',
    });
    expect(chunks.map((chunk) => chunk.chunk), ['Hello ', 'there', '']);
    expect(chunks.last.done, isTrue);
  });

  test('throws ServerException when message is empty', () {
    final dataSource = ChatRemoteDataSource(_FakeSseClient());

    expect(
      dataSource.sendMessageStream(message: '   ').toList(),
      throwsA(isA<ServerException>()),
    );
  });
}

class _FakeSseClient implements SseClient {
  final List<Map<String, dynamic>> events;
  String? path;
  Map<String, dynamic>? body;

  _FakeSseClient({
    this.events = const [],
  });

  @override
  Stream<Map<String, dynamic>> postJsonStream(
    String path, {
    required Map<String, dynamic> body,
  }) async* {
    this.path = path;
    this.body = body;

    for (final event in events) {
      yield event;
    }
  }
}
