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
# --- bid validator stub ---
import re
from typing import List, Dict
from pydantic import BaseModel

ROW_RE  = re.compile(r'^[A-Z0-9 _+\-.,/:()#=\\]{1,80}$')
BANK_RE = re.compile(r'^BANK_PROTECTION(?:\s+(ON|OFF))?$')

class BidText(BaseModel):
    text: str

@app.post("/bid/validate")
def bid_validate(payload: BidText):
    # Normalise line endings and split
    text = payload.text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [ln.strip() for ln in text.split("\n")]

    errors: List[str] = []
    groups = 0
    rows = 0
    seen: set[str] = set()

    for i, ln in enumerate(lines, start=1):
        if not ln:
            continue
        up = ln.upper()
        if up.startswith(";"):       # group boundary/comment
            groups += 1
            continue

        # Global directives (allowed at top)
        if up.startswith("CREDIT_PREFERENCE ") \
           or up.startswith("PREFER_RESERVE ") \
           or up.startswith("LEAVE_SLIDE"):
            continue

        # Disallow BANK_PROTECTION rows (handled by Pre-Process)
        if BANK_RE.match(up):
            errors.append(f"Line {i}: Remove BANK_PROTECTION; it is controlled by Pre-Process.")
            continue

        # Regular bid row
        rows += 1
        if not ROW_RE.match(up):
            errors.append(f"Line {i}: invalid row '{ln}'")
        elif up in seen:
            errors.append(f"Line {i}: duplicate row '{ln}'")
        else:
            seen.add(up)

    if groups > 15:
        errors.append("Too many groups (max 15).")
    if rows > 40:
        errors.append("Too many rows across groups (max 40).")

    return {
        "ok": len(errors) == 0,
        "errors": errors,
        "stats": {"groups": groups, "rows": rows, "unique_rows": len(seen)},
    }
