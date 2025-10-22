param(
  [string]$SourceFile = "export.jss",
  [string]$Month = $(Get-Date -Format "yyyy-MM"),
  [string]$Crew = "USER",
  [switch]$AutoSeq
)
# Load default crew from local config if not explicitly provided
try {
  $cfgPath = Join-Path $PSScriptRoot "config.json"
  if ($Crew -eq "USER" -and (Test-Path $cfgPath)) {
    $cfg = Get-Content -Raw $cfgPath | ConvertFrom-Json
    if ($cfg.crew) { $Crew = "$($cfg.crew)" }
  }
} catch {}
$docRoot = Join-Path $env:USERPROFILE "Documents\NextBid"
New-Item -ItemType Directory -Force -Path $docRoot | Out-Null

# Choose target file path
if ($AutoSeq) {
  $target = & "$PSScriptRoot\next-seq.ps1" -Month $Month -Crew $Crew -Dir $docRoot
} else {
  $target = Join-Path $docRoot ("nextbid_{0}_{1}.jss" -f $Crew, $Month)
# Load default crew from local config if not explicitly provided
try {
  $cfgPath = Join-Path $PSScriptRoot "config.json"
  if ($Crew -eq "USER" -and (Test-Path $cfgPath)) {
    $cfg = Get-Content -Raw $cfgPath | ConvertFrom-Json
    if ($cfg.crew) { $Crew = "$($cfg.crew)" }
  }
} catch {}
}

function To-Crlf([string]$text) {
  # Normalize to LF then to CRLF, and ensure trailing CRLF for non-empty files
  $lf = $text -replace "`r`n", "`n" -replace "`r", "`n"
  $crlf = ($lf -split "`n") -join "`r`n"
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
# Load default crew from local config if not explicitly provided
try {
  $cfgPath = Join-Path $PSScriptRoot "config.json"
  if ($Crew -eq "USER" -and (Test-Path $cfgPath)) {
    $cfg = Get-Content -Raw $cfgPath | ConvertFrom-Json
    if ($cfg.crew) { $Crew = "$($cfg.crew)" }
  }
} catch {}
[System.IO.File]::WriteAllText($target, $crlf, $enc)
# Load default crew from local config if not explicitly provided
try {
  $cfgPath = Join-Path $PSScriptRoot "config.json"
  if ($Crew -eq "USER" -and (Test-Path $cfgPath)) {
    $cfg = Get-Content -Raw $cfgPath | ConvertFrom-Json
    if ($cfg.crew) { $Crew = "$($cfg.crew)" }
  }
} catch {}
Write-Host "Saved preview:" -ForegroundColor Green
Write-Host " $target"

# Show first 3 lines
(Get-Content -TotalCount 3 -Path $target) | ForEach-Object { "  " + $_ }

# Count CRLFs
$bytes = [IO.File]::ReadAllBytes($target)
# Load default crew from local config if not explicitly provided
try {
  $cfgPath = Join-Path $PSScriptRoot "config.json"
  if ($Crew -eq "USER" -and (Test-Path $cfgPath)) {
    $cfg = Get-Content -Raw $cfgPath | ConvertFrom-Json
    if ($cfg.crew) { $Crew = "$($cfg.crew)" }
  }
} catch {}
$crlfCount = 0
for ($i=0; $i -lt $bytes.Length-1; $i++) { if ($bytes[$i] -eq 13 -and $bytes[$i+1] -eq 10) { $crlfCount++ } }
if ($crlfCount -gt 0) {
  Write-Host "✔ CRLF endings detected ($crlfCount occurrences)" -ForegroundColor Green
} else {
  Write-Warning "No CRLF sequences found"
}

# Open the folder in Explorer
ii $docRoot

