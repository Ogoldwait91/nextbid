from fastapi import APIRouter
from typing import Dict, List, Any

router = APIRouter(prefix="/credit", tags=["credit"])

# Reference the pairings data or stub from your pairings endpoint
from app.routes.pairings import PAIRINGS_BY_MONTH

@router.get("/{month}")
def credit(month: str) -> Dict[str, Any]:
    # Pull all credits for the given month
    items: List[Dict[str, Any]] = [
        (p.model_dump() if hasattr(p, "model_dump") else dict(p))
        for p in PAIRINGS_BY_MONTH.get(month, [])
    ]
    credits = [int(x.get("credit", 0)) for x in items if x.get("credit") is not None]

    # Compute min, max, and default (average rounded) credit values
    if credits:
        min_credit = min(credits)
        max_credit = max(credits)
        default_credit = round(sum(credits) / len(credits))
    else:
        # Fall back to zeroes if no data is found
        min_credit = 0
        max_credit = 0
        default_credit = 0

    return {
        "month": month,
        "min": min_credit,
        "max": max_credit,
        "default": default_credit,
    }
