# Plan 06 — Adding Cards

Add a reusable card partial and card grid partial matching the `CyberCard` component in `Deuterium.ca.html`. First application: convert the footer to use the new card partial.

---

## New files

| File | Purpose |
|---|---|
| `source/partial/_card.erb` | Card component partial |
| `source/partial/_card_grid.erb` | Card grid layout partial |
| `styles/_card.scss` | Card and card grid SCSS |

## Modified files

| File | Change |
|---|---|
| `styles/_color-scheme.scss` | Replace scattered pink/green glow literals with a grouped block; add grey, blue (`-0`), and orange glow vars; all use variable-reference syntax |
| `styles/main.scss` | Add `@use "card"`; add `fade-slide-in` keyframe to `_animations.scss` |
| `source/partial/_footer.erb` | Rewrite using the card partial |

---

## Card partial — `source/partial/_card.erb`

### Inputs (via `locals`)

| Local | Type | Required | Default | Notes |
|---|---|---|---|---|
| `colour` | string | no | `'grey'` | Applied as `card--<colour>` CSS class |
| `icon` | string | no | — | UTF-8 character; omitted if not passed |
| `title` | string | no | — | Card heading; omitted if not passed |
| `link` | string | no | — | If present, whole card becomes an `<a>` |

### Content passing

Content is passed as a `:content` local. Two Tilt ERB constraints shape this approach:

1. **No `local_assigns`** — Tilt injects locals as plain Ruby local variables, not a hash.
   Use `defined?(var) ? var : default` to handle optional locals safely.
2. **No block partials** — `<%= partial ... do %>` causes a `SyntaxError` because Tilt
   wraps `<%= expr %>` in parentheses, preventing the block's `end` from being reached.

For **plain-string content** (e.g. a description from a JSON data file) pass it directly:

```erb
<%= partial "partial/card", locals: { colour: "blue", title: "Example", icon: "◈",
                                      content: item["description"] } %>
```

For **HTML content** (e.g. the footer), capture the markup first using Padrino's
`capture_html` helper, then pass the result as `:content`:

```erb
<% card_body = capture_html do %>
  <p>Card body text here.</p>
<% end %>
<%= partial "partial/card", locals: { colour: "blue", title: "Example", icon: "◈",
                                      content: card_body } %>
```

`capture_html` returns an HTML-safe string so ERB will not double-escape it. Plain strings
are escaped normally, which is correct for user-supplied text.

### Link wrapping

When `link` is provided the card root element becomes `<a href="...">` instead of
`<div>`. ERB does not have dynamic tag selection, so we use conditional open/close tags:

```erb
<% if card_link %>
<a href="<%= card_link %>" class="card card--<%= card_colour %>">
<% else %>
<div class="card card--<%= card_colour %>">
<% end %>
  ...
<% if card_link %>
</a>
<% else %>
</div>
<% end %>
```

The output is valid HTML. The SCSS targets `a.card:hover` for the glow — non-link cards
(which are `div.card`) never match this rule and are never styled as interactive.

### Template structure

```erb
<%
  card_colour  = defined?(colour)  ? colour  : 'grey'
  card_icon    = defined?(icon)    ? icon    : nil
  card_title   = defined?(title)   ? title   : nil
  card_link    = defined?(link)    ? link    : nil
  card_content = defined?(content) ? content : ''
%>
<% if card_link %>
<a href="<%= card_link %>" class="card card--<%= card_colour %>">
<% else %>
<div class="card card--<%= card_colour %>">
<% end %>
  <% if card_icon || card_title %>
  <div class="card__header">
    <% if card_icon %><span class="card__icon"><%= card_icon %></span><% end %>
    <% if card_title %><span class="card__title"><%= card_title %></span><% end %>
  </div>
  <% end %>
  <div class="card__content">
    <%= card_content %>
  </div>
  <% if card_link %>
  <div class="card__access">ACCESS →</div>
  <% end %>
<% if card_link %>
</a>
<% else %>
</div>
<% end %>
```

