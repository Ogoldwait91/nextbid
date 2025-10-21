param()

$FilePath = "C:\nextbid_demo\lib\features\build\build_page.dart"

$ErrorActionPreference = "Stop"

if (-not (Test-Path $FilePath)) {
  throw "Can't find $FilePath"
}

# Backup
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$bak   = "$FilePath.autofix-$stamp.bak"
Copy-Item $FilePath $bak -Force
Write-Host "✓ Backup created: $bak"

# Load entire file
$code = Get-Content $FilePath -Raw

# Remove everything from the helper marker to end of file
$marker = "/* === Safe selection helpers"
$idx = $code.IndexOf($marker, [StringComparison]::OrdinalIgnoreCase)
if ($idx -ge 0) {
  $code = $code.Substring(0, $idx).TrimEnd() + "`r`n"
  Write-Host "→ Removed trailing helper block starting at byte offset $idx"
} else {
  Write-Host "ℹ Helper block marker not found; continuing."
}

# Remove any mid-file import lines (imports must be at the very top)
# Specifically nuke: import "dart:math" as _math;  (and any other import that slipped down)
$code = [regex]::Replace($code, '^\s*import\s+["'']dart:math["'']\s+as\s+_math\s*;\s*$', '', 'Multiline')
$code = [regex]::Replace($code, '(?m)^(?!\A)(\s*import\s+["''].*?["'']\s*;\s*)$', '')

# Fix mojibake bullets to a real bullet "•"
$code = $code -replace 'ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¢','•'

# Save
Set-Content -Encoding UTF8 $FilePath $code
Write-Host "✓ Saved cleaned build_page.dart"

# Git commit + analyze
Set-Location "C:\nextbid_demo"
git add "lib\features\build\build_page.dart"
git commit -m "chore(build): remove stray helper block & mid-file import; fix bullet encoding" | Out-Null
flutter analyze
