"""
Build per-month calendar fixtures from a full-year JSS calendar PDF.

Usage (example):
  api\.venv\Scripts\python.exe tools\build_calendar_year.py --pdf "C:\\path\\to\\2025_JSS_Calendar.pdf" --year 2025
"""
from __future__ import annotations
import argparse, json, re
from pathlib import Path
from datetime import datetime
from dateutil import parser as dtparse
import pdfplumber

MON_ABBR = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
MONTHS   = {m.lower(): i+1 for i, m in enumerate(MON_ABBR)}  # {"jan":1,...,"dec":12}
MON_KEY  = [m.lower() for m in MON_ABBR]                      # ["jan",...,"dec"]

# Examples matched: "Thu 10 Oct", "10 Oct", "2025-11-07", "10/29/25"
DATE_PAT = re.compile(
    r"\b(?:(?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)\s*)?\d{1,2}\s*[A-Za-z]{3}\b"
    r"|"
    r"\b\d{4}-\d{2}-\d{2}\b"
    r"|"
    r"\b\d{1,2}/\d{1,2}/\d{2,4}\b"
)

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
    lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
    return lines

def month_rows(lines: list[str], year: int) -> dict[str, str]:
    """
    Map "YYYY-MM" -> raw row text by matching lines that contain a month token
    and the target year (2-digit or 4-digit). Accepts e.g. "Nov 25", "NOV 25",
    "November 2025" (case-insensitive).
    """
    rows: dict[str, str] = {}
    # month token (short or long), then anything, then year token (2 or 4 digits)
    month_re = r"(Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)"
    year_re  = rf"(?:{year}|{year%100:02d})\b"
    rx = re.compile(month_re + r".*?" + year_re, re.I)

    for ln in lines:
        m = rx.search(ln)
        if not m:
            continue
        mon_tok = m.group(1)[:3].lower()  # normalize long names to 3-letter
        if mon_tok not in MONTHS:
            continue
        ym = f"{year}-{MONTHS[mon_tok]:02d}"
        rows.setdefault(ym, ln)  # first hit wins
    return rows

def dates_on_line(line: str, year: int) -> list[str]:
    hits: list[str] = []
    for m in DATE_PAT.finditer(line):
        iso = to_iso(m.group(0), default_year=year)
        if iso and iso not in hits:
            hits.append(iso)
    return hits

def build_month_fixtures(pdf: Path, year: int, repo_root: Path) -> list[Path]:
    lines = extract_lines(pdf)
    rows  = month_rows(lines, year)
    out_paths: list[Path] = []
    for ym, raw in rows.items():
        ds = dates_on_line(raw, year)
        stages = [{"name": f"Stage {i+1}", "date": d} for i, d in enumerate(ds)]
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
