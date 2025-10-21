from fastapi import FastAPI, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Dict
from pathlib import Path
from datetime import datetime, timezone
from pydantic import BaseModel
import hashlib
import json
import re

app = FastAPI(title="NextBid API", version="0.0.1")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # dev-friendly; tighten later
    allow_methods=["*"],
    allow_headers=["*"],
)

# -------------------- CREDIT --------------------
CREDIT_BY_MONTH = {
    "2025-11": {"min": 20, "max": 85, "default": 50},
}

@app.get("/health")
def health():
    return {"ok": True}

@app.get("/credit/{month}")
def credit(month: str):
    data = CREDIT_BY_MONTH.get(month) or {"min": 20, "max": 85, "default": 50}
    return {"month": month, **data}

# -------------------- STATUS --------------------
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

# -------------------- BID VALIDATE --------------------
ROW_RE  = re.compile(r'^[A-Z0-9 _+\-.,/:()#=\\]{1,80}$')
BANK_RE = re.compile(r'^BANK_PROTECTION(?:\s+(ON|OFF))?$')
# Added: pattern for JSS bank-protection first command in final group
BANK_PROTECT_CMD_RE = re.compile(
    r'^\s*AWARD\s+WORK\s+CONTAINED\s+WITHIN\s+L-{2}\s*$', re.IGNORECASE
)

class BidText(BaseModel):
    text: str

@app.post("/bid/validate")
def bid_validate(payload: BidText):
    """
    Validates bid text:
      - Groups start at lines beginning with ';'
      - Disallows explicit BANK_PROTECTION lines (pre-process owns it)
      - Enforces <=15 groups and <=40 rows
      - NEW: Warns if the final bid group does NOT start with
             'AWARD WORK CONTAINED WITHIN L--' (JSS bank-protection rule).
    """
    text = payload.text.replace("\r\n", "\n").replace("\r", "\n")
    lines = [ln.strip() for ln in text.split("\n")]

    errors: List[str] = []
    groups = 0
    rows = 0
    seen: set[str] = set()

    # track group starts (line indices)
    group_starts: List[int] = []

    for i, ln in enumerate(lines, start=1):
        if not ln:
            continue
        up = ln.upper()
        if up.startswith(";"):       # group boundary/comment
            groups += 1
            group_starts.append(i-1)  # store zero-based index in 'lines'
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

    # ---- NEW: Bank-protection check on final group ----
    # Find start of final group: last index in group_starts, else start of file (-1)
    last_start_idx = (group_starts[-1] if group_starts else -1)
    # Find first non-empty, non-comment line AFTER that
    first_cmd = None
    for ln in lines[last_start_idx + 1:]:
        if not ln or ln.startswith(";"):
            continue
        first_cmd = ln
        break
    if first_cmd and not BANK_PROTECT_CMD_RE.match(first_cmd):
        errors.append(
            "Final bid group should start with “AWARD WORK CONTAINED WITHIN L--” "
            "(required for JSS bank protection)."
        )

    return {
        "ok": len(errors) == 0,
        "errors": errors,
        "stats": {"groups": groups, "rows": rows, "unique_rows": len(seen)},
    }

# -------------------- BID EXPORT --------------------
class ExportText(BaseModel):
    text: str

@app.post("/bid/export")
def bid_export(payload: ExportText):
    size = len(payload.text.encode("utf-8"))
    ts = datetime.now(timezone.utc).isoformat()
    return {"ok": True, "size": size, "ts": ts}

# -------------------- NEW: BID SIMULATE & UPLOAD --------------------
class BidCmds(BaseModel):
    text: str

@app.post("/bid/simulate")
def bid_simulate(payload: BidCmds):
    """
    Lightweight 'feel' for a bid: counts distinct non-comment lines as a proxy.
    Returns a pseudo score and rank estimate (stub).
    """
    txt = payload.text.replace("\r", "")
    rows = [ln.strip() for ln in txt.split("\n") if ln.strip() and not ln.strip().startswith(";")]
    uniq = len(set(r.upper() for r in rows))
    score = min(0.95, 0.35 + 0.01 * min(40, uniq))
    rank_estimate = max(1, int((1.0 - score) * 5000))
    return {"ok": True, "score": round(score, 3), "rank_estimate": rank_estimate}

@app.post("/bid/upload")
def bid_upload(file: UploadFile = File(...)):
    """
    Accepts a .txt file upload for future import logic. Returns file size now.
    """
    if not (file.filename or "").lower().endswith(".txt"):
        raise HTTPException(status_code=400, detail="Please upload a .txt file.")
    content = file.file.read() or b""
    return {"ok": True, "filename": file.filename, "bytes": len(content)}

# -------------------- PAIRINGS --------------------
PAIRINGS_BY_MONTH: Dict[str, List[Dict]] = {
    "2025-11": [
        {"id": "TI7L11-001", "credit": 52, "nights": 3, "region": "LHR-LH", "type": "Long-haul"},
        {"id": "TI7L11-002", "credit": 48, "nights": 2, "region": "LHR-SH", "type": "Short-haul"},
        {"id": "TI7L11-003", "credit": 60, "nights": 4, "region": "LHR-LH", "type": "Long-haul"},
        {"id": "TI7L11-004", "credit": 40, "nights": 2, "region": "LHR-SH", "type": "Short-haul"},
        {"id": "TI7L11-005", "credit": 55, "nights": 3, "region": "LHR-LH", "type": "Long-haul"},
        {"id": "TI7L11-006", "credit": 35, "nights": 1, "region": "LHR-SH", "type": "Short-haul"},
    ],
}

