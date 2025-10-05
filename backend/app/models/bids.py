from typing import List, Optional

from pydantic import BaseModel


class BidSimulationOption(BaseModel):
    id: str
    name: str
    satisfaction_score: float
    credit: float
    days_on: int
    layovers: List[str] = []
    notes: Optional[str] = None


class BidSimulationResult(BaseModel):
    options: List[BidSimulationOption]
