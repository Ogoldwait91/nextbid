"""
Build per-month calendar fixtures from a full-year JSS calendar PDF.

Usage:
  api\.venv\Scripts\python.exe tools\build_calendar_year.py --pdf "C:\\path\\to\\2025_JSS_Calendar.pdf" --year 2025
"""
from __future__ import annotations
import argparse, json, re
from pathlib import Path
from datetime import datetime
from dateutil import parser as dtparse
import pdfplumber

MON_ABBR = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
MONTHS   = {m.lower(): i+1 for i, m in enumerate(MON_ABBR)}  # {"jan":1,...}
MON_KEY  = [m.lower() for m in MON_ABBR]                      # ["jan",...,"dec"]

# Date patterns we might see (e.g., "Thu 10 Oct", "10 Oct", "2025-11-07", "10/29/25")
DATE_PAT = re.compile(
    r"\b(?:(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s*)?\d{1,2}\s*[A-Za-z]{3}\b"
    r"|"
    r"\b\d{4}-\d{2}-\d{2}\b"
    r"|"
    r"\b\d{1,2}/\d{1,2}/\d{2,4}\b",
    re.I,
)

# Label patterns to anchor dates
LABELS = [
    ("Bidding opens",   re.compile(r"\b(open|opens|opening)\b", re.I)),
    ("Bidding closes",  re.compile(r"\b(close|closes|closing)\b", re.I)),
    ("Awards published",re.compile(r"\b(award|awards|published|publish)\b", re.I)),
    ("Swap window",     re.compile(r"\b(swap|window)\b", re.I)),
]

def to_iso(s: str, default_year: int) -> str|None:
    s = s.strip()
    try:
        dt = dtparse.parse(s, dayfirst=True, yearfirst=False, default=datetime(default_year, 1, 1))
        return dt.strftime("%Y-%m-%d")
    except Exception:
        return None

def extract_lines(pdf_path: Path) -> list[str]:
    with pdfplumber.open(pdf_path) as pdf:
        text = "\n".join(p.extract_text() or "" for p in pdf.pages)
    return [ln.strip() for ln in text.splitlines() if ln and ln.strip()]

def month_rows(lines: list[str], year: int) -> dict[str, int]:
    """
    Map "YYYY-MM" -> line index of the row that mentions that month+year.
    Accepts "Nov 25", "NOV 25", "November 2025" etc.
    """
    rows: dict[str, int] = {}
    month_re = r"(Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)"
    year_re  = rf"(?:{year}|{year%100:02d})\b"
    rx = re.compile(month_re + r".*?" + year_re, re.I)

    for idx, ln in enumerate(lines):
        m = rx.search(ln)
        if not m: 
            continue
        mon_tok = m.group(1)[:3].lower()
        if mon_tok not in MONTHS: 
            continue
        ym = f"{year}-{MONTHS[mon_tok]:02d}"
        rows.setdefault(ym, idx)  # first hit wins
    return rows

def find_labeled_dates(lines: list[str], start_idx: int, year: int, lookahead: int = 3) -> list[dict]:
    """
    Search the month row and the next few lines for our label keywords.
    For each label in order, if found on a line, take the *first* date on that line.
    """
    result = []
    used = set()
    window = lines[start_idx : min(len(lines), start_idx + 1 + lookahead)]
    for label, lre in LABELS:
        chosen = None
        for ln in window:
            if not lre.search(ln):
                continue
            m = DATE_PAT.search(ln)
            if not m:
                continue
            iso = to_iso(m.group(0), default_year=year)
            if not iso or iso in used:
                continue
            used.add(iso)
            chosen = {"name": label, "date": iso}
            break
        if chosen:
            result.append(chosen)
    return result

def dates_any(lines: list[str], start_idx: int, year: int) -> list[dict]:
    """Fallback: pull any dates from the month row only, label as Stage 1..N."""
    ln = lines[start_idx]
    hits = []
    for m in DATE_PAT.finditer(ln):
        iso = to_iso(m.group(0), default_year=year)
        if iso and iso not in hits:
            hits.append(iso)
    return [{"name": f"Stage {i+1}", "date": d} for i, d in enumerate(hits)]

def build_month_fixtures(pdf: Path, year: int, repo_root: Path) -> list[Path]:
    lines = extract_lines(pdf)
    rows  = month_rows(lines, year)  # { "YYYY-MM": line_index }
    out_paths: list[Path] = []

    for ym, idx in rows.items():
        labeled = find_labeled_dates(lines, idx, year, lookahead=4)
        stages  = labeled if labeled else dates_any(lines, idx, year)

        mon_idx = int(ym.split("-")[1])
        folder  = f"{MON_KEY[mon_idx-1]}{year}"
        out_dir = repo_root / "docs" / "fixtures" / folder
        out_dir.mkdir(parents=True, exist_ok=True)
        outp = out_dir / f"calendar_{ym}.json"
        outp.write_text(json.dumps({"month": ym, "stages": stages}, indent=2), encoding="utf-8")
        out_paths.append(outp)

    return out_paths

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--pdf", required=True, help="Path to the year calendar PDF")
    ap.add_argument("--year", required=True, type=int, help="Year (e.g., 2025)")
    args = ap.parse_args()

    pdf = Path(args.pdf)
    if not pdf.exists():
        raise SystemExit(f"PDF not found: {pdf}")

    repo_root = Path(__file__).resolve().parents[1]
    outs = build_month_fixtures(pdf, args.year, repo_root)
    print(f"Wrote {len(outs)} month fixtures:")
    for p in outs:
        print(" -", p)

if __name__ == "__main__":
    main()
