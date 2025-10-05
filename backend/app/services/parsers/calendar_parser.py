from app.models.common import CalendarMonth

def parse_calendar(pdf_path: str, year: int, month: int) -> CalendarMonth:
    """
    TODO: Real pdfplumber parsing later.
    Stub returns an empty month so the API works.
    """
    return CalendarMonth(year=year, month=month, blocks=[])
