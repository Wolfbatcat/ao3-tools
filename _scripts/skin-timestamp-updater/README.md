# AO3 Skin Timestamp Updater

Automatically refreshes AO3 skin CSS `Updated:` metadata when CSS files are committed.

## Setup

Use the top-level `Install AO3 Tools.bat` launcher from the `ao3-tools` folder and choose **Skin** or **Mixed**. The installer copies this tool into your repo and activates the Git pre-commit hook automatically.

Manual PowerShell setup is only for maintainers and troubleshooting; normal users should not need it.

## Requirements

- Git is required for automatic commit-time timestamp updates.
- Node.js is not required.
- Windows PowerShell is used internally by the hook.

## Trigger

Add an `Updated:` line to skin CSS metadata:

```css
- Updated:      0000-00-00 00:00 UTC
```

On commit, staged CSS files containing `Updated:` are rewritten with current UTC time and re-staged.

## Exclusions

The updater never changes:

- `_scripts/skin-timestamp-updater/examples/*.css`
- `docs/ao3/**`
- any `.js` userscript
- CSS files that do not contain `Updated:`

Example files are templates. Copy an example to your own CSS file before editing it as a real skin.

## Uninstall

Use the top-level `Uninstall AO3 Tools.bat` launcher. It removes this tool and its managed Git hook block without deleting user-created CSS or JavaScript files.
