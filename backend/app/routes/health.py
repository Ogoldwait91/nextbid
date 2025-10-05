from app.core.config import settings
from fastapi import APIRouter

router = APIRouter()


@router.get("/health")
def health():
    return {"status": "ok", "app": settings.app_name, "version": settings.version}
