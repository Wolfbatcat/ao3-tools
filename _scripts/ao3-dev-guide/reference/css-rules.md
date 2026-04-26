# AO3 CSS Rules Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


## HTML Standards
Type: HARD RULE + RECOMMENDATION

AO3 uses HTML5 but enforces XHTML 1.0 Strict habits:
- All markup lowercase
- All tags closed; empty tags self-close: `<br />`
- No deprecated elements
- No inline styles (`style="..."`) — ever

## CSS Formatting
Type: RECOMMENDATION

```css
/* Multiple selectors: same line, comma + space */
.selector-a, .selector-b {
  /* CSS 2.1 properties: 2-space indent */
  display: block;
  margin: 0.643em auto;
    /* CSS3 properties: 4-space indent, listed last */
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
}
/* blank line after each block */
```

Rules:
- Space between colon and value: `color: #900`
- Semicolon on every property including last
- Closing brace on its own unindented line
- Zero before decimals under 1: `0.643em` not `.643em`
- Space after every comma

## Units
Type: RECOMMENDATION

- **Text size**: always ems, never px (px overrides user browser settings)
- **Margins, padding, widths**: ems
- **Pixels**: only when tied to a fixed image size (e.g. image-dependent margins)
- **Print**: points only (separate print stylesheet)
- **Line height**: unitless (e.g. `line-height: 1.286`)

## Em Scale
Type: BASELINE + RECOMMENDATION

Base: `body { font: 100%/1.125 ... }` — inherits browser default (usually 16px).

`#main` sets `font-size: 0.875em` = **14px** at browser default 16px.
All elements inside `#main` should calculate ems against **14px as 1em**.

### Standard scale inside `#main` (base 14px)
Type: BASELINE + RECOMMENDATION

| Target px | Em value  |
|-----------|-----------|
| 24        | 1.714em   |
| 18        | 1.286em   |
| 16        | 1.143em   |
| 14        | 1em       |
| 12        | 0.857em   |
| 10        | 0.714em   |
| 9         | 0.643em   |
| 8         | 0.571em   |

**Formula**: target px ÷ 14 = em value

### Spacing tips inside `#main`
Type: RECOMMENDATION

- Single word-space gap: ~`0.25em`
- Single blank line between blocks: `margin: 0.643em auto`
- Use values from the scale for balanced spacing

## Base Element Defaults (02-elements.css)
Type: BASELINE + RECOMMENDATION

These are AO3's defaults for bare HTML elements — know these before writing overrides.

### Links
Type: BASELINE + RECOMMENDATION

```css
a, a:link          { color: #111; border-bottom: 1px solid; text-decoration: none; }
a:visited          { color: #666; border-bottom: 1px dashed; }
a:hover            { color: #999; }
a:active, a:focus  { outline: 1px dotted; }
```

### Headings (all use `font-family: Georgia, serif; font-weight: 400`)
Type: BASELINE + RECOMMENDATION

| Element | font-size | line-height | margin |
|---------|-----------|-------------|--------|
| `h1` | 2.5em | 1 | 0.5em 0 |
| `h2` | 2.143em | 1 | 0.429em 0 — display: inline |
| `h3` | 1.286em | 1 | 0.5375em 0 |
| `h4` | 1.143em | 1.125 | 0.5em 0 |
| `h5` | 1em | 1.286 | 0.643em 0 |
| `h6` | 0.875em | 1.5 | 1.5em 0 — font-weight: 900 |

### Code and monospace
Type: BASELINE + RECOMMENDATION

```css
kbd, tt, code, var, pre, samp {
  font: normal 0.857em 'Monaco', 'Consolas', Courier, monospace;
}
pre { white-space: pre-wrap; }
```

### Blockquote
Type: BASELINE + RECOMMENDATION

```css
blockquote {
  font: 1em 'Lucida Grande', 'Lucida Sans Unicode', Verdana, Helvetica, sans-serif;
  margin: 0.643em;
}
```

### Tables
Type: BASELINE + RECOMMENDATION

```css
table { background: #ddd; border-collapse: collapse; margin: auto; width: 100%; }
tbody tr { border-bottom: 1px solid #fff; }
td { padding: 0.25em; vertical-align: top; }
th { background: #fff; border: 1px solid #bbb; padding: 0.15em 0.5em 0.25em; }
```

---

## Link Styling Convention
Type: BASELINE + RECOMMENDATION

