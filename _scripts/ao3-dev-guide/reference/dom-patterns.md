# AO3 DOM Patterns Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


Key selectors and HTML structure for each major AO3 pattern. Use these for CSS targeting and JS userscripts.

---

## Page Regions
Type: BASELINE + REFERENCE

Always-present wrapper structure:

```html
<div id="outer" class="wrapper">
  <ul id="skiplinks">
  <div id="header" class="region">
  <div id="inner" class="wrapper">
    <div id="dashboard" class="region">   <!-- only on some pages -->
    <div id="main" class="region">        <!-- gets .dashboard when sidebar present -->
  </div>
  <div id="footer" class="region">
</div>
```

| Selector | What it targets |
|----------|----------------|
| `#header` | Top bar: logo, main nav, login/greeting |
| `#dashboard` | Left sidebar nav (user/collection pages only) |
| `#main` | All page content |
| `#main.dashboard` | Main content when sidebar is present |
| `#main.filtering` | Main when filter sidebar is open (narrow, JS) |
| `#footer` | Bottom links, skin selector |

### `.own` context
Type: BASELINE + REFERENCE

When a logged-in user is viewing their own profile/dashboard, `#dashboard` gets the class `.own`:

```html
<div id="dashboard" class="region own">
```

This adds thick red top/bottom borders to the dashboard (15px solid `#900`). Useful selector for "I'm on my own page" detection in userscripts:

```js
document.querySelector('#dashboard.own') !== null; // viewing own dashboard
```

### Header internals
Type: BASELINE + REFERENCE

```
#header
  h1.heading > a > img         (logo)
  #login / #greeting           (logged out / logged in)
  ul.primary.navigation.actions > li.dropdown
  form#search.search
```

### Dashboard internals
Type: BASELINE + REFERENCE

```
#dashboard.region
  h4.landmark.heading
  ul.navigation.actions > li > a / span.current
```

---

## Work Blurb
Type: BASELINE + REFERENCE

The most common pattern. Appears in index lists.

```html
<ol class="work index group">
  <li id="work_1234" class="work blurb group work-1234 user-000" role="article">
    <div class="header module">
      <h4 class="heading"><a>Title</a> by <a rel="author">Author</a></h4>
      <h5 class="fandoms heading"><a class="tag">Fandom</a></h5>
      <ul class="required-tags">
        <li><span class="rating ..."><span class="text">Rating</span></span></li>
        <li><span class="warnings ..."><span class="text">Warnings</span></span></li>
        <li><span class="category ..."><span class="text">Category</span></span></li>
        <li><span class="iswip ..."><span class="text">Complete/WIP</span></span></li>
      </ul>
      <p class="datetime">30 Sep 2013</p>
    </div>
    <ul class="tags commas">
      <li class="warnings"><a class="tag">Warning Tag</a></li>
      <li class="relationships"><a class="tag">Ship</a></li>
      <li class="characters"><a class="tag">Character</a></li>
      <li class="freeforms"><a class="tag">Additional Tag</a></li>
    </ul>
    <blockquote class="userstuff summary"><p>Summary text</p></blockquote>
    <ul class="series"><li>Part <strong>2</strong> of <a>Series Title</a></li></ul>
    <dl class="stats">
      <dt class="language">Language:</dt><dd class="language">English</dd>
      <dt class="words">Words:</dt><dd class="words">8</dd>
      <dt class="chapters">Chapters:</dt><dd class="chapters">1/1</dd>
      <dt class="kudos">Kudos:</dt><dd class="kudos"><a>1</a></dd>
      <dt class="hits">Hits:</dt><dd class="hits">7</dd>
    </dl>
  </li>
</ol>
```

