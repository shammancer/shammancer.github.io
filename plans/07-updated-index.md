# Plan 07 — Updated Index

Replace the current placeholder index page with a card-grid layout driven by a `data/index.json` file. Update the nav to iterate over the same data rather than being hardcoded.

---

## New files

| File | Purpose |
|---|---|
| `data/index.json` | Navigation / index card data |

## Modified files

| File | Change |
|---|---|
| `source/index.html.erb` | Replace placeholder text with card grid consuming `data.index` |
| `source/partial/_header.erb` | Replace hardcoded nav links with iteration over `data.index` |
| `source/partial/_card_grid.erb` | Add `content` local support (required by Tilt ERB block constraint) |

---

## Step 1 — `data/index.json`

Middleman auto-loads all files under `data/` as data objects, accessible via `data.<filename>`. The `data/` directory does not currently exist and must be created alongside the file.

The file is a JSON array. Each entry maps to one card on the index page and one `<li>` in the nav.

```json
[
  {
    "icon": "◈",
    "title": "Blog",
    "link": "/blog.html",
    "description": "Thoughts, posts, and dispatches from the grid.",
    "colour": "pink"
  },
  {
    "icon": "⬡",
    "title": "Gate Walkers",
    "link": "/gate-walkers/index.html",
    "description": "A collaborative fiction project.",
    "colour": "green"
  },
  {
    "icon": "◉",
    "title": "About",
    "link": "/about.html",
    "description": "Background, skills, and experience.",
    "colour": "pink"
  },
  {
    "icon": "⟁",
    "title": "Contact",
    "link": "/contact.html",
    "description": "Open a channel. Preferred method: email.",
    "colour": "green"
  }
]
```

Sources:
- `icon` — UTF-8 character from each card in `Deuterium.ca.html` `IndexPage` cards array
- `title` — `label` field from each card; link text from current `_header.erb`
- `link` — current `link_to` href values from `_header.erb`
- `description` — `desc` field from each card in `IndexPage`
- `colour` — mapped from React CSS variable: `var(--pink)` → `pink`, `var(--lime)` → `green`

---

## Step 2 — Card grid update — `source/partial/_card_grid.erb`

The existing card_grid partial uses `yield` for its content slot. This conflicts with the Tilt ERB block partial constraint (see CLAUDE.md): `<%= partial "..." do %>` is a syntax error. Change it to accept a `content` local — the same pattern as `_card.erb`.

```erb
<%
  cols     = defined?(columns) ? columns : 3
  grid_content = defined?(content) ? content : ''
%>
<div class="card-grid" style="--card-grid-cols: <%= cols %>;">
  <%= grid_content %>
</div>
```

---

## Step 3 — Navigation update — `source/partial/_header.erb`

Replace the four hardcoded `<li>` items with a loop over `data.index`:

```erb
<header>
    <h1>
        <span class="glitch-wrap">
            <%= link_to 'Deuterium.ca', '/index.html' %>
            <span class="glitch-ghost" aria-hidden="true">Deuterium.ca</span>
        </span>
    </h1>
    <h2>> <%= current_page.data.title %></h2>
</header>
<nav>
    <ul>
        <% data.index.each do |item| %>
        <li><%= link_to item["title"], item["link"] %></li>
        <% end %>
    </ul>
</nav>
```

Order in the JSON matches the visual nav order. No styling changes needed.

---

## Step 4 — Index page — `source/index.html.erb`

Replace the placeholder `<p>` with a card grid. Because `_card_grid.erb` now takes a `content` local (not yield), capture all the card output first with `capture_html`, then pass it in.

```erb
---
title: Index
---

<% cards_html = capture_html do %>
  <% data.index.each do |item| %>
    <%= partial "partial/card", locals: {
      colour:  item["colour"],
      icon:    item["icon"],
      title:   item["title"],
      link:    item["link"],
      content: item["description"]
    } %>
  <% end %>
<% end %>

<%= partial "partial/card_grid", locals: { columns: 2, content: cards_html } %>
```

`columns: 2` gives a two-column grid at full width, matching the four-card layout in `Deuterium.ca.html` (`repeat(auto-fit, minmax(260px, 1fr))`). The actual responsive collapse is handled by `_card.scss`'s `minmax(0, 1fr)` — if the viewport is narrow enough, the grid will naturally reflow to one column regardless of the `--card-grid-cols` value.
