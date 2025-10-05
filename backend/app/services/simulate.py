from typing import List

from app.models.bids import BidSimulationOption, BidSimulationResult
from app.models.common import BidRequest


def simulate_bid(req: BidRequest) -> BidSimulationResult:
    # TODO: replace with real logic or AI ranking
    base = f"{req.base}-{req.fleet}-{req.rank}-{req.year}-{req.month}"
    opts: List[BidSimulationOption] = [
        BidSimulationOption(
            id="optA",
            name="Balanced",
            satisfaction_score=0.72,
            credit=75.0,
            days_on=16,
            layovers=["JFK", "BOS"],
            notes=base,
        ),
        BidSimulationOption(
            id="optB",
            name="Longhaul-lean",
            satisfaction_score=0.66,
            credit=78.5,
            days_on=15,
            layovers=["DEL", "BOM"],
            notes=base,
        ),
        BidSimulationOption(
            id="optC",
            name="Weekend-off focus",
            satisfaction_score=0.61,
            credit=73.0,
            days_on=14,
            layovers=["AMS"],
            notes=base,
        ),
    ]
    return BidSimulationResult(options=opts)
