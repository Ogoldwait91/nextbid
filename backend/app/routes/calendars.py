from app.models.common import CalendarMonth
from app.services.parsers import get_calendar_for
from fastapi import APIRouter

router = APIRouter(prefix="/calendars", tags=["calendars"])


@router.get("/{year}/{month}", response_model=CalendarMonth)
def get_calendar(year: int, month: int):
    return get_calendar_for(year, month)
