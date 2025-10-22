param(
  [string]$File,
  [string]$BaseUrl = "http://127.0.0.1:8000",
  [switch]$Raw,
  [switch]$DebugBody
)

function Find-LatestExport {
  $dir = Join-Path $env:USERPROFILE "Documents\NextBid"
  if (!(Test-Path $dir)) { return $null }
  Get-ChildItem $dir -Filter *.jss -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

# Resolve file
if (-not $File -or $File.Trim().Length -eq 0) {
  $latest = Find-LatestExport
  if (-not $latest) { Write-Error "No .jss file found. Pass -File <path> or create an export."; exit 2 }
  $File = $latest.FullName
}
if (-not (Test-Path $File)) { Write-Error "File not found: $File"; exit 2 }

# Force-read UTF-8 text as a .NET string (avoids PS objects like FileInfo, etc.)
$resolved = (Resolve-Path $File).Path
$text     = [System.IO.File]::ReadAllText($resolved, [System.Text.Encoding]::UTF8)

# Build compact JSON
$payload = @{ text = $text } | ConvertTo-Json -Compress

if ($DebugBody) {
  $preview = $payload.Substring(0, [Math]::Min(160, $payload.Length)).Replace("`r","␍").Replace("`n","␊")
  Write-Host "[debug] payload length: $($payload.Length) chars" -ForegroundColor DarkGray
  Write-Host "[debug] preview: $preview..." -ForegroundColor DarkGray
}

# Ensure HttpClient types exist (classic Windows PowerShell needs this)
try { Add-Type -AssemblyName System.Net.Http -ErrorAction Stop } catch { }

# Send with HttpClient as UTF-8 application/json
try {
  $handler = New-Object System.Net.Http.HttpClientHandler
  $client  = New-Object System.Net.Http.HttpClient($handler)
  $content = New-Object System.Net.Http.StringContent($payload, [System.Text.Encoding]::UTF8, "application/json")
  $response = $client.PostAsync("$BaseUrl/bid/validate", $content).Result

  $status = [int]$response.StatusCode
  $respContent = $response.Content.ReadAsStringAsync().Result

  if (-not $response.IsSuccessStatusCode) {
    Write-Error "Request failed: HTTP $status`n$respContent"
    exit 3
  }

  $resp = [pscustomobject]@{ Content = $respContent }
} catch {
  Write-Error "Request failed: $($_.Exception.Message)"
  exit 3
}

if ($Raw) { $resp.Content; exit 0 }

# Pretty output
$data = $resp.Content | ConvertFrom-Json
$ok   = [bool]$data.ok
$g    = $data.groups
$tot  = $data.total_lines
$counts = ($data.line_counts -join ", ")

$status = "FAILED"; $color = "Red"
if ($ok) { $status = "OK"; $color = "Green" }

Write-Host "Validate: $resolved" -ForegroundColor Cyan
Write-Host ("Status  : {0}" -f $status) -ForegroundColor $color
Write-Host "Groups  : $g"
Write-Host "Lines   : $tot  (per-group: $counts)"

if ($null -ne $data.errors -and $data.errors.Count -gt 0) {
  Write-Host "`nErrors:" -ForegroundColor Red
  $i = 1; foreach ($e in $data.errors) { Write-Host ("  {0}. {1}" -f $i++, $e) -ForegroundColor Red }
}
if ($null -ne $data.warnings -and $data.warnings.Count -gt 0) {
  Write-Host "`nWarnings:" -ForegroundColor Yellow
  $i = 1; foreach ($w in $data.warnings) { Write-Host ("  {0}. {1}" -f $i++, $w) -ForegroundColor Yellow }
}

if ($ok) { exit 0 } else { exit 1 }
