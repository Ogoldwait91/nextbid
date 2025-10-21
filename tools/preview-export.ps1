param(
  [string]$SourceFile = "export.jss",
  [string]$Month = $(Get-Date -Format "yyyy-MM")
)

$docRoot = Join-Path $env:USERPROFILE "Documents\NextBid"
New-Item -ItemType Directory -Force -Path $docRoot | Out-Null

$target = Join-Path $docRoot ("export_{0}.jss" -f $Month)

function To-Crlf([string]$text) {
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

# Write as UTF-8 (no BOM) with CRLF — WinPS-safe
$enc = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($target, $crlf, $enc)

Write-Host "Saved preview:" -ForegroundColor Green
Write-Host " $target"

(Get-Content -TotalCount 3 -Path $target) | ForEach-Object { "  " + $_ }
$bytes = [IO.File]::ReadAllBytes($target)
$hex = [BitConverter]::ToString($bytes)
if ($hex -match "0D-0A") { Write-Host "✔ CRLF line endings detected" -ForegroundColor Green } else { Write-Warning "LF endings detected" }

ii $docRoot
