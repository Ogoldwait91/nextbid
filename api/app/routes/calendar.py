from fastapi import APIRouter

router = APIRouter(prefix="/calendar", tags=["calendar"])

# Minimal static calendar; extend later with real logic
_DEFAULT = [
    {"name": "Bidding opens",   "date": "2025-10-22"},
    {"name": "Bidding closes",  "date": "2025-10-29"},
    {"name": "Awards published","date": "2025-11-07"},
    {"name": "Swap window",     "date": "2025-11-08"},
]

@router.get("/{month}")
def get_calendar(month: str):
    # For now: always return the known shape your UI expects
    return {"month": month, "stages": list(_DEFAULT)}
