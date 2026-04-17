from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_chat_stream_returns_sse_chunks() -> None:
    response = client.post(
        "/v1/chat/stream",
        json={"message": "How is my tech exposure looking?"},
        headers={"Accept": "text/event-stream"},
    )

    assert response.status_code == 200
    assert response.headers["content-type"].startswith("text/event-stream")
    assert 'data: {"chunk":' in response.text
    assert 'data: {"done": true}' in response.text


def test_chat_stream_returns_russian_chunks_for_russian_message() -> None:
    response = client.post(
        "/v1/chat/stream",
        json={"message": "Как выглядит мой риск по tech сектору?"},
        headers={"Accept": "text/event-stream"},
    )

    assert response.status_code == 200
    assert response.headers["content-type"].startswith("text/event-stream")
    assert 'data: {"chunk":' in response.text
    assert any("а" <= char.lower() <= "я" or char == "ё" for char in response.text)
    assert 'data: {"done": true}' in response.text


def test_chat_stream_rejects_empty_message() -> None:
    response = client.post(
        "/v1/chat/stream",
        json={"message": "   "},
    )

    assert response.status_code == 422
