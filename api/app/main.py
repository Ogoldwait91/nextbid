from fastapi import FastAPI
from fastapi.responses import JSONResponse
from .routes.reserves import router as reserves_router

# Middleware (must exist — we created it earlier)
from .middleware import install_common_middleware

app = FastAPI(title="NextBid API", version="0.0.1")
install_common_middleware(app)

# Optional/defensive router imports — if a module is missing, we just skip it.
def _try_include(import_path: str, alias_name: str):
    try:
        module = __import__(import_path, fromlist=['router'])
        router = getattr(module, "router", None)
        if router is not None:
            app.include_router(router)
            return True
    except Exception:
        pass
    return False

# Try common routers
_try_include("app.routes.bid", "bid_router")
_try_include("app.routes.pairings", "pairings_router")
_try_include("app.routes.status", "status_router")


_try_include("app.routes.calendar", "calendar_router")
_try_include("app.routes.credit", "credit_router")
# Health endpoint
@app.get("/healthz")
def healthz():
    return JSONResponse({"status": "ok"})




app.include_router(reserves_router)
