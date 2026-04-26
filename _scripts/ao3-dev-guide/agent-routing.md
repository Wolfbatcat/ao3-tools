# AO3 Dev Guide Agent Routing

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.

Use this file first. Read only the docs needed for the task, then follow each section's `Type:` label.

## Before Planning
Type: RECOMMENDATION + REFERENCE

- Identify project type: site skin, work skin, userscript, or mixed.
- Read the relevant docs below before proposing selectors, CSS properties, JS hooks, z-index values, or AO3 constants.
- Treat `HARD RULE` sections as constraints and `BASELINE` sections as defaults/reference points.

## Site Skin Tasks
Type: RECOMMENDATION + REFERENCE

Read:
- `reference/css-rules.md` for sanitizer rules, parser quirks, em scale, and CSS caveats.
- `reference/class-system.md` for valid AO3 class vocabulary.
- `reference/stylesheet-cascade.md` for cascade position, breakpoints, and z-index.
- `reference/brand-tokens.md` only when matching or intentionally overriding AO3 defaults.
- `reference/icons-sprites.md` when changing required-tags or sprite-based icons.

## Skin Timestamp Automation
Type: RECOMMENDATION + REFERENCE

For site skin repositories, the optional `skin-timestamp-updater` may be installed. If `_scripts/skin-timestamp-updater/` exists, preserve `Updated:` metadata in skin CSS and let the Git pre-commit hook refresh it. This is tooling behavior, not an AO3 hard rule.
## Work Skin Tasks
Type: RECOMMENDATION + REFERENCE

Read:
- `reference/css-rules.md` for sanitizer rules and work-skin CSS limits.
- `reference/work-skin-classes.md` for built-in AO3 utility classes.
- `reference/dom-patterns.md` for `#workskin`, `.userstuff`, preface, notes, and work content structure.
- `reference/brand-tokens.md` only as optional AO3 visual reference.

## Userscript Tasks
Type: RECOMMENDATION + REFERENCE

Read:
- `reference/dom-patterns.md` before choosing selectors or parsing AO3 pages.
- `reference/js-patterns.md` before detecting AO3 JS-managed state.
- `reference/class-system.md` for class vocabulary and page/state classes.
- `reference/js-api.md` before using modals, Rails AJAX events, CSRF timing, or AO3 globals.
- `reference/stylesheet-cascade.md` before injecting overlays or fixed UI.
- `reference/icons-sprites.md` when reading or replacing icon state.

## Debugging Checklist
Type: RECOMMENDATION + REFERENCE

- CSS missing: check `reference/css-rules.md` HARD RULE sections first.
- CSS loses declarations: check parser quirks, especially duplicate properties and `font` shorthand.
- Selector returns nothing: check `reference/dom-patterns.md` and `reference/class-system.md`; many plausible class names do not exist.
- UI appears behind AO3 elements: check `reference/stylesheet-cascade.md` z-index table.
- Userscript state detection flaky: prefer `reference/js-patterns.md` reliable hooks and `reference/js-api.md` runtime APIs.

## Manifest
Type: REFERENCE

Machine-readable routing metadata is in `ao3-dev-guide.json`.


