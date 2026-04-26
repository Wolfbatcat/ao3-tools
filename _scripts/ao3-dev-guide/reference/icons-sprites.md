# AO3 Icon Sprite Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


All AO3 icons are served from a single sprite image at `/images/imageset.png`. A 50px version is at `/default_large/imageset.png`.

---

## Required-Tags Icon Block (blurbs)
Type: BASELINE + REFERENCE

The 4-icon block in blurbs is `ul.required-tags` — absolutely positioned, top-left of the blurb header. Each icon is **25×25px**.

### Layout of the 4 icons
Type: BASELINE + REFERENCE

```
[icon 1: rating ]  [icon 3: category ]   ← top row (y: 0)
[icon 2: warning]  [icon 4: complete ]   ← bottom row (y: 28px)
```

Icons 1 and 2 stack vertically in the left column (x: 0). Icons 3 and 4 are positioned at `left: 28px` using the adjacent sibling combinator `li+li+li` and `li+li+li+li`.

The blurb header's left margin is `65px` to clear the icon block (60px wide + 5px gap).

### Replacing icons with text
Type: RECOMMENDATION + REFERENCE

Override `font-size: 0.001em` to make icon text readable, or replace backgrounds with your own images. The text is already in the DOM — it's just near-zero size:

```css
/* reveal icon text, hide sprite */
.blurb span.text {
  font-size: 0.875em;
  color: inherit;
  height: auto;
  width: auto;
}
.blurb ul.required-tags li span {
  background: none;
  width: auto;
  height: auto;
}
```

---

## Sprite Coordinates — Required Tags (25×25px)
Type: BASELINE + REFERENCE

All from `/images/imageset.png`.

### Ratings
Type: BASELINE + REFERENCE

| Class | Selector | X | Y |
|-------|----------|---|---|
| General Audiences | `.rating-general-audience` | -50px | -25px |
| Teen And Up | `.rating-teen` | 0px | -25px |
| Mature | `.rating-mature` | -75px | -25px |
| Explicit | `.rating-explicit` | -25px | -25px |
| Not Rated | `.rating-notrated` | -150px | 0px |

### Categories
Type: BASELINE + REFERENCE

| Class | Selector | X | Y |
|-------|----------|---|---|
| M/M (Slash) | `.category-slash` | 0px | 0px |
| F/F (Femslash) | `.category-femslash` | -25px | 0px |
| Gen | `.category-gen` | -50px | 0px |
| F/M (Het) | `.category-het` | -75px | 0px |
| Multi | `.category-multi` | -100px | 0px |
| Other | `.category-other` | -125px | 0px |
| None / No Category | `.category-none` | -150px | 0px |

### Warnings
Type: BASELINE + REFERENCE

| Class | Selector | X | Y |
|-------|----------|---|---|
| No Archive Warnings | `.warning-no` | -150px | 0px |
| Warning Apply | `.warning-yes` | -150px | -25px |
| Choose Not To Warn | `.warning-choosenotto` | -125px | -25px |

Note: `.warning-no` shares coordinates with `.category-none` and `.rating-notrated` — all use the same "circle with line" icon.

### Completion
Type: BASELINE + REFERENCE

| Class | Selector | X | Y |
|-------|----------|---|---|
| Complete | `.complete-yes` | -175px | -25px |
| Work In Progress | `.complete-no` | -100px | -25px |

### External Works
Type: BASELINE + REFERENCE

| Class | Selector | X | Y |
|-------|----------|---|---|
| External Work | `.external-work` | -75px | -50px |

---

## Sprite Coordinates — Bookmark Status Icons (25×25px)
Type: BASELINE + REFERENCE

Used in `p.status` on bookmark blurbs (right side, not left).

| Icon | Selector | X | Y |
|------|----------|---|---|
| Public bookmark | `.status .public` | -125px | -50px |
| Hidden bookmark | `.status .hidden` | -150px | -50px |
| Private bookmark | `.status .private .text` | -175px | -50px |
| Rec (recommended) | `.status .rec` | -100px | -50px |
| Count/default | `.status .count` | -150px | 0px |

---

## Sprite Coordinates — Comment Icons (100×100px default, 75×75px abbreviated)
Type: BASELINE + REFERENCE

Used in `.comment div.icon`. Default size is 100×100px; `.abbreviated` modifier uses 75×75px.

| Icon | Context | X | Y |
|------|---------|---|---|
| Anonymous user | `.comment .icon .anonymous` (default) | 0px | -735px |
| Visitor / logged-out | `.comment .icon .visitor` (default) | 0px | -635px |
| Anonymous user | `.abbreviated .icon .anonymous` | -75px | -450px |
| Visitor / logged-out | `.abbreviated .icon .visitor` | 0px | -450px |
| Anonymous (narrow) | `.comment .icon .anonymous` (narrow screen) | -75px | -395px |
| Visitor (narrow) | `.comment .icon .visitor` (narrow screen) | -130px | -395px |

---

## Sprite Coordinates — Picture/Index Icons (55×55px)
Type: BASELINE + REFERENCE

Used in `.picture .icon` for collection, skin, tag, and mystery item blurbs.

| Icon | Selector | X | Y |
|------|----------|---|---|
| Skin | `.index .skins .icon` | 0px | -580px |
| Tag / tagset | `.index .tag .icon`, `.index .tagset .icon` | -55px | -580px |
| Mystery work | `.index .mystery .icon` | -110px | -525px |

---

## Sprite Coordinates — Home/Profile Icons (approx 100×100px)
Type: BASELINE + REFERENCE

Used in `.home .primary .icon` on user/collection/tag home pages.

| Icon | Selector | X | Y |
|------|----------|---|---|
| Skin home | `.skins .primary .icon` | 0px | -175px |
| Tag home | `.tag .primary .icon` | 0px | -275px |
| Admin home | `.admin .primary .icon` | 100px | -75px |

---

## Sprite Coordinates — Misc
Type: BASELINE + REFERENCE

| Icon | Selector | X | Y |
|------|----------|---|---|
| RSS feed | `a.rss span` (10-types-groups.css) | -150px | -275px |
| Kudos heart | `p.kudos` background (10-types-groups.css) | -111px | -580px |

---

## Customising Icons in a Skin
Type: RECOMMENDATION + REFERENCE

To replace all required-tags icons with your own image set:

```css
/* point to your own sprite */
.required-tags li span {
  background-image: url('https://example.com/my-icons.png');
}

/* override each individual icon position */
.required-tags .rating-explicit { background-position: 0px 0px; }
.required-tags .rating-mature   { background-position: -25px 0px; }
/* etc. */
```

To use the larger 50px icons (available at `/default_large/imageset.png`), you also need to resize the icon elements:

```css
.blurb ul.required-tags li,
.blurb ul.required-tags li a,
.blurb ul.required-tags li span {
  width: 50px;
  height: 50px;
}
.blurb ul.required-tags li+li+li,
.blurb ul.required-tags li+li+li+li {
  left: 53px;
}
.blurb .header .heading,
.blurb .header ul {
  margin-left: 115px; /* adjust to clear wider icon block */
}
```



