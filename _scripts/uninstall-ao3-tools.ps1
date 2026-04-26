param(
  [string]$TargetRepoPath,
  [switch]$Force,
  [switch]$Quiet
)

$ErrorActionPreference = "Stop"
$GuideStart = "<!-- AO3-GUIDE:START -->"
$GuideEnd = "<!-- AO3-GUIDE:END -->"
$HookStart = "# AO3-TOOLS:START"
$HookEnd = "# AO3-TOOLS:END"

function Show-Info {
  param([string]$Message, [string]$Title = "AO3 Tools")
  if ($Quiet) { Write-Host $Message; return }
  Add-Type -AssemblyName System.Windows.Forms -ErrorAction SilentlyContinue
  [System.Windows.Forms.MessageBox]::Show($Message, $Title, 'OK', 'Information') | Out-Null
}

function Select-Folder {
  param([string]$Description)
  Add-Type -AssemblyName System.Windows.Forms
  $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
  $dialog.Description = $Description
  $dialog.ShowNewFolderButton = $false
  if ($dialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { throw "No target folder selected." }
  return $dialog.SelectedPath
}

function Confirm-Uninstall {
  param([string]$Target)
  if ($Force -or $Quiet) { return $true }
  Add-Type -AssemblyName System.Windows.Forms
  return ([System.Windows.Forms.MessageBox]::Show("Uninstall AO3 Tools from:`r`n$Target`r`n`r`nUser CSS and JS files will not be removed.", "AO3 Tools", 'YesNo', 'Warning') -eq [System.Windows.Forms.DialogResult]::Yes)
}

function Remove-ManagedBlock {
  param([string]$Path, [string]$Start, [string]$End, [switch]$DeleteIfEmpty)
  if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
  $text = Get-Content -Raw -LiteralPath $Path
  $pattern = [regex]::Escape($Start) + "(?s).*?" + [regex]::Escape($End) + "(`r?`n)*"
  if (-not [regex]::IsMatch($text, $pattern)) { return }
  $updated = [regex]::Replace($text, $pattern, '', 1).TrimEnd()
  if ($updated.Length -eq 0 -and $DeleteIfEmpty) {
    Remove-Item -LiteralPath $Path -Force
  } else {
    [System.IO.File]::WriteAllText($Path, $updated + "`r`n", [System.Text.UTF8Encoding]::new($false))
  }
}

function Remove-EmptyDir {
  param([string]$Path)
  if (Test-Path -LiteralPath $Path -PathType Container) {
    if (-not (Get-ChildItem -LiteralPath $Path -Force | Select-Object -First 1)) {
      Remove-Item -LiteralPath $Path -Force
    }
  }
}

if (-not $TargetRepoPath) { $TargetRepoPath = Select-Folder "Choose the repository to uninstall AO3 Tools from." }
$TargetRepoPath = (Resolve-Path -LiteralPath $TargetRepoPath).Path
if (-not (Confirm-Uninstall $TargetRepoPath)) { exit 0 }

$manifestPath = Join-Path $TargetRepoPath '.ao3-tools\install-manifest.json'
$knownCopiedPaths = @('docs/ao3', '_scripts/skin-timestamp-updater')
$managedFiles = @('CLAUDE.md', 'AGENTS.md', '.github/copilot-instructions.md')
$hookPath = '.git/hooks/pre-commit'

if (Test-Path -LiteralPath $manifestPath) {
  $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
  if ($manifest.copiedPaths) { $knownCopiedPaths = @($manifest.copiedPaths) }
  if ($manifest.managedFiles) { $managedFiles = @($manifest.managedFiles) }
  if ($manifest.hook.path) { $hookPath = [string]$manifest.hook.path }
}

foreach ($file in $managedFiles) {
  Remove-ManagedBlock -Path (Join-Path $TargetRepoPath $file) -Start $GuideStart -End $GuideEnd -DeleteIfEmpty
}
Remove-ManagedBlock -Path (Join-Path $TargetRepoPath $hookPath) -Start $HookStart -End $HookEnd -DeleteIfEmpty

foreach ($relative in $knownCopiedPaths) {
  $full = Join-Path $TargetRepoPath $relative
  if (($relative -in @('docs/ao3', '_scripts/skin-timestamp-updater')) -and (Test-Path -LiteralPath $full)) {
    Remove-Item -LiteralPath $full -Recurse -Force
  }
}

if (Test-Path -LiteralPath $manifestPath) { Remove-Item -LiteralPath $manifestPath -Force }
Remove-EmptyDir (Join-Path $TargetRepoPath '.ao3-tools')
Remove-EmptyDir (Join-Path $TargetRepoPath '.github')
Remove-EmptyDir (Join-Path $TargetRepoPath '_scripts')
Remove-EmptyDir (Join-Path $TargetRepoPath 'docs')

Show-Info "AO3 Tools uninstalled from:`r`n$TargetRepoPath`r`n`r`nUser CSS and JS files were not removed."

