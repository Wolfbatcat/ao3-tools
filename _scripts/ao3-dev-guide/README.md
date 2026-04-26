# AO3 Dev Guide — Overview

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


A set of concise, AI-readable reference docs for building AO3 site skins, work skins, and userscripts. Distilled from AO3's source stylesheets, JavaScript files, config, and front-end standards documentation.

---

## What It Is
Type: REFERENCE


Writing code for AO3 has a high trivia burden: the skin sanitizer silently strips disallowed CSS, z-index values collide in non-obvious ways, link underlines are borders not text-decoration, em values compound through a 14px base inside `#main`, and JS state lives entirely in class names. Getting any of these wrong produces silent failures — the skin just doesn't do what you expected.

This guide exists so an AI coding assistant has accurate, ground-truth answers to these questions without hallucinating. It replaces guesswork with specific values sourced directly from AO3's code.

### Files
Type: REFERENCE


| File | For |
|------|-----|
| [css-rules.md](reference/css-rules.md) | CSS formatting, em scale, allowed properties, base element defaults, skin parser quirks |
| [brand-tokens.md](reference/brand-tokens.md) | AO3's default colors, fonts, button states — reference only, not constraints |
| [class-system.md](reference/class-system.md) | Full class taxonomy, naming rules, state class visual treatments |
| [stylesheet-cascade.md](reference/stylesheet-cascade.md) | Load order, where user skins slot in, z-index table, responsive breakpoints |
| [dom-patterns.md](reference/dom-patterns.md) | HTML structure and selectors for every major AO3 pattern |
| [js-patterns.md](reference/js-patterns.md) | JS-managed state classes, widget classes, filter/modal/dropdown hooks |
| [js-api.md](reference/js-api.md) | Programmatic JS API — `window.ao3modal`, Rails AJAX events, filter sidebar |
| [icons-sprites.md](reference/icons-sprites.md) | Sprite coordinates for all AO3 icons |
| [work-skin-classes.md](reference/work-skin-classes.md) | Built-in work skin utility classes from `basic_formatting.css` |

---

## Deploying the Guide to a New Repo
Type: REFERENCE + RECOMMENDATION

Use the top-level `Install AO3 Tools.bat` launcher from the `ao3-tools` folder. It opens a folder picker, asks whether the target repo is a Skin, Userscript, or Mixed project, then installs the guide into `docs/ao3/` and writes managed AI instruction blocks for Claude Code, Codex, and GitHub Copilot.

The installer preserves existing instruction files and replaces only content between `<!-- AO3-GUIDE:START -->` and `<!-- AO3-GUIDE:END -->`. Reference only the files relevant to the project type (see below). Loading all guide files into every session wastes context.

---

## For Skin Makers
Type: REFERENCE + RECOMMENDATION


### Which files to reference
Type: REFERENCE + RECOMMENDATION


**Always reference:**
- `reference/css-rules.md` — the single most important file; covers what CSS is and isn't allowed
- `reference/class-system.md` — what classes exist to target
- `reference/stylesheet-cascade.md` — where your rules land in the cascade, z-index, breakpoints

**Reference when relevant:**
- `reference/brand-tokens.md` — when you need to match or override a specific default value
- `reference/icons-sprites.md` — when customising rating/warning/category icons or replacing required-tags
- `reference/work-skin-classes.md` — when writing a work skin

### How the guide helps
Type: REFERENCE + RECOMMENDATION


**Before writing a property**, check the allowlist in `reference/css-rules.md`. The sanitizer strips anything not on it silently — no error is shown.

```css
filter: brightness(0.9);   /* allowed */
gap: 1em;                  /* not on the list — silently stripped */
```

**Before using ems**, check the scale table in `reference/css-rules.md`. Elements inside `#main` calculate ems against a 14px base, not the browser's 16px default.

```css
/* 12px inside #main: 12 ÷ 14 = 0.857em */
.blurb .datetime { font-size: 0.857em; }
```

**Before targeting a class**, verify it in `reference/class-system.md` or `reference/dom-patterns.md`. Many classes that look logical don't exist.

```css
/* .work-title doesn't exist — the correct selector is: */
.blurb h4.heading a.work { font-family: Georgia, serif; }
```

**Before writing link underlines**, check `reference/css-rules.md` — AO3 uses `border-bottom`, not `text-decoration`. If you override one and not the other you get both or neither.

```css
/* Remove underlines correctly */
a { border-bottom: none; text-decoration: none; }
a:visited { border-bottom: none; }
```

