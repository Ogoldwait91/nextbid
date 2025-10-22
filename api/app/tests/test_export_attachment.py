from fastapi.testclient import TestClient
from api.app.main import app
from datetime import date

client = TestClient(app)

def test_export_attachment_headers():
    payload = {"text": "!GROUP 1\n SET CREDIT 500-540\n WAIVE LONGHAUL\n!END GROUP"}
    r = client.post("/bid/export", json=payload)
    assert r.status_code == 200
    cd = r.headers.get("content-disposition", "")
    assert "attachment" in cd.lower()
    expected = f'nextbid_{date.today():%Y-%m}.jss'
    assert expected in cd
    # content type should be text/plain utf-8
    assert r.headers.get("content-type","").startswith("text/plain")