Corner decorations (top-right and bottom-left L-shapes) are rendered via CSS `::before`
and `::after` pseudo-elements — no extra markup needed.

---

## Card grid partial — `source/partial/_card_grid.erb`

### Inputs (via `locals`)

| Local | Type | Required | Default |
|---|---|---|---|
| `columns` | integer | no | `3` |

Content is yielded the same way as the card partial.

### Template structure

```erb
<%
  cols = defined?(columns) ? columns : 3
%>
<div class="card-grid" style="--card-grid-cols: <%= cols %>;">
  <%= yield %>
</div>
```

The number of columns is passed as a CSS custom property so SCSS can read it via
`var(--card-grid-cols)`. This avoids generating inline `grid-template-columns` strings
from ERB.

---

## `_color-scheme.scss` changes

Remove the existing scattered glow literals for pink and green and replace them — along
with new entries for grey, blue, and orange — with a single grouped block at the end of
the RGBa section. All entries use the variable-reference form so a base-colour change
propagates automatically:

```scss
// Glow variants (near = 0.53, far = 0.20)
$rgba-black-5-glow-near:  rgba($rgba-black-5,  0.53);
$rgba-black-5-glow-far:   rgba($rgba-black-5,  0.20);
$rgba-pink-0-glow-near:   rgba($rgba-pink-0,   0.53);
$rgba-pink-0-glow-far:    rgba($rgba-pink-0,   0.20);
$rgba-green-0-glow-near:  rgba($rgba-green-0,  0.53);
$rgba-green-0-glow-far:   rgba($rgba-green-0,  0.20);
$rgba-blue-0-glow-near:   rgba($rgba-blue-0,   0.53);
$rgba-blue-0-glow-far:    rgba($rgba-blue-0,   0.20);
$rgba-orange-0-glow-near: rgba($rgba-orange-0, 0.53);
$rgba-orange-0-glow-far:  rgba($rgba-orange-0, 0.20);
```

---

## SCSS — `styles/_card.scss`

### Color mapping

| Class | Accent variable | Hover glow variables |
|---|---|---|
| `card--grey` | `$rgba-black-5` | `$rgba-black-5-glow-near`, `$rgba-black-5-glow-far` |
| `card--pink` | `$rgba-pink-0` | `$rgba-pink-0-glow-near`, `$rgba-pink-0-glow-far` |
| `card--green` | `$rgba-green-0` | `$rgba-green-0-glow-near`, `$rgba-green-0-glow-far` |
| `card--blue` | `$rgba-blue-0` | `$rgba-blue-0-glow-near`, `$rgba-blue-0-glow-far` |
| `card--orange` | `$rgba-orange-0` | `$rgba-orange-0-glow-near`, `$rgba-orange-0-glow-far` |

### Base card styles

```scss
.card {
    background: #0e1420;
    border: 1px solid $hex-border-black;
    border-left: 3px solid currentColor;  // overridden per colour class
    padding: 1.5rem;
    position: relative;
    animation: fade-slide-in 0.4s ease;

    // Top-right corner decoration
    &::before {
        content: '';
        position: absolute;
        top: -1px;
        right: -1px;
        width: 12px;
        height: 12px;
        border-top: 2px solid;    // inherits accent colour
        border-right: 2px solid;
    }

    // Bottom-left corner decoration
    &::after {
        content: '';
        position: absolute;
        bottom: -1px;
        left: -1px;
        width: 12px;
        height: 12px;
        border-bottom: 2px solid;
        border-left: 2px solid;
    }
}
```

`currentColor` propagates the `color` set on the card's colour class to all
`border-color` properties that use it. This means `border-left`, `::before`, and
`::after` all share the same value and only need to be set once per variant.

### Colour variants

Use a SCSS `@each` over a map keyed by class name:

