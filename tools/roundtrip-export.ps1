param(
  [string]$SourceFile = "samples\demo.jss",
  [string]$Month = $(Get-Date -Format "yyyy-MM"),
  [string]$Crew = "USER",
  [switch]$AutoSeq,
  [string]$BaseUrl = "http://127.0.0.1:8000"
)

if (!(Test-Path $SourceFile)) { Write-Error "Source not found: $SourceFile"; exit 1 }

$docRoot = Join-Path $env:USERPROFILE "Documents\NextBid"
New-Item -ItemType Directory -Force -Path $docRoot | Out-Null

$raw = Get-Content -Raw -Encoding UTF8 $SourceFile
$payload = @{ text = $raw } | ConvertTo-Json

# Call the text endpoint
$tmp = Join-Path $env:TEMP "nextbid_export_tmp.jss"
curl.exe -s -H "Content-Type: application/json" -d "$payload" "$BaseUrl/bid/export.txt" -o "$tmp"

# Choose target path (uses your next-seq.ps1 when -AutoSeq is set)
$target = if ($AutoSeq) {
  & "$PSScriptRoot\next-seq.ps1" -Month $Month -Crew $Crew -Dir $docRoot
} else {
  Join-Path $docRoot ("nextbid_{0}_{1}.jss" -f $Crew, $Month)
}

# Use your preview pipeline (writes UTF-8+CRLF and opens folder)
& "$PSScriptRoot\preview-export.ps1" -SourceFile $tmp -Month $Month -Crew $Crew -AutoSeq:$AutoSeq
