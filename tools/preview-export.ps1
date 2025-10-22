param(
  [string]$SourceFile = "export.jss",
  [string]$Month = $(Get-Date -Format "yyyy-MM"),
  [string]$Crew = "USER",
  [switch]$AutoSeq
)
)

$docRoot = Join-Path $env:USERPROFILE "Documents\NextBid"
New-Item -ItemType Directory -Force -Path $docRoot | Out-Null

$target = if ($AutoSeq) {
  & "$PSScriptRoot\next-seq.ps1" -Month $Month -Crew $Crew -Dir $docRoot
} else {
  Join-Path $docRoot ("nextbid_{0}_{1}.jss" -f $Crew, $Month)
}

function To-Crlf([string]$text) {
  # Normalise all endings to LF, then join as CRLF
  $lf = $text -replace "`r`n", "`n" -replace "`r", "`n"
  $crlf = ($lf -split "`n") -join "`r`n"
  # Ensure trailing CRLF so checks see at least one line ending if content exists
  if ($crlf.Length -gt 0 -and -not $crlf.EndsWith("`r`n")) { $crlf += "`r`n" }
  return $crlf
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

# Sanity: show first 3 lines
(Get-Content -TotalCount 3 -Path $target) | ForEach-Object { "  " + $_ }

# Robust CRLF detection
$bytes = [IO.File]::ReadAllBytes($target)
# Count CRLF pairs
$crlfCount = 0
for ($i=0; $i -lt $bytes.Length-1; $i++) { if ($bytes[$i] -eq 13 -and $bytes[$i+1] -eq 10) { $crlfCount++ } }
if ($crlfCount -gt 0) {
  Write-Host "✔ CRLF endings detected ($crlfCount occurrences)" -ForegroundColor Green
} else {
  Write-Warning "No CRLF sequences found"
}

# Open the folder in Explorer
ii $docRoot

