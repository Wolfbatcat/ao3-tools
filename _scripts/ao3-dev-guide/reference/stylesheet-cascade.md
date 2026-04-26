# AO3 Stylesheet Cascade Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


## Overview
Type: HARD RULE + REFERENCE

AO3 has 33 stylesheets loaded in cascade order. The first 22 are always applied. On production they are merged into a single file (`01_site_screen_.css`). On dev they load individually.

**User skins** are injected after the first 22 (core) sheets but before the sandbox. The sandbox always wins over user skins.

## Cascade Order (simplified)
Type: HARD RULE + REFERENCE

| # | File (approximate name) | What it covers |
|---|------------------------|----------------|
| 01 | core | Base typography, spacing between regions, screen-reader-only visibility, horizontal lists, form readability |
| 02 | elements | Meyer Reset + base element styles (`p`, `a`, tables, links) — almost no classes or ids here |
| 03 | region-header | `#header` — branding, main nav, login/greeting |
| 04 | region-dashboard | `#dashboard` — sidebar nav on user/collection pages |
| 05 | region-main | `#main` — width, position relative to dashboard |
| 06 | region-footer | `#footer` — info links, skin selector |
| 07 | interactions | Forms, form elements, JS widgets (autocomplete, calendar, drag-drop) |
| 08 | actions | Links, buttons, pagination, submit inputs |
| 09 | roles-states | State and role modifier classes (`.draft`, `.unread`, `.admin`, etc.) |
| 10 | types-groups | Type classes + groups: `.stats`, `.module`, `.index` |
| 11 | group-listbox | `.listbox` |
| 12 | group-meta | `.meta` |
| 13 | group-blurb | `.blurb` — most-used chunk, heavily styled |
| 14 | group-preface | `.preface` |
| 15 | group-comments | `.comments` / `.thread` |
| 16–20 | zones | `.system`, `.home`, searchbrowse, `.tags`, `.translation` |
| 21 | userstuff | `.userstuff` — user-entered text, work body (`#workskin`) |
| 22 | system-messages | Error/success/warning notices, admin banners |
| 23 | role-translator | Translator role overrides |
| 24 | role-admin | Admin role overrides (e.g. teal footer) |
| 25–28 | media roles | Midsize (max 62em), Narrow (max 42em), aural (screen readers), print |
| 29–32 | IE conditionals | IE 5–8 compatibility (IE8 still active) |
| 33 | sandbox | Experimental/temp styles — **loads after user skins, overrides them** |

## Where User Skins Slot In
Type: HARD RULE + REFERENCE

```
...core sheets (01–22)...
→ USER SKIN INJECTED HERE ←
...role sheets (23–24)...
...media/IE/sandbox (25–33)...
```

