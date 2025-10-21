param(
  [string]$SourceFile = "export.jss",
  [string]$Month = $(Get-Date -Format "yyyy-MM")
)

$docRoot = Join-Path $env:USERPROFILE "Documents\NextBid"
New-Item -ItemType Directory -Force -Path $docRoot | Out-Null

$target = Join-Path $docRoot ("export_{0}.jss" -f $Month)

function To-Crlf([string]$text) {
  # normalise to LF then to CRLF to avoid mixed endings
  $lf = $text -replace "`r`n", "`n" -replace "`r", "`n"
  return ($lf -replace "`n", "`r`n")
}

if (Test-Path $SourceFile) {
  $raw = Get-Content -Raw -Encoding UTF8 $SourceFile
} else {
  Write-Host "No $SourceFile found — using a tiny placeholder so you can test CRLF output."
  $raw = @"
!GROUP 1
 SET CREDIT 500-540
 WAIVE LONGHAUL
!END GROUP
"@
}

$crlf = To-Crlf $raw

# Write as UTF-8 (no BOM) with CRLF
[System.IO.File]::WriteAllText($target, $crlf, New-Object System.Text.UTF8Encoding($false))

Write-Host "Saved preview:" -ForegroundColor Green
Write-Host " $target"

# Quick sanity: show the first 3 lines & hex check for 0D-0A
(Get-Content -TotalCount 3 -Path $target) | ForEach-Object { "  " + $_ }
$bytes = [IO.File]::ReadAllBytes($target)
$hex = [BitConverter]::ToString($bytes)
if ($hex -match "0D-0A") { Write-Host "✔ CRLF line endings detected" -ForegroundColor Green } else { Write-Warning "LF endings detected" }

# Open the folder in Explorer
ii $docRoot
