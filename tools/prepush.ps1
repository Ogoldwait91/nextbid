Write-Host "Running pre-push checks..."

# 1) Flutter static analysis
flutter analyze --no-fatal-infos --no-fatal-warnings
if ($LASTEXITCODE -ne 0) { Write-Error "flutter analyze --no-fatal-infos --no-fatal-warnings failed"; exit 1 }

# 2) Dart/Flutter tests
dart test
if ($LASTEXITCODE -ne 0) { Write-Error "dart test failed"; exit 1 }

# 3) API health ping (optional if not running)
try {
  $r = Invoke-WebRequest -UseBasicParsing -TimeoutSec 2 http://127.0.0.1:8000/healthz
  if ($r.StatusCode -eq 200 -and $r.Content -match '"ok":\s*true') {
    Write-Host "API /healthz OK"
  } else {
    Write-Warning "API /healthz responded but not OK: $($r.StatusCode) $($r.Content)"
  }
} catch {
  Write-Host "API not running; skipping /healthz ping."
}

Write-Host "All checks passed."
