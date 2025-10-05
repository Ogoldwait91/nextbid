from typing import List
from app.models.common import CalendarMonth, DayBlock, CreditAllocation, Pairing, ReserveLine

def get_calendar_for(year: int, month: int) -> CalendarMonth:
    blocks = [DayBlock(day=d, duty=("OFF" if d % 6 in (0,5) else "FLY")) for d in range(1, 29)]
    return CalendarMonth(year=year, month=month, blocks=blocks)

def get_credits_for(year: int, month: int) -> CreditAllocation:
    return CreditAllocation(year=year, month=month, credit_low=65.0, credit_target=75.0, credit_high=85.0)

def get_pairings_for(year: int, month: int) -> List[Pairing]:
    return [
        Pairing(id="LHR-JFK-LHR", days=3, credit=17.2, layovers=["JFK"], tags=["US","3-day"]),
        Pairing(id="LHR-DEL-LHR", days=4, credit=21.8, layovers=["DEL"], tags=["ASIA","4-day"]),
    ]

def get_reserve_for(year: int, month: int) -> List[ReserveLine]:
    return [ReserveLine(id="RES-A", pattern="R-OFF-R-R-R-OFF", notes="Example pattern")]
