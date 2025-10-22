param(
  [string]$Month = (Get-Date -Format "yyyy-MM"),
  [string]$Crew = "USER",
  [string]$Dir = "$env:USERPROFILE\Documents\NextBid"
)

if (!(Test-Path $Dir)) { New-Item -ItemType Directory -Force -Path $Dir | Out-Null }

$pattern = "nextbid_{0}_{1}_" -f $Crew, $Month
$existing = Get-ChildItem -Path $Dir -Filter "$($pattern)*.jss" -ErrorAction SilentlyContinue
$max = 0
foreach ($f in $existing) {
  if ($f.BaseName -match "_(\d{2})$") {
    $n = [int]$Matches[1]
    if ($n -gt $max) { $max = $n }
  }
}
$next = "{0:D2}" -f ($max + 1)
"$Dir\nextbid_{0}_{1}_{2}.jss" -f $Crew, $Month, $next
