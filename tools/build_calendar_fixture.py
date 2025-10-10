"""
Build a calendar fixture JSON from a Calendar PDF.

Usage:
  py -3 api/.venv/Scripts/python.exe tools/build_calendar_fixture.py --pdf "docs/fixtures/nov2025/Calendar_Nov2025.pdf" --month 2025-11

Output:
  docs/fixtures/<mon><year>/calendar_<YYYY-MM>.json  (same shape your API expects)
"""
from __future__ import annotations
import argparse, json, re
from pathlib import Path
from datetime import datetime
from dateutil import parser as dtparse
import pdfplumber

MONTHS = ["jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dec"]

# Heuristics: pick lines that likely contain stage events + a date
KEYS = [
    ("Bidding opens",   re.compile(r"open", re.I)),
    ("Bidding closes",  re.compile(r"clos", re.I)),
    ("Awards published",re.compile(r"award", re.I)),
    ("Swap window",     re.compile(r"swap|window", re.I)),
]
DATE_PAT = re.compile(r"\b(\d{1,2}[/-]\d{1,2}[/-]\d{2,4}|\d{4}-\d{2}-\d{2})\b")

def normalise_date(s: str, year_hint: int|None=None) -> str|None:
    try:
        dt = dtparse.parse(s, dayfirst=True, yearfirst=False, default=datetime(year_hint or 2000,1,1))
        return dt.strftime("%Y-%m-%d")
    except Exception:
        return None

def extract_candidates(text: str) -> list[str]:
    # Split into lines, throw away empties
    lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
    # Keep lines that look like “something + date”
    keep = []
    for ln in lines:
        if DATE_PAT.search(ln):
            keep.append(ln)
    return keep

def guess_year(month: str) -> int:
    y, m = month.split("-")
    return int(y)

def build_fixture(pdf_path: Path, month: str) -> dict:
    year_hint = guess_year(month)
    with pdfplumber.open(pdf_path) as pdf:
        raw = "\n".join(page.extract_text() or "" for page in pdf.pages)

    lines = extract_candidates(raw)

    out = []
    used = set()

    for label, keyre in KEYS:
        # find first matching line that also contains a parseable date
        hit = next((ln for ln in lines if keyre.search(ln)), None)
        if not hit:
            continue
        m = DATE_PAT.search(hit)
        if not m:
            continue
        iso = normalise_date(m.group(1), year_hint=year_hint)
        if not iso or iso in used:
            continue
        used.add(iso)
        out.append({"name": label, "date": iso})

    # Sort by date ascending, stable
    out.sort(key=lambda x: x["date"])
    return {"month": month, "stages": out}

def out_path_for(month: str, repo_root: Path) -> Path:
    y, m = month.split("-")
    folder = f"{MONTHS[int(m)-1]}{y}"
    return repo_root / "docs" / "fixtures" / folder / f"calendar_{month}.json"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdf", required=True, help="Path to Calendar PDF")
    ap.add_argument("--month", required=True, help="YYYY-MM (e.g., 2025-11)")
    args = ap.parse_args()

    repo = Path(__file__).resolve().parents[1]
    pdf_path = Path(args.pdf)
    if not pdf_path.exists():
        raise SystemExit(f"PDF not found: {pdf_path}")

    fixture = build_fixture(pdf_path, args.month)
    outp = out_path_for(args.month, repo)
    outp.parent.mkdir(parents=True, exist_ok=True)
    outp.write_text(json.dumps(fixture, indent=2), encoding="utf-8")
    print(f"Wrote {outp}")
    print(json.dumps(fixture, indent=2))
if __name__ == "__main__":
    main()
