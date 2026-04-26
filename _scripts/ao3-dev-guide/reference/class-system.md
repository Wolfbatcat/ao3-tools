# AO3 Class System Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


## Naming Rules
Type: RECOMMENDATION

- Short, lowercase, common English words
- Describe **function**, not presentation — `warning` not `red`, `heading` not `bold-text`
- Do not give everything a unique class — use inheritance and path-based selectors
- Classes are listed **most specific first**: `work blurb group`, `unread comment group`
- Only declare a class on the **outermost element** that needs it; children inherit

## "What Kind and Where" — The Core Principle
Type: RECOMMENDATION

Target elements by their DOM path rather than adding new classes:
```css
/* tag links everywhere */
a.tag { border-bottom: 1px dotted; }

/* tag links only inside bookmarks — no new class needed */
.bookmark a.tag { border-bottom: none; }
```

## Class Hierarchy
Type: REFERENCE

### Supertypes (layout containers)
Type: REFERENCE

| Class | Description |
|-------|-------------|
| `.region` | Major page regions — always paired with an id (`#header`, `#dashboard`, `#main`, `#footer`) |
| `.group` | Collections of related content (blurb, meta, stats, etc.) |
| `.zone` | Types of `#main` content (system, home, search, tags, translation) |
| `.actions` | Navigation links, buttons, pagination |

### Groups
Type: REFERENCE

`.index` `.listbox` `.meta` `.blurb` `.preface` `.stats` `.comments`

### Zones
Type: REFERENCE

`.system` `.home` `.filters` `.search` `.tags` `.translation`

### Actions subtypes
Type: REFERENCE

`.navigation` `.pagination` `.action` — also `.current` for active state

### Object types (database records)
Type: REFERENCE

`.user` `.work` `.chapter` `.series` `.bookmark` `.skin` `.tags` `.tag` `.collection`

### Tag / required-tag classes
Type: REFERENCE

`.freeform` `.required-tags` `.rating` `.category` `.warnings` `.iswip`

Rating values: `.rating-general-audience` `.rating-teen` `.rating-mature` `.rating-explicit` `.rating-notrated`

Category values: `.category-femslash` `.category-gen` `.category-het` `.category-slash` `.category-multi` `.category-other` `.category-none`

Warning values: `.warning-yes` `.warning-no` `.warning-choosenotto`

Completion: `.complete-yes` `.complete-no`

### Data types (content descriptors)
Type: REFERENCE

`.heading` `.title` `.byline` `.datetime` `.summary` `.notes` `.footnote` `.toc` `.intro` `.count` `.status` `.notice` `.error` `.icon` `.symbol` `.userstuff`

`.userstuff` — user-entered or long-form text (comments, summaries, work body). Has its own stylesheet.

### Modifier classes (most specific, listed first in class attribute)
Type: REFERENCE

**Role modifiers**: `.wrangler` `.user` `.visitor` `.admin` `.participant` `.mod` `.owner` `.anonymous` `.official`

**State modifiers**:
- General: `.current` `.hidden` `.public` `.private` `.important` `.caution` `.required` `.open` `.closed` `.odd` `.even` `.mystery` `.latest` `.recent`
- Pending: `.draft` `.preview` `.unreviewed` `.unread` `.unfulfilled` `.unwrangled`
- Completed: `.reviewed` `.read` `.replied` `.claimed` `.posted`
- Relationship: `.own` `.canonical` `.parent` `.child` `.synonym` `.meta`
- JS-added: `.filtering` `.expanded` `.collapsed`

**Context modifiers**: `.dashboard` `.primary` `.secondary` `.tertiary` `.start` `.end`

**Ability modifiers** (on interactions): `.draggable` `.droppable` `.sortable` `.dynamic` `.expandable`

**Mode modifiers** (on interactions): `.single` `.simple` `.verbose`

### Layout helpers
Type: REFERENCE

`.module` — general group container  
`.wrapper` — layout wrapper (`#outer`, `#inner`)  
`.clear` — clearfix div only, no other use

