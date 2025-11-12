from fastapi import APIRouter, Query
from pydantic import BaseModel, Field
from typing import List, Dict, Optional, Literal

router = APIRouter(prefix="/pairings", tags=["pairings"])

class Pairing(BaseModel):
    id: str
    credit: int = Field(ge=0)
    nights: int = Field(ge=0)
    region: str
    type: Literal["Short-haul","Mid-haul","Long-haul"]

PAIRINGS_BY_MONTH: Dict[str, List[Pairing]] = {
    "2025-11": [
        Pairing(id="TI7L11-001", credit=52, nights=3, region="LHR-LH", type="Long-haul"),
        Pairing(id="TI7S11-014", credit=28, nights=1, region="LHR-SH", type="Short-haul"),
        Pairing(id="TI7M11-102", credit=40, nights=2, region="LHR-Mid", type="Mid-haul"),
    ]
}

@router.get("/{month}")
def list_pairings(
    month: str,
    limit: Optional[int] = Query(default=None, ge=0),
    min_credit: Optional[int] = Query(default=None, ge=0),
    type: Optional[str] = Query(default=None, description="Short-haul|Mid-haul|Long-haul"),
    region: Optional[str] = Query(default=None),
    sort: Optional[str] = Query(default="credit:desc", description="field:asc|desc (credit|nights|id)"),
):
    items = list(PAIRINGS_BY_MONTH.get(month, []))

    # filters
    if min_credit is not None:
        items = [p for p in items if int(p.credit) >= min_credit]
    if type:
        items = [p for p in items if p.type.lower() == type.lower()]
    if region:
        items = [p for p in items if p.region.lower() == region.lower()]

    # sorting
    field, _, direction = (sort or "credit:desc").partition(":")
    key = (field or "credit").strip()
    reverse = (direction or "desc").lower() == "desc"
    if key in {"credit","nights","id"}:
        items.sort(key=lambda p: getattr(p, key), reverse=reverse)

    # limit
    if limit is not None:
        items = items[:limit]

    total = len(items)
    avg_credit = round(sum(int(x.credit) for x in items) / total, 1) if total else 0.0
    return {"month": month, "stats": {"count": total, "avg_credit": avg_credit}, "pairings": [p.model_dump() for p in items]}
