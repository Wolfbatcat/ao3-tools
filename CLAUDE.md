# ao3-tools

AO3 Tools is a portable suite for AO3 skin and userscript repositories. Users should run the root BAT launchers, not internal PowerShell scripts.

## Tools

### AO3 Dev Guide

Source: `_scripts/ao3-dev-guide/`

AI-readable reference docs for AO3 site skins, work skins, and userscripts. Installer copies guide entrypoints to `docs/ao3/` and reference docs to `docs/ao3/reference/` and writes managed AO3 routing blocks to:

- `CLAUDE.md`
- `AGENTS.md`
- `.github/copilot-instructions.md`

The guide uses section `Type:` labels:

- `HARD RULE`: enforced by AO3 sanitizer, parser, runtime, or config.
- `BASELINE`: current AO3 defaults; reference points, not constraints.
- `RECOMMENDATION`: safer practice, not the only valid path.
- `REFERENCE`: lookup data.

### Skin Timestamp Updater

Source: `_scripts/skin-timestamp-updater/`

Optional skin-repo automation. It installs a managed Git pre-commit hook block and updates staged CSS files containing `Updated:`. It skips examples/templates and never touches `.js` userscripts.

Git is required for automatic timestamp updates. Node is not required.

## Installer UX

- `Install AO3 Tools.bat`: double-click installer with folder picker and project type choice.
- `Uninstall AO3 Tools.bat`: double-click uninstaller with folder picker and confirmation.
- `_scripts/install-ao3-tools.ps1` and `_scripts/uninstall-ao3-tools.ps1` are internal implementation scripts.

## Maintenance Notes

- Keep user-facing docs focused on the BAT launcher flow.
- Keep install/update/uninstall idempotent.`r`n- Rerunning the installer on a repo with `.ao3-tools/install-manifest.json` is the update path.
- Preserve user content outside managed blocks.
- Never delete user-created CSS or JavaScript files during uninstall.
- Update `docs/ao3/agent-routing.md` guidance whenever installer behavior changes.

