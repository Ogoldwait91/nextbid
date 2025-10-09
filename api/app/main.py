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
# --- status resolver stub ---
import hashlib

def _hash_to_range(s: str, max_value: int) -> int:
    h = hashlib.sha256(s.encode("utf-8")).hexdigest()[:8]
    return (int(h, 16) % max_value) + 1

@app.get("/status/resolve")
def status_resolve(staff_no: str, crew_code: str):
    crew = crew_code.strip().upper()
    cohort_size = 5000
    seed = f"{staff_no.strip()}|{crew}"
    seniority = _hash_to_range(seed, cohort_size)
    return {
        "staff_no": staff_no,
        "crew_code": crew,
        "seniority": seniority,
        "cohort_size": cohort_size,
    }
