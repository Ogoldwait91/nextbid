param(
  [string]$ExportFile = (Join-Path $env:USERPROFILE "Documents\NextBid\export_$(Get-Date -Format 'yyyy-MM').jss"),
  [int]$MinBytes = 256   # warn if smaller than this
)

function Test-Crlf([byte[]]$bytes) {
  $count = 0
  for ($i=0; $i -lt $bytes.Length-1; $i++) {
    if ($bytes[$i] -eq 13 -and $bytes[$i+1] -eq 10) { $count++ }
  }
  return $count
}

if (-not (Test-Path $ExportFile)) {
  Write-Error "Export file not found: $ExportFile"
  exit 1
}

$bytes = [IO.File]::ReadAllBytes($ExportFile)
$size  = $bytes.Length
$crlf  = Test-Crlf $bytes

if ($crlf -gt 0) {
  Write-Host "✔ CRLF line endings detected ($crlf occurrences)" -ForegroundColor Green
} else {
  Write-Warning "No CRLF sequences found."
}

if ($size -lt $MinBytes) {
  $kb = [Math]::Round($size/1KB, 2)
  Write-Warning "Export file size is small ($kb KB, $size bytes) — sanity-check your content."
} else {
  $kb = [Math]::Round($size/1KB, 2)
  Write-Host "✔ File size looks reasonable: $kb KB ($size bytes)" -ForegroundColor Green
}

# Light structure sniff: warn if the file looks like pure JSON
try {
  $asText = [System.Text.Encoding]::UTF8.GetString($bytes)
  if ($asText.Trim().StartsWith('{') -and $asText.Trim().EndsWith('}')) {
    Write-Warning "Content looks like JSON; JSS should be plain text commands."
  }
} catch {}
