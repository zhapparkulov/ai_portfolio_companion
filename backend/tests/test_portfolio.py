from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_get_portfolio_returns_dashboard_snapshot() -> None:
    response = client.get("/v1/portfolio")

    assert response.status_code == 200
    payload = response.json()
    assert payload["total_value"] == 124530.42
    assert payload["daily_change_percent"] == 1.01
    assert payload["holdings"][0]["symbol"] == "AAPL"
    assert payload["holdings"][0]["value"] == 4737.5
