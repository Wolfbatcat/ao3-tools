# AO3 Tools

AO3 Tools is a portable toolkit for AO3 skin and userscript projects.

It includes two tools:

- **AO3 Dev Guide**: AI-readable AO3 reference docs plus Claude Code, Codex, and GitHub Copilot routing instructions.
- **Skin Timestamp Updater**: optional Git pre-commit automation for AO3 skin CSS `Updated:` metadata.

## Quick Start

1. Download or clone this `ao3-tools` folder.
2. Double-click `Install AO3 Tools.bat`.
3. Pick the target repository folder.
4. Choose the project type:
   - **Skin**: installs the AO3 Dev Guide and Skin Timestamp Updater.
   - **Userscript**: installs the AO3 Dev Guide only.
   - **Mixed**: installs the AO3 Dev Guide and asks whether to add Skin Timestamp Updater.

No command line is required. PowerShell is used internally by the launcher.

## What Gets Installed

Every project gets:

- `docs/ao3/README.md` human overview
- `docs/ao3/agent-routing.md` AI entrypoint
- `docs/ao3/ao3-dev-guide.json` machine-readable routing metadata
- `docs/ao3/reference/` AO3 reference docs
- managed AO3 blocks in `CLAUDE.md`, `AGENTS.md`, and `.github/copilot-instructions.md`
- `.ao3-tools/install-manifest.json`

Skin projects also get:

- `_scripts/skin-timestamp-updater/`
- a managed block in `.git/hooks/pre-commit`

## Requirements

- Git is required only for automatic skin timestamp updates.
- Node.js is not required.
- Windows PowerShell is used internally. Users do not need to type PowerShell commands.

## Skin Timestamp Trigger

Skin CSS files update automatically on commit when they contain an `Updated:` line:

```css
- Updated:      0000-00-00 00:00 UTC
```

The updater changes staged CSS files, re-stages them, and skips templates in `_scripts/skin-timestamp-updater/examples/`.

## Updating Existing Installs

Double-click `Install AO3 Tools.bat` again and choose a repository that already has AO3 Tools installed. The installer reads `.ao3-tools/install-manifest.json`, keeps the installed project type/modules, and refreshes toolkit-owned guide files, updater files, managed AI blocks, and managed hook block.

## Uninstall

Double-click `Uninstall AO3 Tools.bat`, choose the target repository, and confirm.

The uninstaller removes only toolkit-owned docs, scripts, managed instruction blocks, managed hook block, and manifest. It does not delete user-created `.css` or `.js` files.

## Tool Sources

- `_scripts/ao3-dev-guide/` contains the source reference docs copied into target repos.
- `_scripts/skin-timestamp-updater/` contains the timestamp automation copied into skin repos. Its README is `_scripts/skin-timestamp-updater/README.md`.
- `_scripts/install-ao3-tools.ps1` and `_scripts/uninstall-ao3-tools.ps1` are internal launcher targets.


