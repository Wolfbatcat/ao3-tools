# AO3 JavaScript API Reference

## Rule Type Legend
Type: REFERENCE

- **HARD RULE**: enforced by AO3 sanitizer, parser, runtime, or config. Violating this can strip CSS, break behavior, or hit a real AO3 limit.
- **BASELINE**: current AO3 default style, DOM, class, or behavior. Useful to match or override, but not a requirement.
- **RECOMMENDATION**: safer authoring or userscript practice. Valid alternatives may exist.
- **REFERENCE**: lookup data such as tokens, sprite coordinates, constants, selectors, or routing notes.


Sources: `ao3modal.js`, `application.js`, `filters.js`, `rails.js` (jQuery-UJS)

This file covers programmatic JS API — functions to call, events to hook, and data attributes that drive AO3's behaviour. For class-based state detection patterns, see `js-patterns.md`.

---

## `window.ao3modal` — Modal API
Type: HARD RULE + REFERENCE

AO3 exposes a global modal API (`window.ao3modal`, also accessible as the shorthand `ao3modal`). Useful for userscripts that need to open, close, or populate the shared modal.

### Methods
Type: HARD RULE + REFERENCE

```js
window.ao3modal.show(href, title)       // open modal (fetch URL, anchor, or image)
window.ao3modal.hide()                  // close modal
window.ao3modal.setContent(content, title) // inject content directly (jQuery or HTML string)
window.ao3modal.addLink(elements)       // attach modal to dynamically inserted <a class="modal"> links
```

Examples:

```js
ao3modal.show('/help/symbols_key', 'Symbols Key')  // fetch help page
ao3modal.show('#my-element', 'Title')              // show in-page element
ao3modal.show('/images/example.jpg', 'Image')      // show image
```

### Content detection logic
Type: HARD RULE + REFERENCE

| `href` value | Modal behaviour |
|-------------|----------------|
| Ends in `.jpg`, `.gif`, `.bmp`, `.png` | Displays image (`.img` class on `#modal`) |
| Starts with `#` | Shows in-page element matching the selector |
| Otherwise | Fetches URL via AJAX and injects HTML into `#modal .content` |

### DOM notes
Type: HARD RULE + REFERENCE

- `#modal`, `#modal-bg`, `#modal-wrap` do not exist until the first modal trigger. Use `MutationObserver` on `body` to detect first creation.
- After first open they persist hidden (`display: none`) — check `#modal-wrap` `display` style to detect open state.
- `#modal` gets class `.tall` when content is long (height > viewport); `.img` when showing an image.
- **Z-index:** `#modal` = 501, `#modal-bg` = 499. To layer UI above the modal, use `z-index: 1000+`. To layer above tooltips too, use `15001+`. See `stylesheet-cascade.md` for the full table.

---

## Rails AJAX Events (jQuery-UJS)
Type: HARD RULE + REFERENCE

AO3 uses jQuery-UJS (`rails.js`) for AJAX form submissions and link actions. Events fire on the triggering element (form or link), not on `document`.

### Event lifecycle
Type: HARD RULE + REFERENCE

```
ajax:before → ajax:beforeSend → ajax:send → [ajax:success | ajax:error] → ajax:complete
```

### Event reference
Type: HARD RULE + REFERENCE

| Event | Signature | Use |
|-------|-----------|-----|
| `ajax:before` | `(event)` | Fires before request. Return `false` to cancel. |
| `ajax:beforeSend` | `(event, xhr, settings)` | Can modify `xhr` or `settings`. |
| `ajax:send` | `(event, xhr)` | Request is in flight. |
| `ajax:success` | `(event, data, status, xhr)` | 2xx response received. `data` is parsed response. |
| `ajax:error` | `(event, xhr, status, error)` | 4xx/5xx response. |
| `ajax:complete` | `(event, xhr, status)` | Always fires after success or error. Use for cleanup. |

### Examples
Type: RECOMMENDATION + REFERENCE

```js
// cancel a form submission conditionally
$('form.your-form').on('ajax:before', function() {
  if (!confirm('Sure?')) return false;
});

// act after kudos AJAX succeeds
$('#kudo_submit').on('ajax:success', function(e, data) {
  // data is the response HTML/JSON
});

// cleanup after any AJAX on a link
$('a[data-remote]').on('ajax:complete', function() {
  // re-enable UI, hide spinner, etc.
});
```

### Data attributes (drive AJAX without writing JS)
Type: HARD RULE + REFERENCE

