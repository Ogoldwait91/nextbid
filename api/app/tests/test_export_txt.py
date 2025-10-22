from fastapi.testclient import TestClient
from api.app.main import app

client = TestClient(app)

def test_export_txt_crlf_and_trailing():
    payload = {"text": "!GROUP 1\n SET CREDIT 500-540\n WAIVE LONGHAUL\n!END GROUP"}
    r = client.post("/bid/export.txt", json=payload)
    assert r.status_code == 200
    body = r.text
    # all line endings are CRLF
    assert "\r\n" in body
    assert "\n" not in body.replace("\r\n", "")  # no stray LF
    # trailing CRLF present
    assert body.endswith("\r\n")
    # first line correct
    assert body.split("\r\n", 1)[0] == "!GROUP 1"
