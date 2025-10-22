param([Parameter(Mandatory)][string]$Crew)

$cfg = Join-Path $PSScriptRoot "config.json"
@{ crew = $Crew } | ConvertTo-Json | Set-Content -Encoding UTF8 $cfg
Write-Host "Saved default crew: $Crew"
