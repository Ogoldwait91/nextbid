Write-Host "Running pre-push checks..."

# 1) Flutter static analysis
flutter analyze --no-fatal-infos --no-fatal-warnings
if ($LASTEXITCODE -ne 0) { Write-Error "flutter analyze --no-fatal-infos --no-fatal-warnings failed"; exit 1 }

# 2) Dart/Flutter tests
flutter test -r expanded
if ($LASTEXITCODE -ne 0) { Write-Error "flutter test -r expanded failed"; exit 1 }

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



Write-Host "Running export validation (non-blocking)..." -ForegroundColor Cyan

# Settings
$BaseUrl = $env:NEXTBID_API_URL
if (-not $BaseUrl -or $BaseUrl.Trim() -eq "") { $BaseUrl = "http://127.0.0.1:8000" }

function Test-ApiHealthy([string]$Url) {
  try {
    $r = Invoke-WebRequest -Uri "$Url/healthz" -Method GET -UseBasicParsing -TimeoutSec 2
    return ($r.StatusCode -eq 200)
  } catch { return $false }
}

function Get-LatestExport {
  $dir = Join-Path $env:USERPROFILE "Documents\NextBid"
  if (!(Test-Path $dir)) { return $null }
  Get-ChildItem $dir -Filter *.jss -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

$latest = Get-LatestExport

if (-not $latest) {
  Write-Host "No exports found; skipping validation." -ForegroundColor DarkYellow
} elseif (-not (Test-ApiHealthy $BaseUrl)) {
  Write-Host "API not reachable at $BaseUrl; skipping validation." -ForegroundColor DarkYellow
} else {
  Write-Host ("Validating: {0}" -f $latest.FullName) -ForegroundColor DarkGray
  & "$PSScriptRoot\validate.ps1" -File $latest.FullName -BaseUrl $BaseUrl
  $exit = $LASTEXITCODE
  if ($exit -ne 0) {
    Write-Warning "Validation reported issues for $($latest.Name). Review before pushing."
  } else {
    Write-Host "Validation OK." -ForegroundColor Green
  }
}
