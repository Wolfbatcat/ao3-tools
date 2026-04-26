param(
  [string]$TargetRepoPath,
  [ValidateSet("Skin", "Userscript", "Mixed")]
  [string]$ProjectType,
  [switch]$WithSkinTimestampUpdater,
  [switch]$Quiet
)

$ErrorActionPreference = "Stop"
$SuiteVersion = "1.0.0"
$GuideSourceName = "ao3-dev-guide"
$GuideManifestName = "ao3-dev-guide.json"
$SkinUpdaterName = "skin-timestamp-updater"
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

function Select-ProjectType {
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing
  $form = New-Object System.Windows.Forms.Form
  $form.Text = "AO3 Tools"
  $form.StartPosition = 'CenterScreen'
  $form.Size = New-Object System.Drawing.Size(360, 210)
  $form.FormBorderStyle = 'FixedDialog'
  $form.MaximizeBox = $false
  $form.MinimizeBox = $false
  $label = New-Object System.Windows.Forms.Label
  $label.Text = "What kind of AO3 project is this?"
  $label.AutoSize = $true
  $label.Location = New-Object System.Drawing.Point(25, 20)
  $form.Controls.Add($label)
  $choices = @('Skin', 'Userscript', 'Mixed')
  for ($i = 0; $i -lt $choices.Count; $i++) {
    $button = New-Object System.Windows.Forms.Button
    $button.Text = $choices[$i]
    $button.Size = New-Object System.Drawing.Size(290, 30)
    $button.Location = New-Object System.Drawing.Point(25, (55 + ($i * 38)))
    $value = $choices[$i]
    $button.Add_Click({ $form.Tag = $value; $form.DialogResult = [System.Windows.Forms.DialogResult]::OK; $form.Close() }.GetNewClosure())
    $form.Controls.Add($button)
  }
  if ($form.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) { throw "No project type selected." }
  return [string]$form.Tag
}

function Ask-YesNo {
  param([string]$Message, [string]$Title = "AO3 Tools")
  if ($Quiet) { return $false }
  Add-Type -AssemblyName System.Windows.Forms
  return ([System.Windows.Forms.MessageBox]::Show($Message, $Title, 'YesNo', 'Question') -eq [System.Windows.Forms.DialogResult]::Yes)
}

function Set-ManagedBlock {
  param([string]$Path, [string]$Start, [string]$End, [string]$Block)
  $dir = Split-Path -Parent $Path
  if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $normalizedBlock = ($Block -replace "`r?`n", "`r`n").Trim()
  $managed = "$Start`r`n$normalizedBlock`r`n$End"
  if (Test-Path -LiteralPath $Path) {
    $existing = Get-Content -Raw -LiteralPath $Path
    $pattern = [regex]::Escape($Start) + "(?s).*?" + [regex]::Escape($End) + "(`r?`n)*"
    if ([regex]::IsMatch($existing, $pattern)) {
      $updated = [regex]::Replace($existing, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $managed + "`r`n" }, 1)
    } else {
      $updated = $existing.TrimEnd() + "`r`n`r`n" + $managed + "`r`n"
    }
  } else {
    $updated = $managed + "`r`n"
  }
  [System.IO.File]::WriteAllText($Path, $updated, [System.Text.UTF8Encoding]::new($false))
}

function Test-GitRepo {
  param([string]$Target)
  return (Test-Path -LiteralPath (Join-Path $Target '.git'))
}

function Install-Hook {
  param([string]$Target)
  if (-not (Test-GitRepo $Target)) { return $false }
  $hookPath = Join-Path $Target '.git\hooks\pre-commit'
  $hookBlock = @"
# Run AO3 skin timestamp updater when present.
if command -v pwsh >/dev/null 2>&1; then
  pwsh -NoProfile -ExecutionPolicy Bypass -File "_scripts/skin-timestamp-updater/update-skin-timestamps.ps1"
else
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "_scripts/skin-timestamp-updater/update-skin-timestamps.ps1"
fi
"@
  Set-ManagedBlock -Path $hookPath -Start $HookStart -End $HookEnd -Block $hookBlock
  try { & chmod +x $hookPath 2>$null | Out-Null } catch {}
  return $true
}

if (-not $TargetRepoPath) { $TargetRepoPath = Select-Folder "Choose the repository to install AO3 Tools into." }
$TargetRepoPath = (Resolve-Path -LiteralPath $TargetRepoPath).Path

$existingManifestPath = Join-Path $TargetRepoPath '.ao3-tools\install-manifest.json'
$existingManifest = $null
$isUpdate = $false
if (Test-Path -LiteralPath $existingManifestPath) {
  try {
    $existingManifest = Get-Content -Raw -LiteralPath $existingManifestPath | ConvertFrom-Json
    $isUpdate = $true
  } catch {
    $existingManifest = $null
  }
}

if (-not $ProjectType) {
  if ($existingManifest -and $existingManifest.projectType) {
    $ProjectType = [string]$existingManifest.projectType
  } else {
    $ProjectType = Select-ProjectType
  }
}

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$guideSource = Join-Path $scriptRoot $GuideSourceName
$skinSource = Join-Path $scriptRoot $SkinUpdaterName
if (-not (Test-Path -LiteralPath $guideSource -PathType Container)) { throw "Missing guide source: $guideSource" }

$installSkin = $false
if ($ProjectType -eq 'Skin') { $installSkin = $true }
elseif ($ProjectType -eq 'Mixed') {
  if ($PSBoundParameters.ContainsKey('WithSkinTimestampUpdater')) { $installSkin = [bool]$WithSkinTimestampUpdater }
  elseif ($existingManifest -and @($existingManifest.installedModules) -contains 'skin-timestamp-updater') { $installSkin = $true }
  else { $installSkin = Ask-YesNo "Install AO3 skin timestamp updater too?" }
}

