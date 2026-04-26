# AO3 JavaScript Patterns Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


AO3 uses jQuery extensively. These are the CSS classes and DOM patterns that JavaScript adds, removes, or depends on — critical for userscripts that need to detect state or hook into interactions.

---

## Body / Global State Classes
Type: BASELINE + REFERENCE

These classes are added to `body` or `#outer` by JavaScript at page load or in response to user actions.

| Class | Added to | Meaning |
|-------|----------|---------|
| `.javascript` | `body` | JS is enabled. Many CSS rules only apply under `.javascript`. If you don't see this, JS hasn't run yet. |
| `.logged-in` | `body` | User is logged in. Affects splash page layout and some UI elements. |

### `.javascript` in CSS
Type: BASELINE + REFERENCE

AO3 uses `.javascript` as a prefix throughout the stylesheets to apply styles only when JS is active. Examples:

```css
.javascript form.filters { position: absolute; }         /* filter sidebar becomes slide-out */
.javascript .narrow-hidden { display: none; }            /* hide elements replaced by JS equivalents */
.javascript .work.navigation .secondary { display: flex; } /* work nav secondary becomes flex menu */
```

**Userscript implication:** If your script adds elements that should only show with JS, scope them under `.javascript`. If you need to check whether AO3's JS has initialised, check for `document.body.classList.contains('javascript')`.

---

## Responsive JS Classes
Type: BASELINE + REFERENCE

Applied based on screen width in combination with media queries.

| Class | Meaning |
|-------|---------|
| `.narrow-shown` | Display this element only on narrow screens (≤42em). Hidden by default, shown in narrow stylesheet. |
| `.narrow-hidden` | Hide this element on narrow screens when JS is active. Used to remove elements replaced by JS equivalents. |
| `.filtering` | Applied to `#main` when the filter sidebar is open on narrow screens. Shifts content left. |

---

## Dropdown Menus
Type: BASELINE + REFERENCE

Dropdowns are `li.dropdown` elements. JS toggles `.open` on the `li` to show/hide the menu.

```html
<li class="dropdown">                    <!-- .open added by JS when active -->
  <a class="dropdown-toggle">Menu</a>
  <ul class="menu dropdown-menu">
    <li><a>Item</a></li>
  </ul>
</li>
```

| Class | Meaning |
|-------|---------|
| `.dropdown` | Container `li` for a dropdown menu |
| `.dropdown-toggle` | The trigger link |
| `.menu` / `.dropdown-menu` | The hidden menu list |
| `.open` | Added to `.dropdown` when menu is visible |

CSS only shows the menu when `.open` is present:
```css
#header .dropdown .menu { display: none; }
#header .dropdown.open .menu, #header .dropdown:hover .menu { display: block; }
```

**Userscript:** Watch for `.open` being added/removed on `.dropdown` to detect menu open/close.

---

## Work Navigation Secondary Menu
Type: BASELINE + REFERENCE

The chapter navigation bar on work pages has an expandable secondary menu (for download, chapter select, etc.).

```html
<ul class="work navigation actions">
  <li class="expanded">        <!-- .expanded toggled by JS -->
    <a>...</a>
    <ul class="secondary">    <!-- shown when .expanded is present -->
      ...
    </ul>
  </li>
</ul>
```

| Class | Meaning |
|-------|---------|
| `.work.navigation` | Work page navigation bar |
| `.secondary` | Hidden submenu |
| `.expanded` | Added to `li` by JS to show `.secondary` |

Under `.javascript`, the secondary is `display: flex` when `.expanded` is present; otherwise hidden.

---

## Filter Sidebar (Narrow Screens)
Type: BASELINE + REFERENCE

On narrow screens (≤42em) with JS, the filter form becomes an off-screen slide-out panel.

| Class/State | Meaning |
|-------------|---------|
| `form.filters` | The filter sidebar (normally `float: right; width: 23%`) |
| `#main.filtering` | JS adds `.filtering` to `#main` when filter panel is open — shifts main content left |
| `#leave_filters` | Background overlay element — clicking closes the filter panel |
| `.narrow-shown` on filter toggle | The "show filters" button, only visible on narrow screens |

