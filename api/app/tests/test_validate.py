from fastapi.testclient import TestClient
from api.app.main import app

client = TestClient(app)

def test_validate_happy_path():
    txt = "!GROUP 1\n SET CREDIT 500-540\n WAIVE LONGHAUL\n!END GROUP\n"
    r = client.post("/bid/validate", json={"text": txt})
    assert r.status_code == 200
    data = r.json()
    assert data["ok"] is True
    assert data["groups"] == 1
    assert data["total_lines"] >= 2
    assert not data["errors"]

def test_validate_limits_and_unclosed():
    txt = "!GROUP 1\n" + ("\n".join([f" LINE {i}" for i in range(0, 41)]))  # 41 lines
    r = client.post("/bid/validate", json={"text": txt})
    data = r.json()
    assert data["ok"] is False
    assert any("Unclosed !GROUP" in e for e in data["errors"])  # no !END GROUP
    assert any("has 41 lines" in e for e in data["errors"])
