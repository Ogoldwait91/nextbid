param(
  [string]$Base = "http://127.0.0.1:8000",
  [string]$Month = "2025-11"
)

function Hit($path) {
  try {
    $r = Invoke-RestMethod "$Base$path" -TimeoutSec 5
    Write-Host "OK  $path" -ForegroundColor Green
    return $r
  } catch {
    Write-Host "ERR $path  -> $($_.Exception.Message)" -ForegroundColor Red
    throw
  }
}

# Required endpoints for Pre-Process page:
Hit "/healthz"        | Out-Null
$c = Hit "/credit/$Month"
if ($null -eq $c.min -or $null -eq $c.max -or $null -eq $c.default) {
  throw "credit endpoint missing numeric min/max/default"
}
Hit "/calendar/$Month"  | Out-Null
Hit "/reserves/$Month"  | Out-Null

Write-Host "All required endpoints passed." -ForegroundColor Cyan
