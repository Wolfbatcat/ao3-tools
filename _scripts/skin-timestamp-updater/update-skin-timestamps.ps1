$ErrorActionPreference = "Stop"

function Normalize-GitPath {
  param([string]$Path)
  return ($Path -replace '\\', '/').Trim()
}

function Should-SkipCssFile {
  param([string]$Path)
  $p = Normalize-GitPath $Path
  if ($p -match '(^|/)_scripts/skin-timestamp-updater/examples/.*\.css$') { return $true }
  if ($p -match '^docs/ao3/') { return $true }
  return $false
}

$stagedFiles = @(& git diff --cached --name-only --diff-filter=ACM -- '*.css') | Where-Object { $_ }
if (-not $stagedFiles -or $stagedFiles.Count -eq 0) { exit 0 }

$now = (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd HH:mm UTC')
$updatedCount = 0

foreach ($file in $stagedFiles) {
  $gitPath = Normalize-GitPath $file
  if (Should-SkipCssFile $gitPath) { continue }
  if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { continue }

  $resolved = (Resolve-Path -LiteralPath $file).Path
  $content = [System.IO.File]::ReadAllText($resolved)
  if ($content -notmatch 'Updated:') { continue }

  $newContent = [regex]::Replace($content, '(?m)(Updated:\s*).*$', '${1}' + $now)
  if ($newContent -ne $content) {
    [System.IO.File]::WriteAllText($resolved, $newContent, [System.Text.UTF8Encoding]::new($false))
    & git add -- $file
    if ($LASTEXITCODE -ne 0) { throw "git add failed for $file" }
    Write-Host "Updated skin timestamp: $gitPath"
    $updatedCount++
  }
}

if ($updatedCount -gt 0) {
  Write-Host "AO3 skin timestamps updated: $updatedCount file(s)."
}