$installedModules = @('ao3-dev-guide')
$copiedPaths = New-Object System.Collections.Generic.List[string]
$managedFiles = @('CLAUDE.md', 'AGENTS.md', '.github/copilot-instructions.md')
$hookInstalled = $false

$docsDir = Join-Path $TargetRepoPath 'docs\ao3'
if (Test-Path -LiteralPath $docsDir) { Remove-Item -LiteralPath $docsDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $docsDir | Out-Null
Copy-Item -Path (Join-Path $guideSource '*') -Destination $docsDir -Recurse -Force
$copiedPaths.Add('docs/ao3')

$skinNote = ''
if ($installSkin) {
  if (-not (Test-Path -LiteralPath $skinSource -PathType Container)) { throw "Missing skin timestamp updater source: $skinSource" }
  $skinDest = Join-Path $TargetRepoPath "_scripts\$SkinUpdaterName"
  if (Test-Path -LiteralPath $skinDest) { Remove-Item -LiteralPath $skinDest -Recurse -Force }
  New-Item -ItemType Directory -Force -Path $skinDest | Out-Null
  Copy-Item -Path (Join-Path $skinSource '*') -Destination $skinDest -Recurse -Force
  $copiedPaths.Add("_scripts/$SkinUpdaterName")
  $installedModules += 'skin-timestamp-updater'
  $hookInstalled = Install-Hook $TargetRepoPath
  if ($hookInstalled) {
    $skinNote = "`r`nSkin timestamp updater is installed. Preserve AO3 skin CSS `Updated:` metadata; Git pre-commit refreshes it automatically."
  } else {
    $skinNote = "`r`nSkin timestamp updater files are installed, but this is not a Git repo, so no pre-commit hook was installed."
  }
}

$sharedIntro = @"
## AO3 Dev Guide Routing

AO3 reference docs live in `docs/ao3/`. Start with `docs/ao3/agent-routing.md` and load only task-relevant docs.

Rule type meanings:
- HARD RULE: AO3 enforces this through sanitizer, parser, runtime, or config.
- BASELINE: AO3 currently ships this style, DOM, class, or behavior; useful to match or override, not a requirement.
- RECOMMENDATION: Safer authoring or userscript practice; valid alternatives may exist.
- REFERENCE: Lookup data for selectors, tokens, constants, sprites, or routing.

Use `docs/ao3/$GuideManifestName` as machine-readable routing metadata.$skinNote
"@
$claudeBlock = @"
$sharedIntro
Read routing first: @docs/ao3/agent-routing.md

Common high-value imports:
- CSS/site skins: @docs/ao3/reference/css-rules.md @docs/ao3/reference/class-system.md @docs/ao3/reference/stylesheet-cascade.md
- Userscripts: @docs/ao3/reference/dom-patterns.md @docs/ao3/reference/js-patterns.md @docs/ao3/reference/js-api.md
- Work skins: @docs/ao3/reference/work-skin-classes.md
"@
$codexBlock = @"
$sharedIntro
For AO3 skin/userscript work, inspect `docs/ao3/agent-routing.md` before planning or editing. Do not treat BASELINE values as constraints. Do treat HARD RULE sections as implementation constraints.
"@
$copilotBlock = @"
# AO3 Dev Guide Routing

$sharedIntro
When answering AO3 skin or userscript questions, consult `docs/ao3/agent-routing.md` and the listed task-specific docs. Keep responses clear about HARD RULE vs BASELINE vs RECOMMENDATION.
"@

Set-ManagedBlock -Path (Join-Path $TargetRepoPath 'CLAUDE.md') -Start $GuideStart -End $GuideEnd -Block $claudeBlock.Trim()
Set-ManagedBlock -Path (Join-Path $TargetRepoPath 'AGENTS.md') -Start $GuideStart -End $GuideEnd -Block $codexBlock.Trim()
Set-ManagedBlock -Path (Join-Path $TargetRepoPath '.github\copilot-instructions.md') -Start $GuideStart -End $GuideEnd -Block $copilotBlock.Trim()

$manifestDir = Join-Path $TargetRepoPath '.ao3-tools'
New-Item -ItemType Directory -Force -Path $manifestDir | Out-Null
$manifest = [ordered]@{
  suiteVersion = $SuiteVersion
  projectType = $ProjectType
  installedAtUtc = if ($existingManifest -and $existingManifest.installedAtUtc) { [string]$existingManifest.installedAtUtc } else { (Get-Date).ToUniversalTime().ToString('o') }
  updatedAtUtc = (Get-Date).ToUniversalTime().ToString('o')
  installedModules = $installedModules
  copiedPaths = @($copiedPaths)
  managedFiles = $managedFiles
  guideMarkers = @{ start = $GuideStart; end = $GuideEnd }
  hook = @{ path = '.git/hooks/pre-commit'; installed = $hookInstalled; start = $HookStart; end = $HookEnd }
}
$manifest | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $manifestDir 'install-manifest.json') -Encoding UTF8

$verb = if ($isUpdate) { "updated" } else { "installed" }
$message = "AO3 Tools $verb.`r`n`r`nProject type: $ProjectType`r`nModules: $($installedModules -join ', ')`r`nTarget: $TargetRepoPath"
if ($installSkin -and -not $hookInstalled) { $message += "`r`n`r`nNote: Git repo not found; timestamp hook was not installed." }
Show-Info $message