This means:
- Your skin overrides the core styles
- Admin/translator role styles can still override your skin for those users
- The sandbox always beats your skin (it's for AO3 dev use, not a concern for skin makers)

## Specificity Strategy for Skins
Type: RECOMMENDATION

- Use class selectors (`.blurb`, `.work`) — they have lower specificity than ids and are easier to override
- Where you need to beat a core style, add context: `.work.blurb .heading` instead of just `.heading`
- Avoid id selectors unless targeting a specific region (`#header`, `#main`, `#footer`)
- Don't use `!important` — it breaks the cascade for everything downstream

## Page View Types
Type: BASELINE + REFERENCE

Each page type has a distinct `#main` structure:

| View | Key selector | Description |
|------|-------------|-------------|
| Index | `ol.work.index` / `ul.index` | List of blurbs (works, bookmarks, collections) |
| Work | `#workskin` | Work content; preface at top, comments at bottom |
| Bookmark | `.bookmark.blurb` | Single or list of bookmarks |
| User/Collection | `#main.dashboard` | Has sidebar dashboard; home zone |
| Profile | `.home` zone | Icon + heading + nav module structure |

## Rails Page Classes
Type: BASELINE + REFERENCE

Rails adds a class to `#main` per view. Use these for page-specific overrides:
- `works-index` — work listing pages
- `media-index` — media browsing page
- Pages with dashboard and filters also get `dashboard` and `filtered` added automatically

## Z-Index Reference
Type: BASELINE + REFERENCE

All stacking contexts on the page, from highest to lowest. Useful when writing skins that need overlays or when writing userscripts that inject UI elements.

| Element | Z-index | Stylesheet |
|---------|---------|------------|
| `.qtip` tooltips | 15000 | 07-interactions.css |
| ToS prompt (`#tos_prompt`) | 999 | 16-zone-system.css |
| Modal (`#modal`) | **501** | 07-interactions.css |
| Modal backdrop (`#modal-bg`) | 499 | 07-interactions.css |
| Dynamic div (`div.dynamic`) | 500 | 07-interactions.css |
| Filter fieldset on narrow (`.javascript .filters fieldset`) | 450 | 26-media-narrow.css |
| Filter sidebar on narrow (`.javascript form.filters`) | 400 | 26-media-narrow.css |
| Dropdown menus (`#header .menu`) | 55 | 03-region-header.css |
| Secondary actions (`.secondary`) | 54 | 08-actions.css |
| Bookmark status icons (`p.status`) | 1 | 13-group-blurb.css |

Injection guide:
- Above everything (including tooltips): `z-index: 15001+`
- Above modals but below tooltips: `z-index: 1000–14999`
- Above ToS prompt but below modal: not recommended
- Above dropdowns but below overlays: `z-index: 56–398`

## Responsive Breakpoints
Type: HARD RULE + REFERENCE

AO3 has two responsive breakpoints applied via separate stylesheets loaded after the core 22.

| Stylesheet | Query | Breakpoint |
|------------|-------|------------|
| `25-media-midsize.css` | `max-width: 62em` | Tablet / smaller desktop |
| `26-media-narrow.css` | `max-width: 42em` | Mobile / narrow viewport |

### What changes at 62em (midsize)
Type: BASELINE + REFERENCE

- `#dashboard` loses its float and becomes a horizontal inline bar above `#main`
- `#main` and `#main.dashboard` lose their float and go full-width (`width: auto`)
- Filter sidebar (`form.filters`) shrinks to `min-width: 23% / max-width: 24%`
- `#workskin` gets `margin: auto 1.5%`
- Single-input forms (`form.single`) go full-width

### What changes at 42em (narrow)
Type: BASELINE + REFERENCE

- `#outer` gets `font-size: 0.875em` applied (additional size reduction)
- `h1`–`h3` get `word-break: break-word` to prevent overflow
- `#dashboard` borders thin from 10px to 7px
- `#main` and `#main.dashboard` become `position: static`
- All filter/form/index elements go `width: 100%; float: none` — single column layout
- Filter sidebar becomes a JS-toggled slide-out panel (`position: absolute; right: -16em`)
- `.thread .thread` indent reduces to `1em`
- Comment icons shrink to 55px
- Splash homepage modules stack full-width
- Classes `.narrow-shown` and `.narrow-hidden` become active (JS toggles `.narrow-hidden`)

### Writing skin CSS for narrow screens
Type: RECOMMENDATION

To target narrow screens in your skin, use the same media query AO3 uses:

```css
@media only screen and (max-width: 42em) {
  /* narrow-only overrides */
}

@media only screen and (max-width: 62em) {
  /* midsize-and-below overrides */
}
```

Note: AO3's skin sanitizer allows `@media` queries — they are not stripped.

## Skin File Format
Type: HARD RULE + REFERENCE

When loading skins via the `user_skins_to_load` folder (dev/admin use), skin files use special CSS comments:

```css
/* SKIN: My Skin Title */
/* REPLACE: 3 */          /* optional: ID of existing skin to overwrite */
/* PARENTS: 5, 7, 10 */   /* optional: IDs of parent skins to inherit from */

/* your CSS here */

/* END SKIN */
```

Multiple skins can be defined in a single `.css` file, separated by `/* END SKIN */`.

Parent skins can be referenced by ID number or by title (e.g. `/* PARENTS: Archive 1.0 */`). Parent skin styles are applied before the child skin's rules.



