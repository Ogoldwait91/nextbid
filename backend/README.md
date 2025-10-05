# NextBid Backend (FastAPI) — Scaffold

This is a lightweight backend scaffold to plug into your existing Flutter app while we build the real parsers.

## Quick start

### Windows (PowerShell)
```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

Open: http://127.0.0.1:8000/docs

### macOS/Linux
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
uvicorn app.main:app --reload --port 8000
```

## Endpoints (initial stubs)
- `GET /health` — service status
- `GET /calendars/{year}/{month}` — mock calendar lines
- `GET /credits/{year}/{month}` — mock credit allocation
- `GET /pairings/{year}/{month}` — mock pairings
- `GET /reserve/{year}/{month}` — mock reserve lines
- `POST /bids/validate` — checks structure of a bid request
- `GET /cohorts/{fleet}/{base}/{rank}` — mock competitiveness snapshot
- `GET /privacy` / `POST /privacy` — read/update privacy preferences

Replace mock returns with real parser output as we implement.