```scss
// Each entry: (text-and-border-colour, near-glow, far-glow)
$card-color-map: (
  'grey':   ($rgba-black-5,  $rgba-black-5-glow-near,  $rgba-black-5-glow-far),
  'pink':   ($rgba-pink-0,   $rgba-pink-0-glow-near,   $rgba-pink-0-glow-far),
  'green':  ($rgba-green-0,  $rgba-green-0-glow-near,  $rgba-green-0-glow-far),
  'blue':   ($rgba-blue-0,   $rgba-blue-0-glow-near,   $rgba-blue-0-glow-far),
  'orange': ($rgba-orange-0, $rgba-orange-0-glow-near, $rgba-orange-0-glow-far),
);

@each $name, $values in $card-color-map {
    $accent: nth($values, 1);
    $near:   nth($values, 2);
    $far:    nth($values, 3);

    .card--#{$name} {
        color: $accent;
        border-left-color: $accent;
        &::before, &::after { border-color: $accent; }

        .card__icon  { color: $accent; }
        .card__title { color: $accent; }
    }

    a.card--#{$name}:hover {
        background: #101c28;
        border-color: $accent;
        box-shadow: 0 0 20px $near, 0 0 40px $far;
        cursor: pointer;
    }
}
```

### Header and content areas

```scss
.card__header {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    margin-bottom: 0.75rem;
}

.card__icon {
    font-size: 1.5rem;
}

.card__title {
    font-family: orbitron, sans;
    font-weight: 700;
    font-size: 1rem;
    letter-spacing: 0.05em;
}

.card__content {
    color: $rgba-black-5;
    font-size: 0.9rem;
    line-height: 1.7;
}

.card__access {
    margin-top: 1rem;
    font-family: share-tech-mono, sans;
    font-size: 0.75rem;
    color: currentColor;  // inherits the card's accent colour
}
```

### Card grid

```scss
.card-grid {
    display: grid;
    grid-template-columns: repeat(var(--card-grid-cols, 3), minmax(0, 1fr));
    gap: 1rem;
}
```

### Transition

Add `transition: background 0.25s, border-color 0.25s, box-shadow 0.25s` to `.card` so
the hover glow animates in smoothly for linked cards.

---

## Footer update — `source/partial/_footer.erb`

Replace the current `<address>` block with a single grey card. The footer wraps it — the
card-grid partial is not needed here since there is only one card.

```erb
<footer>
  <%= partial "partial/card", locals: { colour: "grey" } do %>
    <div class="footer-system-info">
      <div class="footer-system-label">// SYSTEM INFO</div>
      NODE: shammancer.github.io<br>
      REGION: Canada<br>
      EMAIL: <a href="mailto:webmaster@deuterium.ca">webmaster@deuterium.ca</a><br>
      &copy;<%= (Date.today).strftime("%Y") %> Dannick Pomerleau
    </div>
  <% end %>
</footer>
```

Add matching SCSS to `_card.scss` (or keep in `main.scss` under `footer`):

```scss
.footer-system-label {
    font-family: share-tech-mono, sans;
    font-size: 0.75rem;
    letter-spacing: 0.1em;
    color: $rgba-black-5;
    margin-bottom: 0.5rem;
}

.footer-system-info {
    font-family: share-tech-mono, sans;
    font-size: 0.8rem;
    line-height: 1.8;
    color: $rgba-black-5;

    a {
        color: $rgba-blue-0;
        font-size: 0.85rem;
        text-decoration: none;
    }
}
```

The existing `footer` CSS in `main.scss` (border-top, margin-top, padding-top) is kept
as-is — the card sits inside the footer, the footer itself provides the top separator.

---

## `styles/main.scss` change

Add after the existing `@use` lines:

```scss
@use "card";
```

`_animations.scss` does not currently have a `fade-slide-in` keyframe — add it there:

```scss
@keyframes fade-slide-in {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
}
```

`_card.scss` does not need to `@use "animations"` — keyframe names are resolved at
render time by the browser, not at SCSS compile time.
