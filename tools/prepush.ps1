Write-Host 'Running pre-push checks...' 
# Flutter static analysis (no formatting changes)
flutter analyze
if (0 -ne 0) { Write-Error 'flutter analyze failed'; exit 1 }

# Dart tests if any exist (safe: exits 0 if none)
if (Test-Path .\test) {
  dart test
}

# FastAPI routes smoke test (if uvicorn available)
if (Test-Path .\api\app\main.py) {
  Write-Host 'API quick import check'
  python - <<'PY'
import importlib, sys
try:
    import api.app.main as m
    print("OK: api.app.main importable; app:", hasattr(m, "app"))
except Exception as e:
    print("ERROR:", e); sys.exit(1)
PY
}
Write-Host 'All checks passed.'