| Attribute | Effect |
|-----------|--------|
| `data-remote="true"` | Submit via AJAX instead of navigating |
| `data-method="delete"` | Override HTTP method (DELETE, PUT, PATCH) |
| `data-confirm="Are you sure?"` | Show confirmation dialog before action |
| `data-disable-with="Saving…"` | Replace button text and disable during request |
| `data-params="key=value"` | Append extra query params to request |

---

## `application.js` — Page Initialisation & Global Functions
Type: HARD RULE + REFERENCE

### Initialisation order (document.ready)
Type: HARD RULE + REFERENCE

1. `setupToggled()` — wire `.toggled` show/hide elements
2. `hideFormFields()` — collapse optional work form sections
3. Dropdown setup — adds `.javascript` to `body`
4. Autocomplete (via `livequery`) — tag inputs
5. `attachCharacterCounters()` — `.observe_textlength` inputs
6. Kudos button AJAX (`#kudo_submit`)
7. Comment pagination scroll handlers
8. CSRF token refresh (async — fires `loadedCSRF` when done)

### Global functions available to userscripts
Type: HARD RULE + REFERENCE

```js
// Show/hide a form section when its controlling checkbox is toggled
toggleFormField(element_id)
// element_id: string ID of the <dd> or section to toggle

// Open/close AO3 modal
window.ao3modal.show(href, title)
window.ao3modal.hide()
```

### `.observe_textlength` — automatic character counter
Type: HARD RULE + REFERENCE

Add this class to any `<textarea>` and AO3 attaches a live character counter:

```html
<textarea class="observe_textlength" data-maxlength="10000"></textarea>
```

The counter renders as `.character_counter` with `.current` (count) and `.max` (limit) spans. This is the same pattern AO3 uses on comment boxes — see `js-patterns.md` for the HTML structure.

---

## Custom Events
Type: HARD RULE + REFERENCE

| Event | Fired on | When | Use |
|-------|----------|------|-----|
| `loadedCSRF` | `document` | After CSRF token is refreshed (async, logged-out sessions) | Wait for this before making AJAX requests in unauthenticated contexts |

```js
$(document).one('loadedCSRF', function() {
  // CSRF meta tag is now populated — safe to make AJAX requests
  const token = $('meta[name=csrf-token]').attr('content');
});
```

---

## Filter Sidebar (`filters.js`)
Type: HARD RULE + REFERENCE

The filter sidebar is progressively enhanced by `filters.js`. Key behaviours for userscripts:

### What the script does
Type: HARD RULE + REFERENCE

- Converts `dt.filter-toggle` elements into `<button class="expander" aria-expanded="false">` buttons
- Auto-expands filter sections that contain non-empty inputs (active filters)
- On narrow screens: wires `#go_to_filters` / `#leave_filters` links to show/hide the filter panel and toggle `.filtering` on `#main`
- Uses `.trap()` (keyboard focus trap plugin) on the mobile filter panel

### Reliable hooks
Type: RECOMMENDATION + REFERENCE

```js
// Detect filter section expand/collapse via aria-expanded (more reliable than class watching)
document.querySelectorAll('button.expander').forEach(btn => {
  new MutationObserver(() => {
    const open = btn.getAttribute('aria-expanded') === 'true';
    // open === true: filter section is expanded
  }).observe(btn, { attributes: true, attributeFilter: ['aria-expanded'] });
});

// Detect mobile filter panel open (class on #main)
new MutationObserver(() => {
  const filtering = document.getElementById('main').classList.contains('filtering');
}).observe(document.getElementById('main'), { attributes: true, attributeFilter: ['class'] });
```

---

## Quick Reference Table
Type: RECOMMENDATION + REFERENCE

| Task | How |
|------|-----|
| Open modal programmatically | `window.ao3modal.show(url, title)` |
| Close modal | `window.ao3modal.hide()` |
| Inject content into modal | `window.ao3modal.setContent(htmlOrJQuery, title)` |
| Wire newly-inserted modal links | `window.ao3modal.addLink($('a.modal.new'))` |
| Cancel an AJAX form submit | `$(form).on('ajax:before', () => false)` |
| React after AJAX completes | `$(form).on('ajax:complete', fn)` |
| Wait for CSRF token | `$(document).one('loadedCSRF', fn)` |
| Auto character counter on textarea | Add class `.observe_textlength` |
| Toggle a form section | `toggleFormField('element_id')` |
| Detect filter section open/close | Watch `aria-expanded` on `button.expander` |
| Detect mobile filter panel | Watch `.filtering` class on `#main` |
| Detect modal open | Watch `display` style on `#modal-wrap` |



