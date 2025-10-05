from fastapi import APIRouter
from app.models.common import BidRequest, BidValidationResult

router = APIRouter(prefix="/bids", tags=["bids"])

REQUIRED_PREF_KEYS = {"credit_bias","longhaul_bias","weekend_off","leave_days_delta"}

@router.post("/validate", response_model=BidValidationResult)
def validate_bid(req: BidRequest):
    errors = []
    keys = {p.key for p in req.preferences}
    missing = REQUIRED_PREF_KEYS - keys
    if missing:
        errors.append(f"Missing preference keys: {', '.join(sorted(missing))}")
    if req.seniority < 1:
        errors.append("Seniority must be >= 1")
    return BidValidationResult(ok=len(errors)==0, errors=errors)
