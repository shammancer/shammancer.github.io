# Remove Card `markdown` Local — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the `markdown: true` handling from the card partial and replace all fragment-loading call sites with Middleman's built-in `partial` helper, which renders markdown to HTML natively.

**Architecture:** The card partial currently accepts a `markdown` local that triggers internal Kramdown rendering. Removing it means `content` is always treated as a plain string (HTML or text). All markdown content is instead rendered upstream via `partial(...)`, which Middleman processes through Kramdown before returning an HTML string. The `fragment` helper in `config.rb` becomes unused and is deleted.

**Tech Stack:** Middleman 4.6 (ERB templates, `partial` helper, Kramdown), Ruby, containerised build via `./manage-sgi.sh`.

## Global Constraints

- Never run `git commit` or `git add` — the user commits manually.
- Verify changes by running `./manage-sgi.sh --extract` and inspecting HTML output in `build/`.
- Middleman `partial` resolves paths relative to `source/` and automatically prepends `_` to the final path component. `partial "gate-walkers/entities_bodied"` finds `source/gate-walkers/_entities_bodied.md`.
- No unit test framework exists — verification is done by building the site and inspecting output.

---

## File Map

| Action | File |
|---|---|
| Modify | `source/partial/_card.erb` |
| Modify | `source/gate-walkers/entities.html.erb` |
| Modify | `source/gate-walkers/terms.html.erb` |
| Modify | `source/gate-walkers/fudge/attributes.html.erb` |
| Modify | `source/gate-walkers/gates.html.erb` |
| Modify | `source/gate-walkers/konungariket.html.erb` |
| Modify | `config.rb` |
| Modify | `CLAUDE.md` |

---

### Task 1: Simplify `_card.erb`

Remove the `markdown` local and its Kramdown branch. Content is always output directly.

**Files:**
- Modify: `source/partial/_card.erb:7,26-30`

- [ ] **Step 1: Remove the `markdown` local default (line 7)**

  Delete this line from the variable defaults block at the top:
  ```erb
  card_markdown   = defined?(markdown)   ? markdown   : false
  ```

- [ ] **Step 2: Collapse the content div (lines 26-30)**

  Replace:
  ```erb
  <div class="content">
    <% if card_markdown %>
      <%= Kramdown::Document.new(card_content).to_html %>
    <% else %>
      <%= card_content %>
    <% end %>
  </div>
  ```

  With:
  ```erb
  <div class="content">
    <%= card_content %>
  </div>
  ```

