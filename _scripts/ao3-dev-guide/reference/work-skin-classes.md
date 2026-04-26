# AO3 Work Skin Utility Classes Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


Source: `source code/stylesheets/work_skins/basic_formatting.css`

All classes below are scoped to `#workskin` — they only apply inside a work's content area. They are available in work HTML fields (`content`, `notes`, `endnotes`) when the author activates the `Basic Formatting` work skin, and can be used as a starting point in custom work skins.

---

## Text Formatting
Type: HARD RULE + REFERENCE

| Class | Effect | CSS |
|-------|--------|-----|
| `.indent` | Indent block both sides | `padding: 0 5em 0 5em` |
| `.dropcap` | Large drop capital | `font-family: Georgia, serif; font-size: 3em` |
| `.flashback` | Italic text | `font-style: italic` |
| `.caps` | Small caps | `font-variant: small-caps` |
| `.spoiler` | Hidden text (bg + text both `#333`) | `background: #333; color: #333` — visible when selected |
| `.border` | Thin border | `border: 1px solid` |

---

## Font Families
Type: HARD RULE + REFERENCE

| Class | Font stack |
|-------|-----------|
| `.font-serif` | Cambria, Constantia, Palatino, Georgia, serif |
| `.font-sansserif` | Lucida Grande, Verdana, Helvetica, Arial, sans-serif |
| `.font-monospace` | Consolas, Courier, monospace |

---

## Font Sizes
Type: HARD RULE + REFERENCE

| Class | Size |
|-------|------|
| `.font-big` | 120% |
| `.font-small` | 80% |

---

## Text Alignment
Type: HARD RULE + REFERENCE

| Class | Alignment |
|-------|----------|
| `.align-right` | `text-align: right` |
| `.align-center` | `text-align: center` |
| `.align-justify` | `text-align: justify` |

---

## Horizontal Rules
Type: HARD RULE + REFERENCE

Apply class to an `<hr>` element:

| Class | Width | Notes |
|-------|-------|-------|
| `hr.third` | 33% | Centered — classic scene break |
| `hr.full` | `auto` | Centered, full available width |

---

## Font Colors
Type: HARD RULE + REFERENCE

Apply to any inline or block element. 26 classes total.

### Basic colors
Type: HARD RULE + REFERENCE

| Class | Color |
|-------|-------|
| `.font-red` | red |
| `.font-orange` | orange |
| `.font-yellow` | yellow |
| `.font-green` | green |
| `.font-blue` | blue |
| `.font-purple` | purple |
| `.font-white` | white |
| `.font-black` | black |
| `.font-pink` | pink |

### Named color variants
Type: HARD RULE + REFERENCE

| Class | Hex |
|-------|-----|
| `.font-teal` | `#008282` |
| `.font-redbrown` | `#a15000` |
| `.font-cherryred` | `#e00707` |
| `.font-brickred` | `#a10000` |
| `.font-dimorange` | `#f2a400` |
| `.font-murkyyellow` | `#a1a100` |
| `.font-jade` | `#4ac925` |
| `.font-dimgreen` | `#008141` |
| `.font-leafgreen` | `#1f9400` |
| `.font-darkolive` | `#416600` |
| `.font-dimblue` | `#005682` |
| `.font-midblue` | `#0715cd` |
| `.font-mediumskyblue` | `#00d5f2` |
| `.font-darknavy` | `#000056` |
| `.font-lightpurple` | `#f141ef` |
| `.font-midviolet` | `#b536da` |
| `.font-verydarkpurple` | `#2b0057` |
| `.font-darkplum` | `#6a006a` |
| `.font-darkmaroon` | `#77003c` |
| `.font-reallydarkgray` | `#626262` |

---

## Usage Notes
Type: RECOMMENDATION

- These classes require the **Basic Formatting** work skin to be selected on the work, or replicated in a custom work skin.
- To write a custom work skin that extends these, scope all rules to `#workskin` as the source file does.
- The classes above work as-is — no restrictions. If you write *additional custom CSS* in a work skin, that CSS is subject to the same property allowlist as site skins (see `css-rules.md`), and CSS custom properties (`var()`) are not supported.
- `.spoiler` text is only readable when selected — do not use for essential content.



