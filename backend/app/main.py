from app.core.config import settings
from app.routes import (
    bids,
    calendars,
    cohorts,
    credits,
    health,
    pairings,
    privacy,
    reserve,
)
from fastapi import FastAPI

app = FastAPI(title=settings.app_name, version=settings.version)

# Routers
app.include_router(health.router)
app.include_router(calendars.router)
app.include_router(credits.router)
app.include_router(pairings.router)
app.include_router(reserve.router)
app.include_router(bids.router)
app.include_router(privacy.router)
app.include_router(cohorts.router)

# --- CORS (added by setup script) ---
try:
    from fastapi.middleware.cors import CORSMiddleware

    app.add_middleware(
        CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"]
    )
except Exception:
    pass
# --- /CORS ---
