from fastapi import APIRouter
from datetime import datetime, timezone
from app.utils.gitinfo import get_build_info

router = APIRouter(prefix="/status", tags=["status"])
_started_at = datetime.now(timezone.utc)

@router.get("/version")
def version():
    return {"name": "NextBid API", "version": "0.0.1"}

@router.get("/uptime")
def uptime():
    now = datetime.now(timezone.utc)
    seconds = int((now - _started_at).total_seconds())
    return {"started_at": _started_at.isoformat(), "uptime_seconds": seconds}

@router.get("/build")
def build():
    return get_build_info()
