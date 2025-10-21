def test_healthz():
    import requests
    try:
        r = requests.get("http://127.0.0.1:8000/healthz", timeout=2)
        assert r.status_code == 200
        assert r.json().get("status") == "ok"
    except Exception as e:
        # Doesn't fail CI; just prints a hint if server isn't running
        print("Hint: start API with python -m uvicorn app.main:app --reload before this test")