| Selector | Targets |
|----------|---------|
| `li.blurb` | Any blurb (work, bookmark, etc.) |
| `li.work.blurb` | Work blurbs only |
| `li.bookmark.blurb` | Bookmark blurbs only |
| `.blurb .header.module` | Title/fandom/tags header area |
| `.blurb h4.heading` | Work title + author line |
| `.blurb h5.fandoms.heading` | Fandom tags line |
| `.blurb ul.required-tags` | Rating/warning/category/status icons |
| `.blurb .rating` | Rating icon span |
| `.blurb .warnings` | Warnings icon span |
| `.blurb .category` | Category icon span |
| `.blurb .iswip` | Complete/WIP icon span |
| `.blurb p.datetime` | Date posted |
| `.blurb ul.tags.commas` | Tag list |
| `.blurb li.relationships` | Ship tags |
| `.blurb li.characters` | Character tags |
| `.blurb li.freeforms` | Additional tags |
| `.blurb .userstuff.summary` | Summary blockquote |
| `.blurb ul.series` | Series membership |
| `.blurb dl.stats` | Stats block |
| `#work_1234` | Specific work by ID |
| `.work-1234` | Same work (class form, usable in skins) |

---

## Work Meta (work page header)
Type: BASELINE + REFERENCE

Appears at the top of a work page, inside `#workskin`.

```html
<div class="wrapper">
  <dl class="work meta group">
    <dt class="rating tags">Rating:</dt>
    <dd class="rating tags"><ul class="commas"><li><a class="tag">Teen</a></li></ul></dd>
    <dt class="warning tags">Warnings:</dt>
    <dd class="warning tags"><ul>...</ul></dd>
    <dt class="fandom tags">Fandom:</dt>
    <dd class="fandom tags"><ul>...</ul></dd>
    <dt class="relationship tags">Relationships:</dt>
    <dd class="relationship tags"><ul>...</ul></dd>
    <dt class="character tags">Characters:</dt>
    <dd class="character tags"><ul>...</ul></dd>
    <dt class="freeform tags">Additional Tags:</dt>
    <dd class="freeform tags"><ul>...</ul></dd>
    <dt class="stats">Stats:</dt>
    <dd class="stats">
      <dl class="stats">
        <dt class="published">Published:</dt><dd class="published">2013-09-30</dd>
        <dt class="words">Words:</dt><dd class="words">1234</dd>
        <dt class="chapters">Chapters:</dt><dd class="chapters">1/1</dd>
        <dt class="kudos">Kudos:</dt><dd class="kudos">56</dd>
        <dt class="hits">Hits:</dt><dd class="hits">789</dd>
      </dl>
    </dd>
  </dl>
</div>
```

| Selector | Targets |
|----------|---------|
| `dl.work.meta` | Entire work meta block |
| `dl.work.meta dt` | All label cells |
| `dl.work.meta dd` | All value cells |
| `dd.rating.tags` | Rating value |
| `dd.fandom.tags` | Fandom value |
| `dd.stats dl.stats` | Nested stats block inside meta |

---

## Stats
Type: BASELINE + REFERENCE

Always `dl.stats`. Appears inside blurbs and meta.

```html
<dl class="stats">
  <dt class="published">Published:</dt><dd class="published">2013-09-30</dd>
  <dt class="words">Words:</dt><dd class="words">1234</dd>
  <dt class="chapters">Chapters:</dt><dd class="chapters">1/1</dd>
  <dt class="comments">Comments:</dt><dd class="comments">5</dd>
  <dt class="kudos">Kudos:</dt><dd class="kudos">56</dd>
  <dt class="hits">Hits:</dt><dd class="hits">789</dd>
</dl>
```

Note: in meta, `dl.stats` is nested inside `dd.stats`. In blurbs, it appears directly inside the `li`.

---

## Preface (work/chapter notes area)
Type: BASELINE + REFERENCE

Inside `#workskin` on work pages. Contains summary, notes, end notes.

```html
<div class="preface group">
  <div id="intro" class="module">
    <h3 class="landmark heading">Summary</h3>
    <blockquote class="userstuff">...</blockquote>
  </div>
  <div id="notes" class="module">
    <h3 class="heading">Notes</h3>
    <blockquote class="userstuff">...</blockquote>
  </div>
</div>
```

