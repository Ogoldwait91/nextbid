from fastapi import FastAPI
app = FastAPI()

@app.get("/health")
def health():
    return {"ok": True}

@app.get("/calendars/{year}/{month}")
def calendars(year: int, month: int):
    return {"year": year, "month": month, "blocks": []}