@app.get("/pairings/{month}")
def pairings(month: str, limit: int | None = None):
    items = PAIRINGS_BY_MONTH.get(month, [])
    if limit is not None and limit >= 0:
        items = items[:limit]
    total = len(items)
    avg_credit = round(sum(int(p.get("credit", 0) ) for p in items) / total, 1) if total else 0.0
    return {"month": month, "pairings": items, "stats": {"count": total, "avg_credit": avg_credit}}

# -------------------- PRIVACY (existing) --------------------
@app.get("/privacy/data")
def privacy_data():
    now = datetime.now(timezone.utc).isoformat()
    return {
        "generated_at": now,
        "profile": {"name": "Your Name", "rank": "FO", "crew_code": "XXXX", "staff_no": ""},
        "preferences": {"credit": "NEUTRAL", "leave_slide": 0, "prefer_reserve": False},
        "bid": {"groups": ["Group 1"], "rows": []}
    }

@app.delete("/privacy/data")
def privacy_delete():
    return {"ok": True, "deleted": True}

# -------------------- NEW: PRIVACY CONSENT + COHORT METRICS --------------------
class ConsentFlag(BaseModel):
    consent: bool

# in-memory consent store (per-process)
_privacy_consent = {"consent": False}

@app.post("/privacy/consent")
def set_privacy_consent(payload: ConsentFlag):
    _privacy_consent["consent"] = bool(payload.consent)
    return {"ok": True, "consent": _privacy_consent["consent"]}

@app.get("/privacy/consent")
def get_privacy_consent():
    return {"ok": True, "consent": _privacy_consent["consent"]}

@app.get("/cohort/competitiveness")
def cohort_competitiveness(month: str):
    """
    Returns anonymised cohort percentiles. Requires consent ON.
    """
    if not _privacy_consent["consent"]:
        return {"ok": False, "reason": "consent_required"}
    # Stubbed values for now
    return {
        "ok": True,
        "month": month,
        "percentiles": {"p20": 0.42, "p50": 0.61, "p80": 0.78},
        "bid_count": 742
    }

# -------------------- RESERVES --------------------
RESERVES_BY_MONTH = {
    "2025-11": [
        {"code": "R1", "days": [2, 9, 16, 23, 30]},
        {"code": "R2", "days": [5, 12, 19, 26]},
        {"code": "R3", "days": [7, 14, 21, 28]},
    ],
}

@app.get("/reserves/{month}")
def reserves(month: str):
    items = RESERVES_BY_MONTH.get(month, [])
    total = sum(len(r.get("days", [])) for r in items)
    return {"month": month, "blocks": items, "stats": {"count": len(items), "total_days": total}}

# -------------------- CALENDAR (docs-first) --------------------
FIXDIR = Path(__file__).resolve().parents[2] / "docs" / "fixtures"
CALDIR = Path(__file__).resolve().parents[2] / "docs" / "calendar"
_MON = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]

def _calendar_try_year_json(month: str):
    try:
        year = int(month.split("-")[0])
    except Exception:
        return None
    p = CALDIR / f"calendar_{year}.json"
    print(f"[calendar][year-json] {p} exists={p.exists()}")
    if not p.exists():
        return None
    try:
        obj = json.loads(p.read_text(encoding="utf-8-sig"))
        row = obj.get("months", {}).get(month)
        if row is None:
            return {"month": month, "stages": []}
        stages = []
        if row.get("opens"):   stages.append({"name":"Bidding opens",    "date":row["opens"]})
        if row.get("closes"):  stages.append({"name":"Bidding closes",   "date":row["closes"]})
        if row.get("awards"):  stages.append({"name":"Awards published", "date":row["awards"]})
        if row.get("swap"):    stages.append({"name":"Swap window",      "date":row["swap"]})
        return {"month": month, "stages": stages}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"calendar year-json failed: {e}")

def _calendar_try_fixture(month: str):
    try:
        y, m = month.split("-")
        folder = f"{_MON[int(m)-1]}{y}"
    except Exception:
        raise FileNotFoundError("Bad month format")
    p = FIXDIR / folder / f"calendar_{month}.json"
    print(f"[calendar][fixture] trying {p} exists={p.exists()}")
    if not p.exists():
        raise FileNotFoundError(p)
    return json.loads(p.read_text(encoding="utf-8-sig"))

@app.get("/calendar/{month}")
def calendar(month: str):
    ov = _calendar_try_year_json(month)
    if ov is not None:
        print(f"[calendar] {month} -> year-json ({len(ov.get('stages', []))} stages)")
        return ov
    try:
        data = _calendar_try_fixture(month)
        stages = data.get("stages", [])
        print(f"[calendar] {month} -> fixture ({len(stages)} stages)")
        return {"month": month, "stages": stages}
    except FileNotFoundError:
        print(f"[calendar] {month} -> empty (no docs file)")
        return {"month": month, "stages": []}
    except Exception as e:
        print(f"[calendar] {month} -> error: {e}")
        raise HTTPException(status_code=500, detail=f"calendar load failed: {e}")

print("[boot] api main loaded")
print("[paths] FIXDIR", FIXDIR)
print("[paths] CALDIR", CALDIR)

@app.get("/healthz")
def healthz():
    return {"status": "ok"}

from app.routes import bid

app.include_router(bid.router)
@app.get("/healthz")
def healthz():
    return {"ok": True, "service": "nextbid-api"}