| Selector | Targets |
|----------|---------|
| `.preface.group` | Entire preface area |
| `.preface #intro` | Summary module |
| `.preface #notes` | Author notes module |
| `.preface .userstuff` | Text content of notes/summary |

---

## Comments / Thread
Type: BASELINE + REFERENCE

```html
<ol class="thread">
  <li id="comment_456" class="odd comment group user-123">
    <h4 class="byline heading"><a>Username</a> <span class="posted datetime">date</span></h4>
    <div class="icon"><a><img class="icon"></a></div>
    <blockquote class="userstuff">comment text</blockquote>
    <p class="edited datetime">edited date</p>
    <ul class="actions">...</ul>
  </li>
  <!-- replies are nested ol.thread inside a plain li -->
</ol>
```

| Selector | Targets |
|----------|---------|
| `ol.thread` | Comment thread list |
| `li.comment` | Any individual comment |
| `li.odd.comment` / `li.even.comment` | Alternating comments |
| `.comment .byline.heading` | Commenter name + date |
| `.comment .userstuff` | Comment body text |
| `.comment ul.actions` | Reply/delete/etc. links |
| `#comment_456` | Specific comment by ID |

---

## Index
Type: BASELINE + REFERENCE

A list of items (works, bookmarks, etc.). Can be `ol`, `ul`, or `dl`.

```html
<ol class="work index group">   <!-- or ul, or dl -->
  <li class="work blurb group">...</li>
  <li class="work blurb group">...</li>
</ol>
```

Class pattern: `[type] index group` — e.g. `work index group`, `bookmark index group`, `tags index group`.

---

## Listbox
Type: BASELINE + REFERENCE

Contains one or more indexes. Used when a page could show multiple index types.

```html
<div class="work listbox group">   <!-- or li, fieldset, etc. — never ol/ul/dl -->
  <h3 class="heading">Works</h3>
  <ol class="work index group">...</ol>
</div>
```

First child is always a heading. Never `ol.listbox`, `ul.listbox`, or `dl.listbox`.

---

## Actions / Navigation
Type: BASELINE + REFERENCE

```html
<ul class="navigation actions">
  <li><a href="...">Link</a></li>
  <li><span class="current">Current Page</span></li>
  <li aria-haspopup="true">
    <a>Dropdown</a>
    <ul class="secondary">
      <li><a>Sub-item</a></li>
    </ul>
  </li>
</ul>
```

Pagination:
```html
<ol class="pagination actions">
  <li class="previous"><a>← Previous</a></li>
  <li><span class="current">2</span></li>
  <li><a>3</a></li>
  <li class="next"><a>Next →</a></li>
</ol>
```

| Selector | Targets |
|----------|---------|
| `ul.navigation.actions` | Nav link lists |
| `ol.pagination` | Page number nav |
| `.pagination li.previous` / `.next` | Prev/next page links |
| `span.current` | Active nav item or page number |
| `ul.actions` | Generic action button list |
| `p.submit.actions` | Single submit button wrapper |

---

## Forms (Interactions)
Type: BASELINE + REFERENCE

Forms use definition lists for label/input pairs:

```html
<form class="verbose post">
  <fieldset>
    <legend>Section Name</legend>
    <h3 class="landmark heading">Section Name</h3>
    <dl>
      <dt class="required"><label>Field*</label></dt>
      <dd class="required"><input type="text"></dd>
      <dt><label>Optional</label></dt>
      <dd><select>...</select></dd>
    </dl>
  </fieldset>
  <ul class="actions">
    <li><input type="submit" value="Post"></li>
  </ul>
</form>
```

`.verbose` on form = 4+ fieldsets. Label comes before text/select, after checkbox/radio.

---

## Modal
Type: BASELINE + REFERENCE

AO3 uses a single shared modal for help text, symbols keys, share dialogs, and similar overlays. It is JS-driven — content is fetched from the `href` of the trigger link and injected into `#modal`.

