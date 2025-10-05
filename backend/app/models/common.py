from typing import List, Optional

from pydantic import BaseModel, Field


class DayBlock(BaseModel):
    day: int
    duty: str = Field(examples=["OFF", "FLY", "SIM", "TRNG", "RES"])
    notes: Optional[str] = None


class CalendarMonth(BaseModel):
    year: int
    month: int
    blocks: List[DayBlock]


class CreditAllocation(BaseModel):
    year: int
    month: int
    credit_low: float
    credit_target: float
    credit_high: float
    notes: Optional[str] = None


class Pairing(BaseModel):
    id: str
    days: int
    credit: float
    layovers: List[str] = []
    tags: List[str] = []


class ReserveLine(BaseModel):
    id: str
    pattern: str
    notes: Optional[str] = None


class BidPreference(BaseModel):
    key: str
    value: str


class BidRequest(BaseModel):
    seniority: int
    fleet: str
    base: str
    rank: str
    month: int
    year: int
    preferences: List[BidPreference]


class BidValidationResult(BaseModel):
    ok: bool
    errors: List[str] = []
