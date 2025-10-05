\
    param(
      [int]$Port = 8000
    )
    Set-Location -Path $PSScriptRoot
    if (-not (Test-Path ".venv")) {
      python -m venv .venv
    }
    .\.venv\Scripts\Activate.ps1
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    $env:UVICORN_HOST = "127.0.0.1"
    $env:UVICORN_PORT = "$Port"
    python - << 'PY'
import os, uvicorn
from app.main import app
uvicorn.run(app, host=os.getenv("UVICORN_HOST","127.0.0.1"), port=int(os.getenv("UVICORN_PORT","8000")), reload=True)
PY