---

## Form Modes
Type: BASELINE + REFERENCE

Forms get a mode class describing their complexity and layout behaviour.

| Class | Applied to | Meaning |
|-------|------------|---------|
| `.simple` | `form` | Standard form (default, ≤3 fieldsets) |
| `.verbose` | `form` | Complex form with 4+ fieldsets; legends become visible |
| `.single` | `form` | Single-input form (e.g. block user, search). Input goes full width. |
| `.toggled` | `form` | Form shown/hidden by JS toggle (e.g. inline reply forms) |
| `.dynamic` | `form` | Form loaded/inserted dynamically via AJAX |
| `.post` | `form` | Work/chapter post form |

`.verbose` is important: it makes `<legend>` elements visible (normally hidden with `height: 0; font-size: 0`).

---

## Modal State Classes
Type: BASELINE + REFERENCE

| Class | Applied to | Meaning |
|-------|------------|---------|
| `.modal` | `a` | Trigger link — opens modal on click |
| `.modal-attached` | `a` | Added by JS after the modal is initialised on this link |
| `.modal-closer` | `#modal-bg`, `#modal-wrap`, `a.action` | Clicking these elements closes the modal |
| `.tall` | `#modal` | Added by JS when content is long (adjusts height behaviour) |
| `.img` | `#modal` | Added when modal contains an image |
| `.loading` | `div` inside `#modal-bg` | Shown while content is fetching |

The modal DOM (`#modal-bg`, `#modal-wrap`, `#modal`) does not exist on page load. It is created on first trigger and then persists hidden. Use a `MutationObserver` on `body` to detect it being added.

**Z-index context:** `#modal-bg` is 499, `#modal` is **501**, `div.dynamic` is 500 — all below the ToS prompt (999) and far below `.qtip` (15000). See `stylesheet-cascade.md` for the full z-index table.

---

## jQuery UI Widget Classes
Type: BASELINE + REFERENCE

AO3 uses jQuery UI for several interactive widgets. These classes are added by the library.

| Class | Widget | Notes |
|-------|--------|-------|
| `.ui-sortable` | Sortable list | Added to lists where items can be dragged to reorder |
| `.ui-draggable` | Draggable element | Individual draggable item |
| `.ui-datepicker` | Date picker | Calendar popup for date fields |
| `.ui-timepicker-div` | Time picker | Time selection widget |
| `.autocomplete` | Tag autocomplete | Dropdown suggestions for tag input fields |
| `.autocomplete li.input` | Autocomplete | The text input row inside the autocomplete |
| `.added` | Autocomplete tag | A selected/added tag in an autocomplete field |
| `.qtip` | Tooltip | `z-index: 15000` — highest on page; inject above it with 15001+ |

### `div.dynamic`
Type: BASELINE + REFERENCE

`div.dynamic` is `position: absolute; z-index: 500` — overlaps modal backdrop. Forms inside `.dynamic` lose fieldset borders and background (styled flat). The autocomplete dropdown (`ul` inside `.autocomplete div.dropdown`) is the main `.dynamic` pattern.

---

## Form Validation Classes
Type: BASELINE + REFERENCE

AO3 uses LiveValidation for inline form feedback.

| Class | Meaning |
|-------|---------|
| `.LV_validation_message` | Inline validation message container |
| `.LV_valid` | Field passed validation |
| `.LV_invalid` | Field failed validation |
| `.LV_valid_field` | Applied to the input itself when valid |
| `.LV_invalid_field` | Applied to the input itself when invalid |

`.LV_*` classes follow a specific naming convention (prefix `LV_`) — don't rename them.

---

## Character Counter
Type: BASELINE + REFERENCE

The character counter widget appears below comment text areas.

```html
<div class="character_counter">
  <span class="current">0</span> / <span class="max">10000</span>
</div>
```