**Before using `!important`**, check `reference/stylesheet-cascade.md`. Understand where your skin sits in the 33-sheet cascade. Usually adding context to a selector beats `!important`.

```css
/* instead of !important */
.work.blurb h4.heading { font-size: 1.286em !important; } /* breaks downstream */

/* add context instead */
ol.work.index .blurb h4.heading { font-size: 1.286em; }  /* specific enough */
```

**Before using `font` shorthand**, check `reference/css-rules.md` → Skin Parser Quirks. The shorthand is on the allowlist but broken in the parser. Always write font properties individually.

```css
/* BROKEN — only last property survives per-ruleset */
.heading { font: bold 1.25em Georgia, serif; }

/* CORRECT */
.heading {
  font-size: 1.25em;
  font-weight: bold;
  font-family: Georgia, serif;
}
```

**Before writing a custom variable**, check `reference/css-rules.md` — CSS custom properties work in site skins only, not work skins, and `var()` cannot be used in `font-family` or `content`.

---

## For Userscript Coders
Type: REFERENCE + RECOMMENDATION


### Which files to reference
Type: REFERENCE + RECOMMENDATION


**Always reference:**
- `reference/dom-patterns.md` — the HTML you're selecting into; structure and selectors for every pattern
- `reference/js-patterns.md` — what state lives in class names, and how to detect it
- `reference/class-system.md` — the full class vocabulary for reliable selectors

**Reference when relevant:**
- `reference/js-api.md` — when opening modals, intercepting AJAX, or using AO3's JS globals
- `reference/stylesheet-cascade.md` — when injecting UI elements that need to stack correctly
- `reference/icons-sprites.md` — when reading or reacting to rating/warning icon state

### How the guide helps
Type: REFERENCE + RECOMMENDATION


**Before querying a selector**, confirm the structure in `reference/dom-patterns.md`. AO3's HTML is semantic and consistent — but not always what you'd expect.

```js
document.querySelectorAll('li.work.blurb a.work')          // all work titles on a listing page
document.querySelector('dl.work.meta')                     // stats block on a work page
blurb.querySelector('dl.stats dd.words').textContent.trim() // word count from a blurb
```

**Before detecting login state**, check `reference/js-patterns.md`.

```js
document.body.classList.contains('logged-in')  // true when logged in
document.getElementById('greeting') !== null    // alternative check
```

**Before detecting page type**, use `#main`'s Rails-generated class (from `reference/class-system.md`):

```js
const main = document.getElementById('main');
if (main.classList.contains('works-index')) { /* listing page */ }
if (main.classList.contains('dashboard'))   { /* has sidebar */ }
```

**Before watching JS state**, check `reference/js-patterns.md` for which classes are toggled by AO3's JS and what they mean.

```js
document.querySelectorAll('li.dropdown').forEach(el => {
  new MutationObserver(() => {
    if (el.classList.contains('open')) { /* menu opened */ }
  }).observe(el, { attributes: true, attributeFilter: ['class'] });
});
```

**Before injecting a UI overlay**, check `reference/stylesheet-cascade.md` → Z-Index Reference.

```js
// I want to appear above everything, including tooltips (z-index: 15000)
myPanel.style.zIndex = '15001';

// I want to appear above modals (#modal = 501) but below tooltips
myPanel.style.zIndex = '1000';
```

**Before targeting icon text**, check `reference/css-rules.md` → Hidden Element Patterns. The text inside `.blurb span.text` is in the DOM but sized at `0.001em` — it's there for screen readers, but `element.offsetParent` checks won't detect it as hidden.

**Before opening a modal programmatically**, check `reference/js-api.md`.

```js
window.ao3modal.show('/help/symbols_key', 'Symbols Key');
window.ao3modal.setContent('<p>Hello from userscript</p>', 'My Panel');
```

**Before intercepting a form submission**, check `reference/js-api.md` → Rails AJAX Events.

```js
// Cancel kudos submission conditionally
document.querySelector('#new_kudo').addEventListener('ajax:before', e => {
  if (someCondition) e.preventDefault(); // return false equivalent
});

// Act after comment posts successfully
document.querySelector('form.new_comment').addEventListener('ajax:success', (e) => {
  const [data] = e.detail;
  // data is the response
});
```

---

## Skin Timestamp Updater
Type: REFERENCE + RECOMMENDATION


For auto-updating `Updated:` timestamps in skin CSS files on commit, install the Skin Timestamp Updater via the top-level `Install AO3 Tools.bat` launcher. Source docs live in `_scripts/skin-timestamp-updater/README.md`.





