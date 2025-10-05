from fastapi import APIRouter
from app.services.parsers import get_credits_for
from app.models.common import CreditAllocation

router = APIRouter(prefix="/credits", tags=["credits"])

@router.get("/{year}/{month}", response_model=CreditAllocation)
def get_credits(year: int, month: int):
    return get_credits_for(year, month)
