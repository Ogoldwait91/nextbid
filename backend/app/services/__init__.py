from pathlib import Path
from .parsers import parse_calendar

def get_calendar_for(year: int, month: int):
    """
    Return a CalendarMonth parsed from a (placeholder) PDF.
    In Phase 1 this is stubbed; later we'll parse real BA PDFs.
    """
    root = Path(__file__).resolve().parents[2]  # backend/
    fixture = root / "docs" / "fixtures" / "nov2025" / "your_calendar.pdf"
    pdf_path = str(fixture) if fixture.exists() else ""
    return parse_calendar(pdf_path, year, month)
