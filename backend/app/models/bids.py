from pydantic import BaseModel
from typing import List, Optional

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
