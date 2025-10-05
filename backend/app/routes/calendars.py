from fastapi import APIRouter
from app.services.parsers import get_calendar_for
from app.models.common import CalendarMonth

router = APIRouter(prefix="/calendars", tags=["calendars"])

@router.get("/{year}/{month}", response_model=CalendarMonth)
def get_calendar(year: int, month: int):
    return get_calendar_for(year, month)
