from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/cohorts", tags=["cohorts"])


class CohortSnapshot(BaseModel):
    fleet: str
    base: str
    rank: str
    n_pilots: int
    percentile_win_rate: float  # mock: % of pilots who won top-5 pick last month


@router.get("/{fleet}/{base}/{rank}", response_model=CohortSnapshot)
def read_cohort(fleet: str, base: str, rank: str):
    # mock numbers; replace with computed cohort stats from parsed PDFs later
    return CohortSnapshot(
        fleet=fleet, base=base, rank=rank, n_pilots=420, percentile_win_rate=0.37
    )