AO3 uses `border-bottom` for link underlines, **not** `text-decoration`. This means overriding link styling requires targeting borders, not text-decoration:

```css
/* AO3 default — uses border, not text-decoration */
a { border-bottom: 1px solid; }
a:visited { border-bottom: 1px dashed; }
a:hover { border-bottom: 0; }

/* to remove underlines in your skin */
a { border-bottom: none; text-decoration: none; }
```

Visited links get a **dashed** border (vs solid for unvisited). Override both states if you want consistent link styling.

## Hidden Element Patterns
Type: BASELINE + RECOMMENDATION

AO3 hides elements in three different ways depending on the purpose:

| Pattern | How hidden | Accessible to screen readers? | Use |
|---------|-----------|-------------------------------|-----|
| `display: none` | Removed from layout | No | Fully invisible/inert elements (`.hidden`) |
| `opacity: 0; font-size: 0; height: 0` | In layout but invisible | Yes | Landmark headings (`.landmark`) — skip links stay in tab order |
| `font-size: 0.001em; color: transparent` | In layout, near-invisible | Yes | Icon text in blurbs (`.blurb span.text`) — text stays in DOM for screen readers |

**Userscript implication:** Don't rely on `element.offsetParent` or visibility checks to detect icon text — it's present but tiny.

## Selector Combining
Type: RECOMMENDATION

Only combine selectors within the same supertype class section of a stylesheet. Do not use tools to auto-combine selectors across sections — it destroys cascade design.

## CSS Scope: Work Skins vs Site Skins
Type: HARD RULE

| Skin type | CSS applies to | Where CSS is written |
|-----------|---------------|----------------------|
| **Site skin** | Entire page | Skin editor — injected after core 22 stylesheets |
| **Work skin** | `#workskin` only | Work skin editor — scoped to work content |

Fields that allow embedded CSS in work/chapter content: `content`, `endnotes`, `notes` — same property allowlist as skins applies. CSS variables (`var()`) do **not** work in work skins.

---

## Skin System — Allowed CSS
Type: HARD RULE

AO3's skin sanitizer strips any property not on its allowlist. The lists below are the complete set from `config.yml`.

### Shorthand property families (all sub-properties allowed)
Type: REFERENCE

Because these are prefix-matched, listing `border` also allows `border-right`, `border-bottom-left-radius`, `-moz-border-*`, etc.

`background` `border` `column` `cue` `flex` `font` `layer-background` `layout-grid` `list-style` `margin` `marker` `outline` `overflow` `padding` `page-break` `pause` `scrollbar` `text` `transform` `transition`

### Exact properties allowed (from config.yml, verbatim)
Type: REFERENCE

`-replace` `-use-link-source` `accelerator` `align-content` `align-items` `align-self` `alignment-adjust` `alignment-baseline` `appearance` `azimuth` `baseline-shift` `behavior` `binding` `bookmark-label` `bookmark-level` `bookmark-target` `bottom` `box-align` `box-direction` `box-flex` `box-flex-group` `box-lines` `box-orient` `box-pack` `box-shadow` `box-sizing` `caption-side` `clear` `clip` `color` `color-profile` `color-scheme` `content` `counter-increment` `counter-reset` `crop` `cue` `cue-after` `cue-before` `cursor` `direction` `display` `dominant-baseline` `drop-initial-after-adjust` `drop-initial-after-align` `drop-initial-before-adjust` `drop-initial-before-align` `drop-initial-size` `drop-initial-value` `elevation` `empty-cells` `filter` `fit` `fit-position` `float` `float-offset` `font` `font-effect` `font-emphasize` `font-emphasize-position` `font-emphasize-style` `font-family` `font-size` `font-size-adjust` `font-smooth` `font-stretch` `font-style` `font-variant` `font-weight` `grid-columns` `grid-rows` `hanging-punctuation` `height` `hyphenate-after` `hyphenate-before` `hyphenate-character` `hyphenate-lines` `hyphenate-resource` `hyphens` `icon` `image-orientation` `image-resolution` `ime-mode` `include-source` `inline-box-align` `justify-content` `layout-flow` `left` `letter-spacing` `line-break` `line-height` `line-stacking` `line-stacking-ruby` `line-stacking-shift` `line-stacking-strategy` `mark` `mark-after` `mark-before` `marks` `marquee-direction` `marquee-play-count` `marquee-speed` `marquee-style` `max-height` `max-width` `min-height` `min-width` `move-to` `nav-down` `nav-index` `nav-left` `nav-right` `nav-up` `opacity` `order` `orphans` `page` `page-policy` `phonemes` `pitch` `pitch-range` `play-during` `position` `presentation-level` `punctuation-trim` `quotes` `rendering-intent` `resize` `rest` `rest-after` `rest-before` `richness` `right` `rotation` `rotation-point` `ruby-align` `ruby-overhang` `ruby-position` `ruby-span` `size` `speak` `speak-header` `speak-numeral` `speak-punctuation` `speech-rate` `stress` `string-set` `tab-side` `table-layout` `target` `target-name` `target-new` `target-position` `top` `unicode-bibi` `unicode-bidi` `user-select` `vertical-align` `visibility` `voice-balance` `voice-duration` `voice-family` `voice-pitch` `voice-pitch-range` `voice-rate` `voice-stress` `voice-volume` `volume` `white-space` `white-space-collapse` `widows` `width` `word-break` `word-spacing` `word-wrap` `writing-mode` `z-index`

