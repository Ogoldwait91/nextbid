from fastapi import APIRouter
from typing import List
from app.services.parsers import get_pairings_for
from app.models.common import Pairing

router = APIRouter(prefix="/pairings", tags=["pairings"])

@router.get("/{year}/{month}", response_model=List[Pairing])
def get_pairings(year: int, month: int):
    return get_pairings_for(year, month)
