from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="NextBid API", version="0.0.1")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # dev-friendly; tighten later
    allow_methods=["*"],
    allow_headers=["*"],
)

CREDIT_BY_MONTH = {
    "2025-11": {"min": 20, "max": 85, "default": 50},  # tweak as you like
}

@app.get("/health")
def health():
    return {"ok": True}

@app.get("/credit/{month}")
def credit(month: str):
    data = CREDIT_BY_MONTH.get(month) or {"min": 20, "max": 85, "default": 50}
    return {"month": month, **data}
# --- calendar stub ---
CALENDAR_BY_MONTH = {
    # Example stage dates for Nov 2025 (adjust later from PDFs)
    "2025-11": [
        {"name": "Bid Opens",  "date": "2025-10-20"},
        {"name": "Bid Closes", "date": "2025-10-27"},
        {"name": "Awards",     "date": "2025-11-10"},
    ],
}

@app.get("/calendar/{month}")
def calendar(month: str):
    stages = CALENDAR_BY_MONTH.get(month, [])
    return {"month": month, "stages": stages}
