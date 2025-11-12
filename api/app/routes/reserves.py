from fastapi import APIRouter
from typing import Dict, List, Any

router = APIRouter(prefix="/reserves", tags=["reserves"])

RESERVES_BY_MONTH: Dict[str, List[dict]] = {
    "2025-11": [
        {"code": "R1", "days": [2, 9, 16, 23, 30]},
        {"code": "R2", "days": [5, 12, 19, 26]},
        {"code": "R3", "days": [7, 14, 21, 28]},
    ],
}

@router.get("/{month}")
def list_reserves(month: str) -> Dict[str, Any]:
    items = RESERVES_BY_MONTH.get(month, [])
    total_days = sum(len(b.get("days", [])) for b in items)
    return {"month": month, "blocks": items, "stats": {"count": len(items), "total_days": total_days}}