### Trigger links
Type: BASELINE + REFERENCE

Any link that opens the modal has the class `modal` and `aria-controls="modal"`. Common combinations:

```html
<!-- Symbol/help icon trigger (used on required-tags icons) -->
<a class="help symbol question modal modal-attached"
   title="Symbols key"
   href="/help/symbols_key"
   aria-controls="modal">
  <span class="rating-mature rating" title="Mature">
    <span class="text">Mature</span>
  </span>
</a>

<!-- Generic action trigger (e.g. Share button) -->
<a class="modal modal-attached"
   title="Share Bookmark"
   href="/bookmarks/1234/share"
   aria-controls="modal">Share</a>
```

| Class | Meaning |
|-------|---------|
| `modal` | Marks the link as a modal trigger |
| `modal-attached` | Added by JS when the modal has been initialized; indicates the link is wired up |
| `help symbol question` | Combo used specifically on help/symbols-key icon links |

### Modal container (rendered at end of `<body>`)
Type: BASELINE + REFERENCE

The modal DOM is injected at the bottom of the page by JS. When open:

```html
<!-- Overlay background — click closes modal -->
<div id="modal-bg" class="modal-closer" style="display: block;">
  <div class="loading" style="display: none;"></div>
</div>

<!-- Scrollable wrapper — also closes modal on click outside -->
<div id="modal-wrap" class="modal-closer" style="display: block; top: 0px;">
  <div id="modal" class="tall">                   <!-- .tall added when content is long -->

    <!-- Content area: fetched HTML injected here -->
    <div class="content userstuff">
      <h4>Modal Title</h4>
      <p>...</p>
    </div>

    <!-- Footer with title and close link -->
    <div class="footer">
      <span class="title">Modal title repeated</span>
      <a class="action modal-closer" href="#">Close</a>
    </div>

  </div>
</div>
```

### Key selectors
Type: BASELINE + REFERENCE

| Selector | Targets |
|----------|---------|
| `#modal` | The modal box itself |
| `#modal-bg` | Full-page overlay/backdrop |
| `#modal-wrap` | Scrollable outer wrapper |
| `#modal .content` | Injected content area |
| `#modal .footer` | Footer bar with title + close link |
| `#modal .content.userstuff` | Content styled as userstuff (help text pages) |
| `#modal.tall` | Modal with long content (class toggled by JS) |
| `.modal-closer` | Any element that closes the modal on click (bg, wrap, close link) |
| `a.modal` | Any trigger link that opens the modal |
| `a.modal-attached` | Trigger link that has been wired up by JS |

### Notes for userscripts
Type: RECOMMENDATION + REFERENCE

- `#modal`, `#modal-bg`, and `#modal-wrap` are absent from the DOM until the first modal is triggered, then persist (hidden) for the rest of the session.
- To detect when a modal opens, observe `#modal-wrap` or `#modal` for `display` style changes, or listen for AO3's custom events if available.
- The `href` on a `.modal` trigger is the URL of the content fragment that gets loaded — useful for identifying which modal is being opened.
- Do not rely on `#modal` being present on page load; always check or use a MutationObserver.

---

## Work Title Links
Type: BASELINE + REFERENCE

Work titles in indexes and blurbs use `a.work` (not just `a` inside `.heading`):

```html
<h4 class="heading"><a href="..." class="work">Work Title</a></h4>
```

Default styling: Georgia serif, `font-size: 1.143em`, `color: #900`.

```css
/* target work title links specifically */
a.work { font-family: 'Your Font', serif; }
```

---

## `.draft` State
Type: BASELINE + REFERENCE

Unpublished works and drafts get a distinct visual treatment:

```html
<li class="work blurb group draft">...</li>
```

Default styling: `border: 2px dashed #aaa`, `background: #ededed`, `opacity: 0.95`.

```css
/* detect draft items */
li.blurb.draft { }
```

---

## `.commas` Lists
Type: BASELINE + REFERENCE

Many tag lists use `.commas` to auto-insert commas via CSS without manual markup:

```html
<ul class="tags commas">
  <li class="relationships"><a class="tag">Ship A/B</a></li>
  <li class="characters"><a class="tag">Character</a></li>
</ul>
```

CSS rule: `li:after { content: ", " }` with `li:last-child:after { content: none }`.

To suppress commas in a skin: `ul.commas li:after { content: none; }`.

---

## Tag Cloud
Type: BASELINE + REFERENCE

Tag cloud lists use per-item weight classes from `.cloud1` (smallest) to `.cloud8` (largest/`#900`):

```html
<ul class="tag cloud">
  <li><a href="..." class="tag cloud3">Fandom Name</a></li>
  <li><a href="..." class="tag cloud7">Popular Fandom</a></li>
</ul>
```

Target by class, not by color:
```css
a.cloud8 { font-size: 2em; }   /* largest */
a.cloud1 { font-size: 0.7em; } /* smallest */
```

---

## Filter Checkboxes / Radio Buttons
Type: RECOMMENDATION + REFERENCE

Filter forms use visually-hidden native inputs with CSS-styled `.indicator` pseudo-elements:

```html
<dd class="filters">
  <input type="checkbox" id="filter_1" class="... visually-hidden">
  <label for="filter_1">
    <span class="indicator"></span>
    Tag Name
  </label>
</dd>
```

The native input is hidden with `clip: rect(0 0 0 0); position: absolute`. The visual checkbox is `.indicator:before`:
- Include checkbox: checkmark `\2713` with green gradient
- Exclude checkbox: X mark `\2715` with red gradient
- Radio button: filled circle with radial gradient

**Userscript targeting:** Use the actual `input[type="checkbox"]` or `input[type="radio"]` for value reading. The `.indicator` is purely visual.

```js
// read filter state
document.querySelectorAll('form.filters input[type="checkbox"]:checked')
  .forEach(input => console.log(input.value));
```

---

## Announcement Types
Type: BASELINE + REFERENCE

Site-wide announcements in the header area come in three visual styles:

```html
<div class="announcement">             <!-- default: blue background (#d1e1ef) -->
<div class="announcement event">       <!-- event: red gradient (#700 to #a00), white text -->
<div class="announcement alert">       <!-- alert: gold background (#fece3f) -->
```

| Selector | Background | Use |
|----------|------------|-----|
| `.announcement .userstuff` | `#d1e1ef` (blue) | Standard announcements |
| `.event .userstuff` | `#700`→`#a00` gradient (red) | Fundraising events |
| `.alert .userstuff` | `#fece3f` (gold) | Urgent alerts |

---

## Work Skin Utility Classes
Type: BASELINE + REFERENCE

AO3 ships a `basic_formatting.css` work skin with utility classes for formatting work content. These are available to authors in work HTML (notes, endnotes, content). All require the `#workskin` prefix — see `work-skin-classes.md` for the full reference.

Quick overview:
- Text formatting: `.indent`, `.dropcap`, `.flashback`, `.caps`, `.spoiler`, `.border`
- Fonts: `.font-serif`, `.font-sansserif`, `.font-monospace`, `.font-big`, `.font-small`
- Alignment: `.align-right`, `.align-center`, `.align-justify`
- Colors: `.font-red`, `.font-green`, `.font-blue` + 17 named variants (`.font-teal`, `.font-cherryred`, etc.)
- HRs: `hr.third` (33% width), `hr.full`

---

## Tables
Type: RECOMMENDATION + REFERENCE

Use tables for 3+ pieces of information in a cross-reference matrix — not for layout. Required structure:

```html
<table summary="Describes what the table does (for screen readers)">
  <caption>Brief visible title</caption>
  <thead>
    <tr><th scope="col">Column A</th><th scope="col">Column B</th></tr>
  </thead>
  <tfoot>
    <!-- operators / submit actions before tbody -->
  </tfoot>
  <tbody>
    <tr>
      <th scope="row">Row heading</th>
      <td>Data cell</td>
    </tr>
  </tbody>
</table>
```

