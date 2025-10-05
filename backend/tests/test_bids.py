from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_validate_missing_keys():
    payload = {
        "seniority": 10, "fleet":"A350", "base":"LHR", "rank":"FO", "month": 11, "year": 2025,
        "preferences": [{"key":"credit_bias","value":"balanced"}]
    }
    r = client.post("/bids/validate", json=payload)
    assert r.status_code == 200
    data = r.json()
    assert data["ok"] is False
    assert "Missing preference keys" in " ".join(data["errors"])

def test_simulate_ok():
    prefs = [
        {"key":"credit_bias","value":"balanced"},
        {"key":"longhaul_bias","value":"prefer"},
        {"key":"weekend_off","value":"high"},
        {"key":"leave_days_delta","value":"0"},
    ]
    payload = {"seniority": 10, "fleet":"A350", "base":"LHR", "rank":"FO", "month": 11, "year": 2025, "preferences": prefs}
    r = client.post("/bids/simulate", json=payload)
    assert r.status_code == 200
    data = r.json()
    assert "options" in data and len(data["options"]) >= 1
