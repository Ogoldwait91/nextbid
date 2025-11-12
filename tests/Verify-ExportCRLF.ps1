param(
  [Parameter(Mandatory=$true)] [string]$Path
)

if (!(Test-Path $Path)) { Write-Error "File not found: $Path"; exit 2 }

$bytes = [IO.File]::ReadAllBytes((Resolve-Path $Path))
if ($bytes.Length -eq 0) { Write-Error "FAIL: $Path is empty"; exit 1 }

# Detect BOM / encoding
# UTF-8 BOM: EF BB BF
# UTF-16 LE: FF FE
# UTF-16 BE: FE FF
$encoding = "utf8"  # default assume utf8 (no BOM)
if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) { $encoding = "utf8-bom" }
elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xFE) { $encoding = "utf16-le" }
elseif ($bytes.Length -ge 2 -and $bytes[0] -eq 0xFE -and $bytes[1] -eq 0xFF) { $encoding = "utf16-be" }

# Build a hex string for simple pattern checks
$hex = [BitConverter]::ToString($bytes)

# Count CRLF & lone LF based on encoding
switch ($encoding) {
  "utf16-le" {
    # CRLF = 0D-00-0A-00 ; lone LF (without preceding CR) =~ (?<!0D-00-)0A-00
    $crlf = ([regex]::Matches($hex, "0D-00-0A-00")).Count
    $lflone = ([regex]::Matches($hex, "(?<!0D-00-)0A-00")).Count
  }
  "utf16-be" {
    # CRLF = 00-0D-00-0A ; lone LF =~ (?<!00-0D-)00-0A
    $crlf = ([regex]::Matches($hex, "00-0D-00-0A")).Count
    $lflone = ([regex]::Matches($hex, "(?<!00-0D-)00-0A")).Count
  }
  default {
    # UTF-8/ANSI path
    $crlf = ([regex]::Matches($hex, "0D-0A")).Count
    $lflone = ([regex]::Matches($hex, "(?<!0D-)0A")).Count
  }
}

# Also check if file has any newline at all (any 0A byte in its encoding)
$hasLF = switch ($encoding) {
  "utf16-le" { $hex -match "0A-00" }
  "utf16-be" { $hex -match "00-0A" }
  default    { $hex -match "0A" }
}

if (-not $hasLF) {
  Write-Error "FAIL: $Path has no newline characters (single-line or binary?)"
  exit 1
}

if ($crlf -gt 0 -and $lflone -eq 0) {
  Write-Host "OK ($encoding): strict CRLF verified in $Path"
  exit 0
} else {
  Write-Error ("FAIL: {0} is not strictly CRLF (encoding={1}, CRLF={2}, loneLF={3})" -f $Path,$encoding,$crlf,$lflone)
  exit 1
}