Aural/speech properties (`voice-*`, `pitch`, `richness`, etc.) and legacy IE properties (`behavior`, `accelerator`, etc.) are technically allowed but irrelevant for visual skins.

### Allowed keywords and values
Type: REFERENCE

- All standard CSS keyword values pass (`absolute`, `center`, `underline`, etc.)
- Explicitly allowed: `!important`, `url(...)`
- **Colors**: hex (`#900`, `#000000`), `rgb()`, `rgba()`, and named color keywords
- **Numeric values**: up to two decimal places, as percentages or in `cm|em|ex|in|mm|pc|pt|px`
- **Scale**: `scale(n.nn)` is allowed as a value for `transform`
- **External images** via `url()`: `.jpg`, `.jpeg`, `.png`, `.gif` only — no webp, svg, or other formats

### What is NOT allowed
Type: HARD RULE

- `url()` pointing to non-image resources — no web fonts, no data URIs
- Inline styles in HTML (`style="..."`) — stripped by sanitizer and bad practice
- Any property not in the lists above — silently stripped, no error shown
- **Comments** — `/* ... */` are stripped entirely from submitted skin CSS
- Skins using external image URLs will not be approved for public use on AO3

## Skin Parser Quirks
Type: HARD RULE

### Duplicate properties in one ruleset are collapsed
Type: HARD RULE

The parser keeps only the **last** declaration when the same property appears more than once in a single ruleset. This breaks the common cross-browser gradient pattern:

```css
/* BROKEN — only the webkit line survives */
.my-class {
  background: -moz-linear-gradient(...);
  background: -o-linear-gradient(...);
  background: -webkit-linear-gradient(...);
}

/* CORRECT — split into separate rulesets */
.my-class { background: -moz-linear-gradient(...); }
.my-class { background: -o-linear-gradient(...); }
.my-class { background: -webkit-linear-gradient(...); }
```

### `font` shorthand is broken
Type: HARD RULE

Despite `font` being in the shorthand allowlist, **the `font` shorthand property does not work** in skin CSS. Always write font properties individually:

```css
/* BROKEN */
.heading { font: bold 1.25em Georgia, serif; }

/* CORRECT */
.heading {
  font-size: 1.25em;
  font-weight: bold;
  font-family: Georgia, serif;
}
```

### `@font-face` is not allowed
Type: HARD RULE

You cannot load external or custom fonts. Use web-safe fonts with fallbacks only. Font names in `font-family` must be alphanumeric (with spaces quoted: `'Gill Sans'` or `"Gill Sans"`).

## CSS Custom Properties (Variables)
Type: HARD RULE

Custom properties are supported in **site skins only** — they do not work in work skins.

**Naming rules:**
- Lowercase letters `a-z`, digits `0-9`, dashes `-`, underscores `_` only
- No quotes, no URLs in the name
- Uppercase letters are converted to lowercase automatically

**Usage rules:**
- Declare with `--my-variable: value;`
- Use with `var(--my-variable)` — fallback values inside `var()` are **not** allowed
- `var()` works on all properties **except** `font-family` and `content`

```css
/* valid */
:root { --accent-color: #900; }
.heading { color: var(--accent-color); }

/* invalid — no fallbacks */
.heading { color: var(--accent-color, red); }

/* invalid — font-family and content don't accept var() */
.heading { font-family: var(--my-font); }
```



