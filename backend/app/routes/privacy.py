from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter(prefix="/privacy", tags=["privacy"])


class PrivacyModel(BaseModel):
    share_anonymized: bool = True
    allow_cohort_bench: bool = True


_store = PrivacyModel()


@router.get("", response_model=PrivacyModel)
def read_privacy():
    return _store


@router.post("", response_model=PrivacyModel)
def update_privacy(p: PrivacyModel):
    global _store
    _store = p
    return _store