- [ ] **Step 3: Verify the card partial looks correct**

  Full resulting file should be:
  ```erb
  <%
    card_colour     = defined?(colour)     ? colour     : 'grey'
    card_icon       = defined?(icon)       ? icon       : nil
    card_title      = defined?(title)      ? title      : nil
    card_link       = defined?(link)       ? link       : nil
    card_content    = defined?(content)    ? content    : ''
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
    <header>
      <% if card_icon %><span class="icon"><%= card_icon %></span><% end %>
      <% if card_title %><span class="title"><%= card_title %></span><% end %>
    </header>
    <% end %>
    <div class="content">
      <%= card_content %>
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

### Task 2: Update card-content templates

Replace `fragment('_file.md'), markdown: true` with `partial('path/file')` in the three templates that load markdown into card `content`.

**Files:**
- Modify: `source/gate-walkers/entities.html.erb`
- Modify: `source/gate-walkers/terms.html.erb`
- Modify: `source/gate-walkers/fudge/attributes.html.erb`

- [ ] **Step 1: Update `entities.html.erb`**

  Replace the full file content with:
  ```erb
  ---
  title: Gate Walkers - Entities
  ---
  <% cards_html = capture_html do %>
    <%= partial "partial/card", locals: {
      colour: 'blue', icon: '⟐', title: 'The Bodied',
      content: partial('gate-walkers/entities_bodied')
    } %>
    <%= partial "partial/card", locals: {
      colour: 'blue', icon: '⟐', title: 'Spirits',
      content: partial('gate-walkers/entities_spirits')
    } %>
  <% end %>

  <%= partial "partial/card_grid", locals: { columns: 2, content: cards_html } %>
  ```

- [ ] **Step 2: Update `terms.html.erb`**

  Replace the full file content with:
  ```erb
  ---
  title: Gate Walkers - Terms
  ---
  <% cards_html = capture_html do %>
    <%= partial "partial/card", locals: {
      colour: 'grey', icon: '⊞', title: 'Places and Cultures',
      content: partial('gate-walkers/terms_places_culture')
    } %>
    <%= partial "partial/card", locals: {
      colour: 'grey', icon: '⊞', title: 'Units of Measure',
      content: partial('gate-walkers/terms_measure')
    } %>
  <% end %>

  <%= partial "partial/card_grid", locals: { columns: 2, content: cards_html } %>
  ```

- [ ] **Step 3: Update `fudge/attributes.html.erb`**

  Replace the full file content with:
  ```erb
  ---
  title: Rules - Attributes
  ---
  <% cards_html = capture_html do %>
    <%= partial "partial/card", locals: {
      colour: 'blue', icon: '⊕', title: 'Attributes of the Body',
      content: partial('gate-walkers/fudge/attributes_body')
    } %>
    <%= partial "partial/card", locals: {
      colour: 'blue', icon: '⊕', title: 'Attributes of the Mind',
      content: partial('gate-walkers/fudge/attributes_mind')
    } %>
  <% end %>

  <%= partial "partial/card_grid", locals: { columns: 2, content: cards_html } %>
  ```

- [ ] **Step 4: Build and verify**

  Run:
  ```bash
  ./manage-sgi.sh --extract
  ```

  Then confirm the three pages rendered correctly:
  ```bash
  grep -A4 'The Bodied\|Spirits' build/gate-walkers/entities.html | head -20
  grep -A4 'Places and Cultures\|Units of Measure' build/gate-walkers/terms.html | head -20
  grep -A4 'Attributes of the Body\|Attributes of the Mind' build/gate-walkers/fudge/attributes.html | head -20
  ```

  Expected: each card title appears, followed by a `<div class="content">` containing rendered HTML paragraphs/lists (not raw markdown).

---

### Task 3: Update header templates

Replace `Kramdown::Document.new(fragment(...)).to_html` with `partial(...)` in the two templates that load markdown as a page header.

**Files:**
- Modify: `source/gate-walkers/gates.html.erb`
- Modify: `source/gate-walkers/konungariket.html.erb`

- [ ] **Step 1: Update `gates.html.erb`**

  Replace the intro block:
  ```erb
  <%
    intro = Kramdown::Document.new(
      fragment('_gates_header.md')
    ).to_html
  %>
  ```

  With:
  ```erb
  <% intro = partial('gate-walkers/gates_header') %>
  ```

- [ ] **Step 2: Update `konungariket.html.erb`**

  Replace the intro block:
  ```erb
  <%
    intro = Kramdown::Document.new(
      fragment('_konungariket_header.md')
    ).to_html
  %>
  ```

  With:
  ```erb
  <% intro = partial('gate-walkers/konungariket_header') %>
  ```

- [ ] **Step 3: Build and verify**

  Run:
  ```bash
  ./manage-sgi.sh --extract
  ```

  Then confirm header content rendered:
  ```bash
  grep -A5 '<header>' build/gate-walkers/gates.html | head -15
  grep -A5 '<header>' build/gate-walkers/konungariket.html | head -15
  ```

  Expected: `<header>` contains `<p>` tags with the prose from the respective `_*_header.md` files.

---

### Task 4: Remove `fragment` helper and update docs

Delete the now-unused `fragment` helper from `config.rb` and remove the `markdown` row from the card component table in `CLAUDE.md`.

**Files:**
- Modify: `config.rb`
- Modify: `CLAUDE.md`

- [ ] **Step 1: Remove the `fragment` helper from `config.rb`**

  Delete the entire helpers block:
  ```ruby
  helpers do
    def fragment(filename)
      File.read(File.join(File.dirname(current_resource.source_file), filename))
    end
  end
  ```

  Replace it with the original commented-out placeholder:
  ```ruby
  # helpers do
  #   def some_helper
  #     'Helping'
  #   end
  # end
  ```

- [ ] **Step 2: Remove the `markdown` row from `CLAUDE.md`**

  In the card component locals table, delete this row:
  ```
  | `markdown` | `false` | When `true`, renders `content` as Markdown via Kramdown |
  ```

- [ ] **Step 3: Verify no remaining references to `fragment` or `markdown: true`**

  Run:
  ```bash
  grep -rn "fragment\|markdown:" source/gate-walkers/ source/partial/ config.rb
  ```

  Expected: no matches.

- [ ] **Step 4: Final build to confirm everything still works**

  Run:
  ```bash
  ./manage-sgi.sh --extract
  ```

  Expected: build completes with no errors, all pages created. Spot-check:
  ```bash
  grep -c "card" build/gate-walkers/entities.html build/gate-walkers/terms.html build/gate-walkers/gates.html build/gate-walkers/konungariket.html build/gate-walkers/fudge/attributes.html
  ```

  Expected: each file reports a non-zero count.