Default styling: `background: #ddd`, `border-collapse: collapse`, full width. Rows separated by `1px solid #fff` gaps against the `#ddd` table background.

If you only have 2 types of data: use a `<dl>` instead. If the table would be very wide with many columns: it's probably better as blurbs.

---

## Nomination States
Type: BASELINE + REFERENCE

Used on gift exchange nomination pages inside `.nominations` contexts:

```html
<li class="nominations approved">...</li>
<li class="nominations rejected">...</li>
```

| Class | Background | Text |
|-------|------------|------|
| `.nominations .approved` | `#d1f0d1` (light green) | `color: #008000` |
| `.nominations .rejected` | `#efd1d1` (light red) | `color: #900` |

---

## Workskin Wrapper
Type: BASELINE + REFERENCE

Work page content lives inside:

```html
<div id="workskin">
  <!-- preface (notes/summary) -->
  <!-- chapter content in div.userstuff -->
  <!-- afterword (end notes) -->
</div>
```

`#workskin` is the target for both site skins and work-specific skins. Styles here override the main cascade for work content.

---

## Site Constants (from config.yml)
Type: HARD RULE + REFERENCE

Useful numbers to know when writing userscripts that parse, count, or validate AO3 content.

### Pagination and display counts
Type: HARD RULE + REFERENCE

| Constant | Value | Meaning |
|----------|-------|---------|
| `ITEMS_PER_PAGE` | 25 | Works/bookmarks per index page |
| `COMMENT_THREAD_MAX_DEPTH` | 5 | Maximum comment nesting depth |
| `NUMBER_OF_ITEMS_VISIBLE_IN_DASHBOARD` | 5 | Items shown in dashboard preview |
| `NUMBER_OF_ITEMS_VISIBLE_ON_HOMEPAGE` | 3 | Items shown on homepage |
| `TAGS_IN_CLOUD` | 200 | Tags shown in a tag cloud |
| `TAG_LIST_LIMIT` | 300 | Max tags in a tag list |
| `MAX_KUDOS_TO_SHOW` | 50 | Kudos usernames shown before truncation |
| `MAX_SEARCH_RESULTS` | 100,000 | Hard cap on paginated search results |
| `MAX_FAVORITE_TAGS` | 20 | Max saved favorite tags per user |

### Content field length limits
Type: HARD RULE + REFERENCE

| Field | Max characters |
|-------|---------------|
| Title | 255 |
| Summary | 1,250 |
| Notes | 5,000 |
| Comment | 10,000 |
| Tag name | 150 |
| Work content (stored) | 510,000 |
| Work content (displayed) | 500,000 |
| User "about me" | 100,000 |
| FAQ / info pages | 200,000 |
| Icon alt text | 250 |

### Tag input/output
Type: HARD RULE + REFERENCE

- Tags are comma-separated on input: `DELIMITER_FOR_INPUT: ','`
- Tags are output as `", "` (comma + space): `DELIMITER_FOR_OUTPUT: ', '`
- Max user-defined tags per work: **75**

### Download formats
Type: HARD RULE + REFERENCE

AO3 offers works in: `azw3`, `epub`, `mobi`, `pdf`, `html`

Useful if your userscript adds download links or detects format availability.

### Datetime format
Type: BASELINE + REFERENCE

AO3's default datetime format string: `%Y-%m-%d %I:%M%p` (e.g. `2013-09-30 11:45AM`)

Dates in blurbs use a shorter display format — the full timestamp appears in the `datetime` attribute of `<time>` elements where present.

### Fields that allow HTML (userstuff)
Type: HARD RULE + REFERENCE

These fields may contain HTML markup and are rendered as `.userstuff`:
`about_me` `bookmarker_notes` `comment` `content` `description` `endnotes` `notes` `rules` `series_notes` `summary`

Fields that allow embedded CSS (within work content only): `content`, `endnotes`, `notes`

Fields that allow video embeds: `content` only