### Utility / formatting classes
Type: REFERENCE

`.commas` — applied to `ul` or `ol` to auto-insert CSS-generated commas. Full rule from `09-roles-states.css`:
```css
.commas li          { display: inline; }
.commas li:after    { content: ", "; }
.commas li:last-child:after,
.commas li:only-child:after { content: none; }
```
No manual comma markup needed. To suppress in a skin: `ul.commas li:after { content: none; }`.

`.collapsed` / `.expanded` — JS-toggled accordion state. CSS generates directional arrows:
```css
.collapsed:after { content: " \2193"; }  /* ↓ */
.expanded:after  { content: " \2191"; }  /* ↑ */
```

`.cloud1` – `.cloud8` — tag cloud weight classes. `cloud1` is smallest/lightest, `cloud8` is largest/darkest (`#900`). Applied to `<a>` elements inside a tag cloud list. Do not target by color — target by class name.

`.abbreviated` — applied to comment containers to use smaller (75×75px) icons and adjusted byline padding. Default comment icons are 100×100px.

## State Class Visual Treatments (09-roles-states.css)
Type: REFERENCE

### Pending / inactive items
Type: REFERENCE

`.own`, `.draft`, `.unread`, `.child`, `.unwrangled`, `.unreviewed` all share:
```css
background: #ededed; opacity: 0.95;
```

`.draft` additionally gets a dashed border treatment:
```css
border: 2px dashed #aaa; padding: 0.643em; border-radius: 0.5em;
```

Note: `.dashboard .own` and `.comment span.unreviewed` override back to `background: transparent; opacity: 1` in context — the muted style only applies in listing/index contexts.

### Inline state badges
Type: REFERENCE

`span.unread`, `.replied`, `span.claimed`, `.actions span.defaulted` — pill badges:
```css
background: #ccc; color: #900; display: inline-block;
padding: 0.25em 0.75em; border: 1px solid #bbb; border-radius: 0.25em;
```
`.actions span.defaulted` overrides color to `#111`.

### Nomination states
Type: REFERENCE

Used in gift exchange nomination pages:

| Class | Background | Text color |
|-------|------------|------------|
| `.nominations .approved` | `#d1f0d1` (light green) | `#008000` |
| `.nominations .rejected` | `#efd1d1` (light red) | `#900` |

### Canonical / draggable state colors
Type: REFERENCE

- `.canonical`, `li.requested` — `font-weight: 700`
- `.draggable`, `.droppable`, `span.requested`, `.nominations .rejected` — `color: #900`
- `span.offered`, `.replied`, `.nominations .approved` — `color: #008000`
- `span.offered.requested` — `color: #876714` (both states simultaneously)

---

## JavaScript-Managed Classes
Type: BASELINE + REFERENCE

These classes are added/removed by AO3's JavaScript at runtime. See `js-patterns.md` for full details.

| Class | Added to | Meaning |
|-------|----------|---------|
| `.javascript` | `body` | JS is enabled and has run |
| `.logged-in` | `body` | User is authenticated |
| `.open` | `.dropdown li` | Dropdown menu is currently visible |
| `.expanded` | `li` in work nav | Secondary work nav menu is open |
| `.filtering` | `#main` | Filter sidebar is open (narrow screens) |
| `.modal-attached` | `a.modal` | Modal event listener bound to this link |
| `.narrow-shown` | Various | Show only on narrow screens |
| `.narrow-hidden` | Various | Hide on narrow screens when JS active |

## Rails-Generated Classes
Type: BASELINE + REFERENCE

Rails adds a class to `<div id="main">` based on the view partial. Examples:
- Media index page → `media-index`
- Works index → `works-index` (also gets `dashboard` and `filtered`)

These use underscores. Useful for page-specific rules but should not be a primary technique.

## Exceptions (don't rename these)
Type: RECOMMENDATION

- jQuery plugin classes — keep as-is to ease plugin updates
- JS-hook classes — prefer AO3 naming but don't break functionality
- Muting classes on blurbs: `work-000`, `user-000` — listed last, by convention



