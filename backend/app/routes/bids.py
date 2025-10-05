from fastapi import APIRouter, UploadFile
from fastapi.responses import JSONResponse
from typing import Dict
from app.models.common import BidRequest, BidValidationResult
from app.models.bids import BidSimulationResult
from app.services.simulate import simulate_bid

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

@router.post("/simulate", response_model=BidSimulationResult)
def simulate(req: BidRequest):
    return simulate_bid(req)

@router.get("/export")
def export_simulation():
    sample = {"export":"pending","format":"json","hint":"call /bids/simulate first to get options"}
    return JSONResponse(content=sample)

@router.post("/upload")
async def upload(file: UploadFile):
    # Phase-1 stub: accept file and return metadata only
    content = await file.read()
    meta: Dict[str, str] = {
        "filename": file.filename or "",
        "content_type": file.content_type or "application/octet-stream",
        "bytes": str(len(content)),
    }
    return meta
