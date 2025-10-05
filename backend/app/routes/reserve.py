from typing import List

from app.models.common import ReserveLine
from app.services.parsers import get_reserve_for
from fastapi import APIRouter

router = APIRouter(prefix="/reserve", tags=["reserve"])


@router.get("/{year}/{month}", response_model=List[ReserveLine])
def get_reserve(year: int, month: int):
    return get_reserve_for(year, month)
