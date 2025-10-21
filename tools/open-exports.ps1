# Opens project\exports; creates it if missing
$dir = Join-Path $PWD "exports"
if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
ii $dir
