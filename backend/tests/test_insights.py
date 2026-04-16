from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_get_insights_returns_ai_cards() -> None:
    response = client.get("/v1/insights")

    assert response.status_code == 200
    payload = response.json()
    assert len(payload["insights"]) == 3
    assert payload["insights"][0]["severity"] == "priority"
    assert payload["insights"][0]["actions"][0]["label"] == "Execute Rebalance"
