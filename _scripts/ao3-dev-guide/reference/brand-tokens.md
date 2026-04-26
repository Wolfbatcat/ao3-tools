# AO3 Brand Tokens Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


> **Note for skin makers**: These are AO3's default values, documented here for reference only.
> You are free to override any of these in your skin. They are not constraints.

## Colors — Core Palette
Type: BASELINE + REFERENCE

| Name        | Hex       | Default use                          |
|-------------|-----------|--------------------------------------|
| Red         | `#990000` (`#900`) | Logo, masthead, blurb titles, tag hover |
| White       | `#ffffff` | Page background                      |
| Text        | `#2a2a2a` | Body text                            |
| Links       | `#111111` | Link color                           |
| Visited     | `#666666` | Visited links                        |
| Link hover  | `#999999` | Link hover state                     |

## Colors — Grays (boxes, borders, shadows)
Type: BASELINE + REFERENCE

`#eee` `#ddd` `#ccc` `#bbb` `#aaa` `#999` `#777` `#666` `#555` `#444` `#333`

## Colors — Reds (header, footer, tag clouds)
Type: BASELINE + REFERENCE

`#a00` `#800` `#700` `#600` `#500` `#400` `#300` `#200`

## Colors — State
Type: BASELINE + REFERENCE

| State                    | Color     |
|--------------------------|-----------|
| Success / replied        | `#008000` (green) |
| Offered + requested      | `#876714` (gold)  |
| Requested / rejected     | `#900` (red)      |

## Colors — System Messages
Type: BASELINE + REFERENCE

| Type    | Background | Border    | Text      |
|---------|------------|-----------|-----------|
| Success/info (blue) | `#d1e1ef` | `#c2d2df` | `#2a2a2a` |
| Error (red)   | `#efd1d1`  | `#900`    | `#900`    |
| Warning (yellow) | `#ffe34e` | `#d89e36` | `#000`  |

## Fonts — Screen
Type: BASELINE + REFERENCE

| Role            | Stack                                                                 |
|-----------------|-----------------------------------------------------------------------|
| Headings        | Georgia, serif (400 weight) — used on `h1–h6`, `.heading`            |
| Body / nav      | Lucida Grande, Lucida Sans Unicode, Verdana, Helvetica, sans-serif, GNU Unifont |
| Dates / code    | Monaco, Consolas, Courier, monospace — used on `kbd`, `code`, `pre`, `.datetime` |

Body base: `font: 100%/1.125 'Lucida Grande', 'Lucida Sans Unicode', 'GNU Unifont', Verdana, Helvetica, sans-serif`

## UI Element Colors
Type: BASELINE + REFERENCE

Default colors for common interface elements. These are the values AO3 ships with — override freely in skins.

| Element | Color | Notes |
|---------|-------|-------|
| Input focus background | `#f3efec` | Light tan, applied on `:focus` |
| Comment byline background | `#ddd` | Header bar behind commenter name |
| Listbox background | `#ddd` | Outer container; index inside is `#fff` |
| Table background | `#ddd` | Default table; cells have `#fff` border gaps |
| Odd/alternate row background | `#eee` | Statistics pages, tag lists |
| Fieldset / form borders | `#ddd` | 1px solid border on most form sections |
| Work title links (`a.work`) | `#900` | Georgia serif, 1.143em |
| Admin zone color | `#066` | Teal — footer, header bar, table backgrounds for admins |
| `.annotation` module | `#eee` bg, `#ccc` border | Flex-layout annotation block (e.g. gift exchange notes) |
| `.qtip` tooltip | `#d1e1ef` bg, `#c2d2df` border | Same blue as notice messages; `z-index: 15000` |

### Button gradient (default)
Type: BASELINE + REFERENCE

Buttons use a vertical linear gradient:
- 2% from top: `#fff` (white highlight)
- 95% from top: `#ddd` (mid gray)
- 100% from top: `#bbb` (dark gray base)

Base: `background: #eee`, `color: #444`, `border: 1px solid #bbb` / `#aaa` (bottom).

**Hover**: `color: #900`, `border-top/left: 1px solid #999`, `box-shadow: inset 2px 2px 2px #bbb`

**Active / `.current`**: `color: #111`, `background: #ccc`, `border-color: #fff`, `box-shadow: inset 1px 1px 3px #333`

**`.delete` buttons**: `color: #900`, `font-weight: 900`, rounded (`border-radius: 0.875em`), box-shadow

## Fonts — Print
Type: BASELINE + REFERENCE

All print text uses the system default `serif` family (no specific font specified).