| Class | Meaning |
|-------|---------|
| `.character_counter` | Counter container (floated left in comment context) |
| `.current` | Current character count (updated by JS) |
| `.max` | Maximum allowed characters |

---

## Interaction State Classes (CSS-visible JS state)
Type: BASELINE + REFERENCE

These classes reflect current JS-managed state and are useful for userscript selectors.

| Class | Where | Meaning |
|-------|-------|---------|
| `.open` | `.dropdown li` | Dropdown is currently open |
| `.expanded` | `li` in work nav | Secondary menu is expanded |
| `.filtering` | `#main` | Filter sidebar is open (narrow) |
| `.dynamic` | `.bookmark` | Bookmark section loaded dynamically |
| `.toggled` | `form` | Form toggled visible by JS |
| `.hidden` | Various | Explicitly hidden by JS (overrides CSS visibility) |
| `.loading` | Modal backdrop | Modal content is loading |
| `.modal-attached` | `a.modal` | Modal event bound to this link |

---

## Filter Sidebar — aria-expanded
Type: RECOMMENDATION + REFERENCE

`filters.js` converts `dt.filter-toggle` elements to `<button class="expander" aria-expanded="true|false">`. This is more reliable than watching class changes:

```js
// detect filter section open/close
document.querySelectorAll('button.expander').forEach(btn => {
  const observer = new MutationObserver(() => {
    const isOpen = btn.getAttribute('aria-expanded') === 'true';
    // act on isOpen
  });
  observer.observe(btn, { attributes: true, attributeFilter: ['aria-expanded'] });
});
```

Active filter sections (containing non-empty inputs) are auto-expanded on page load.

---

## AO3 JS API
Type: BASELINE + REFERENCE

For programmatic control of AO3's JS — opening modals, intercepting AJAX, character counters — see `js-api.md`.

Quick reference:
- **Open modal programmatically**: `window.ao3modal.show(url, title)`
- **Intercept form AJAX**: `$(form).on('ajax:before', fn)` — return false to cancel
- **After AJAX completes**: `$(form).on('ajax:complete', fn)`
- **Auto character counter**: add class `.observe_textlength` to a `<textarea>`; AO3 attaches the counter automatically
- **CSRF token ready** (logged-out sessions): `$(document).one('loadedCSRF', fn)`

---

## Useful Patterns for Userscripts
Type: RECOMMENDATION + REFERENCE

### Detecting page type
Type: RECOMMENDATION + REFERENCE

```js
// check zone/page class on #main
const main = document.getElementById('main');
main.classList.contains('works-index');    // work listing page
main.classList.contains('dashboard');      // has sidebar
main.classList.contains('filtered');       // has filter sidebar
main.classList.contains('help-skins_creating'); // skin creation help page
```

### Detecting login state
Type: RECOMMENDATION + REFERENCE

```js
document.body.classList.contains('logged-in');
// or: check for #greeting vs #login
document.getElementById('greeting') !== null;
```

### Detecting JS initialisation
Type: RECOMMENDATION + REFERENCE

```js
document.body.classList.contains('javascript'); // AO3's JS has run
```

### Hooking into dropdown open/close
Type: RECOMMENDATION + REFERENCE

```js
document.querySelectorAll('.dropdown').forEach(el => {
  const observer = new MutationObserver(() => {
    if (el.classList.contains('open')) { /* menu opened */ }
  });
  observer.observe(el, { attributes: true, attributeFilter: ['class'] });
});
```

### Detecting modal open
Type: RECOMMENDATION + REFERENCE

```js
const observer = new MutationObserver((mutations) => {
  for (const m of mutations) {
    const modal = document.getElementById('modal-wrap');
    if (modal && modal.style.display !== 'none') {
      // modal is open; check modal content
      const content = document.querySelector('#modal .content');
    }
  }
});
observer.observe(document.body, { childList: true, subtree: true, attributes: true, attributeFilter: ['style'] });
```



