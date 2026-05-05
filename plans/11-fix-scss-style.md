# Fix SCSS Style: Remove BEM Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. Do not run `git commit` or `git add` — the user commits manually.

**Goal:** Remove all BEM class naming from `_card.scss`, `_card.erb`, and `_card_grid.erb`, replacing it with SCSS nesting and short contextual class names.

**Architecture:** Three files change atomically. SCSS element selectors move inside `.card {}` as short names (`.header`, `.icon`, `.title`, `.content`, `.access`). BEM modifiers (`card--pink`) become compound classes (`card pink`) matching the existing `.button.pink` pattern. Card-grid header/footer are HTML siblings of `.card-grid` (not children), so they become flat hyphenated names (`.card-grid-header`, `.card-grid-footer`) instead of BEM.

**Tech Stack:** SCSS (sass-embedded gem), ERB (Middleman), Podman containers via `./manage-sgi.sh`

---

### Task 1: Rewrite `styles/_card.scss`

**Files:**
- Modify: `styles/_card.scss`

- [ ] **Step 1: Replace the entire file**

```scss
@use "color-scheme" as *;

a.card {
    display: block;
    text-decoration: none;
}

.card {
    background: #0e1420;
    border: 1px solid $hex-border-black;
    border-left: 3px solid currentColor;
    padding: 1.5rem;
    position: relative;
    transition: background 0.25s, border-color 0.25s, box-shadow 0.25s;
    animation: fade-slide-in 0.4s ease;

    &::before {
        content: '';
        position: absolute;
        top: -1px;
        right: -1px;
        width: 12px;
        height: 12px;
        border-top: 2px solid;
        border-right: 2px solid;
    }

    &::after {
        content: '';
        position: absolute;
        bottom: -1px;
        left: -3px;
        width: 12px;
        height: 12px;
        border-bottom: 2px solid;
        border-left: 3px solid;
    }

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

        &.#{$name} {
            --card-accent: #{$accent};
            color: $accent;
            border-left-color: $accent;

            &::before, &::after { border-color: $accent; }

            .icon  { color: $accent; }
            .title { color: $accent; }
        }

        a&.#{$name}:visited {
            color: $accent;
        }

        a&.#{$name}:hover {
            background: #101c28;
            border-color: $accent;
            box-shadow: 0 0 20px $near, 0 0 40px $far;
            cursor: pointer;
        }
    }

    .header {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        margin-bottom: 0.75rem;
    }

    .icon {
        font-size: 1.5rem;
    }

    .title {
        font-family: orbitron, sans;
        font-weight: 700;
        font-size: 1rem;
        letter-spacing: 0.05em;
        min-width: 0;
        overflow-wrap: break-word;
    }

    .content {
        color: $rgba-black-5;
        font-size: 0.9rem;
        line-height: 1.7;

        ul {
            list-style: none;
            display: flex;
            flex-direction: column;
            gap: 0.4rem;

            li {
                display: flex;
                gap: 0.5rem;

                &::before {
                    content: '›';
                    color: var(--card-accent);
                    flex-shrink: 0;
                }
            }

            ul {
                margin-top: 0.25rem;

                li::before {
                    color: $rgba-black-5;
                }
            }
        }
    }

    .access {
        margin-top: 1rem;
        font-family: share-tech-mono, sans;
        font-size: 0.75rem;
        color: currentColor;
    }

    &.wide-title {
        @media (min-width: 600px) {
            grid-column: span 2;
        }

        @media (min-width: 650px) {
            grid-column: span 1;
        }

        @media (min-width: 1200px) {
            grid-column: span 2;
        }

        @media (min-width: 1425px) {
            grid-column: span 1;
        }

        @media (min-width: 1500px) {
            grid-column: span 2;
        }

        @media (min-width: 2900px) {
            grid-column: span 1;
        }
    }
}

.card-grid {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1rem;

    @media (min-width: 600px) {
        grid-template-columns: repeat(min(var(--card-grid-cols, 2), 2), minmax(0, 1fr));
    }

    @media (min-width: 1200px) {
        grid-template-columns: repeat(var(--card-grid-cols, 3), minmax(0, 1fr));
    }
}
```

**Note on `a&.#{$name}`:** Inside `.card {}`, `&` is `.card`, so `a&.#{$name}` generates `a.card.pink`. This preserves the original behaviour where hover/visited styles only apply to link cards (`<a>`), not static div cards.

---

### Task 2: Update `source/partial/_card.erb`

**Files:**
- Modify: `source/partial/_card.erb`

- [ ] **Step 1: Replace the entire file**

```erb
<%
  card_colour  = defined?(colour)  ? colour  : 'grey'
  card_icon    = defined?(icon)    ? icon    : nil
  card_title   = defined?(title)   ? title   : nil
  card_link    = defined?(link)    ? link    : nil
  card_content    = defined?(content)    ? content    : ''
  card_markdown   = defined?(markdown)   ? markdown   : false
  card_wide_title = defined?(wide_title) ? wide_title : false
%>
<%
  card_classes = "card #{card_colour}"
  card_classes += " wide-title" if card_wide_title
%>
<% if card_link %>
<a href="<%= card_link %>" class="<%= card_classes %>">
<% else %>
<div class="<%= card_classes %>">
<% end %>
  <% if card_icon || card_title %>
  <div class="header">
    <% if card_icon %><span class="icon"><%= card_icon %></span><% end %>
    <% if card_title %><span class="title"><%= card_title %></span><% end %>
  </div>
  <% end %>
  <div class="content">
    <% if card_markdown %>
      <%= Kramdown::Document.new(card_content).to_html %>
    <% else %>
      <%= card_content %>
    <% end %>
  </div>
  <% if card_link %>
  <div class="access">ACCESS →</div>
  <% end %>
<% if card_link %>
</a>
<% else %>
</div>
<% end %>
```

---

### Task 3: Update `source/partial/_card_grid.erb`

**Files:**
- Modify: `source/partial/_card_grid.erb`

- [ ] **Step 1: Replace the entire file**

```erb
<%
  grid_content = defined?(content) ? content : ''
  grid_header  = defined?(header)  ? header  : nil
  grid_footer  = defined?(footer)  ? footer  : nil
  grid_columns = defined?(columns) ? columns : nil
%>
<% if grid_header %>
<header><%= grid_header %></header>
<% end %>
<div class="card-grid"<% if grid_columns %> style="--card-grid-cols: <%= grid_columns %>"<% end %>>
  <%= grid_content %>
</div>
<% if grid_footer %>
<footer><%= grid_footer %></footer>
<% end %>
```

---

### Task 4: Update `styles/main.scss`

**Files:**
- Modify: `styles/main.scss`

- [ ] **Step 1: Add `header` and `footer` selectors inside the existing `main {}` block**

In `styles/main.scss`, add to the existing `main { ... }` block:

```scss
main {
    h1 { ... }  // existing
    h2 { ... }  // existing
    p  { ... }  // existing

    header { margin-bottom: 1rem; }
    footer { margin-top: 1rem; }
}
```

---

### Task 5: Build and verify

**Files:** (none — build and inspect only)

- [ ] **Step 1: Extract and inspect**

Run: `./manage-sgi.sh --extract`

Expected: build completes with no SCSS errors. Look for any `Error` or `SassException` in the output. If SCSS fails, check `styles/_card.scss` for syntax errors around the `a&.#{$name}` selectors.

Open `build/gate-walkers/index.html` in a browser. Verify:
- Cards render with correct colours (pink, blue, green, grey, orange)
- Card titles and icons display correctly
- The `wide-title` card (Konungariket) spans correctly at wide viewports
- Hover effects work on link cards
