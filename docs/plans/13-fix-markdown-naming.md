# Markdown Fragment Naming Fix Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rename 8 raw Markdown fragment files in `source/gate-walkers/` to use underscore prefixes so Middleman excludes them from the build output.

**Architecture:** Middleman treats any source file whose name begins with `_` as a partial and skips it during the build pass. The 8 `.md` files currently lack this prefix, so Middleman compiles each one into a raw fragment file with no `.html` extension in the build tree (confirmed in `build/gate-walkers/` — e.g. `entities_bodied`, `gates_header`). Adding the prefix stops the spurious build without changing runtime behaviour — the 5 ERB pages that load these files via `File.read()` simply need their paths updated.

**Tech Stack:** Middleman 4.6, Kramdown (used inside `_card.erb` via the `markdown: true` local), ERB templates, `git mv`.

---

## File Map

### Renamed (underscore prefix added)

| Old path | New path |
|---|---|
| `source/gate-walkers/entities_bodied.md` | `source/gate-walkers/_entities_bodied.md` |
| `source/gate-walkers/entities_spirits.md` | `source/gate-walkers/_entities_spirits.md` |
| `source/gate-walkers/terms_places_culture.md` | `source/gate-walkers/_terms_places_culture.md` |
| `source/gate-walkers/terms_measure.md` | `source/gate-walkers/_terms_measure.md` |
| `source/gate-walkers/gates_header.md` | `source/gate-walkers/_gates_header.md` |
| `source/gate-walkers/konungariket_header.md` | `source/gate-walkers/_konungariket_header.md` |
| `source/gate-walkers/fudge/attributes_body.md` | `source/gate-walkers/fudge/_attributes_body.md` |
| `source/gate-walkers/fudge/attributes_mind.md` | `source/gate-walkers/fudge/_attributes_mind.md` |

### ERB files updated

- `source/gate-walkers/entities.html.erb` — 2 `File.read` paths
- `source/gate-walkers/terms.html.erb` — 2 `File.read` paths
- `source/gate-walkers/gates.html.erb` — 1 `File.read` path
- `source/gate-walkers/konungariket.html.erb` — 1 `File.read` path
- `source/gate-walkers/fudge/attributes.html.erb` — 2 `File.read` paths

### Documentation updated

- `CLAUDE.md` — add `markdown` local to card component table; add underscore-prefix convention note
- `TODO.md` — add task entry for this fix and mark it complete

---

## Task 1: Rename markdown fragment files

**Files:**
- Rename: all 8 `.md` files listed in the file map above

- [ ] **Step 1: Rename all 8 files using git mv**

```bash
git mv source/gate-walkers/entities_bodied.md source/gate-walkers/_entities_bodied.md
git mv source/gate-walkers/entities_spirits.md source/gate-walkers/_entities_spirits.md
git mv source/gate-walkers/terms_places_culture.md source/gate-walkers/_terms_places_culture.md
git mv source/gate-walkers/terms_measure.md source/gate-walkers/_terms_measure.md
git mv source/gate-walkers/gates_header.md source/gate-walkers/_gates_header.md
git mv source/gate-walkers/konungariket_header.md source/gate-walkers/_konungariket_header.md
git mv source/gate-walkers/fudge/attributes_body.md source/gate-walkers/fudge/_attributes_body.md
git mv source/gate-walkers/fudge/attributes_mind.md source/gate-walkers/fudge/_attributes_mind.md
```

- [ ] **Step 2: Verify renames are staged**

```bash
git status
```

Expected: 8 lines of the form `renamed: source/gate-walkers/foo.md -> source/gate-walkers/_foo.md`.

---

## Task 2: Update File.read paths in ERB pages

**Files:**
- Modify: `source/gate-walkers/entities.html.erb`
- Modify: `source/gate-walkers/terms.html.erb`
- Modify: `source/gate-walkers/gates.html.erb`
- Modify: `source/gate-walkers/konungariket.html.erb`
- Modify: `source/gate-walkers/fudge/attributes.html.erb`

- [ ] **Step 1: Update `entities.html.erb`**

Replace the two `File.read` lines to reference underscore-prefixed filenames. Full file after edit:

```erb
---
title: Gate Walkers - Entities
---
<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⟐', title: 'The Bodied', markdown: true,
    content: File.read(File.join(app.root, 'source/gate-walkers/_entities_bodied.md'))
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⟐', title: 'Spirits', markdown: true,
    content: File.read(File.join(app.root, 'source/gate-walkers/_entities_spirits.md'))
  } %>
<% end %>

<%= partial "partial/card_grid", locals: { columns: 2, content: cards_html } %>
```

- [ ] **Step 2: Update `terms.html.erb`**

Full file after edit:

```erb
---
title: Gate Walkers - Terms
---
<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: {
    colour: 'grey', icon: '⊞', title: 'Places and Cultures', markdown: true,
    content: File.read(File.join(app.root, 'source/gate-walkers/_terms_places_culture.md'))
  } %>
  <%= partial "partial/card", locals: {
    colour: 'grey', icon: '⊞', title: 'Units of Measure', markdown: true,
    content: File.read(File.join(app.root, 'source/gate-walkers/_terms_measure.md'))
  } %>
<% end %>

<%= partial "partial/card_grid", locals: { columns: 2, content: cards_html } %>
```

- [ ] **Step 3: Update `gates.html.erb`**

Full file after edit:

```erb
---
title: Gate Walkers - Gates
---
<%
  intro = Kramdown::Document.new(
    File.read(File.join(app.root, 'source/gate-walkers/_gates_header.md'))
  ).to_html
%>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: { colour: 'green', icon: '⬡', title: 'The Gate Minders', link: 'gate-guild.html', content: 'The consciousness that maintain and grow the gate network.' } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 4: Update `konungariket.html.erb`**

Full file after edit:

```erb
---
title: Gate Walkers - The Konungariket
---
<%
  intro = Kramdown::Document.new(
    File.read(File.join(app.root, 'source/gate-walkers/_konungariket_header.md'))
  ).to_html
%>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: { colour: 'blue', icon: '◈', title: 'Gransby',      link: 'gransby.html',   content: 'The frontier settlement and last hold of the Konungan.' } %>
  <%= partial "partial/card", locals: { colour: 'blue', icon: '◈', title: 'Kaningard',     link: 'kaningard.html', content: 'The collapsed mine — a barren depression hiding a thriving forest.' } %>
  <%= partial "partial/card", locals: { colour: 'blue', icon: '◈', title: 'Carcov',         link: 'carcov.html',    content: 'Details to be added.' } %>
  <%= partial "partial/card", locals: { colour: 'grey', icon: '◈', title: 'Grindarnastad', content: 'The City of Gates — the ancient capital of the Konungariket.', wide_title: true } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 5: Update `fudge/attributes.html.erb`**

Full file after edit:

```erb
---
title: Rules - Attributes
---
<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Attributes of the Body', markdown: true,
    content: File.read(File.join(app.root, 'source/gate-walkers/fudge/_attributes_body.md'))
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Attributes of the Mind', markdown: true,
    content: File.read(File.join(app.root, 'source/gate-walkers/fudge/_attributes_mind.md'))
  } %>
<% end %>

<%= partial "partial/card_grid", locals: { columns: 2, content: cards_html } %>
```

- [ ] **Step 6: Verify all File.read paths reference underscore-prefixed filenames**

```bash
grep -rn "File.read" source/gate-walkers/
```

Expected: every match contains `/_` in the path (e.g. `/_entities_bodied.md`). No match should reference a non-prefixed filename.

---

## Task 3: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

The card component locals table in CLAUDE.md lists `colour`, `icon`, `title`, `link`, `content` but omits the `markdown` local (which exists in `_card.erb` at line 7 and is used by 4 gate-walkers pages). Add it to the table and add a note about the underscore-prefix convention for markdown fragments.

- [ ] **Step 1: Add `markdown` row to the card locals table**

In the "Card component" section, replace the existing locals table with:

```markdown
| Local | Default | Notes |
|---|---|---|
| `colour` | `'grey'` | Applied as a compound class alongside `card` (e.g. `card grey`) |
| `icon` | `nil` | Optional UTF-8 character |
| `title` | `nil` | Optional heading (Orbitron font) |
| `link` | `nil` | Makes the whole card an `<a>`; adds `ACCESS →` footer |
| `content` | `''` | Main body — plain string or `capture_html` result |
| `markdown` | `false` | When `true`, renders `content` as Markdown via Kramdown |
```

- [ ] **Step 2: Add underscore-prefix note after the table**

Immediately after the card locals table, add this paragraph:

```markdown
Markdown fragment files loaded via `File.read` must be named with a leading underscore (e.g. `_entities_bodied.md`) so Middleman excludes them from the build output. Without the prefix, Middleman compiles each `.md` file into a raw fragment in `build/` (no `.html` extension, no layout).
```

---

## Task 4: Build and verify

- [ ] **Step 1: Build and extract**

```bash
./manage-sgi.sh --extract
```

Expected: build completes without errors. Watch for any Middleman file-not-found errors that would indicate a path was missed in Task 2.

- [ ] **Step 2: Confirm spurious fragment files are gone from build output**

```bash
ls build/gate-walkers/
```

The following names must **not** appear:

```
entities_bodied
entities_spirits
gates_header
konungariket_header
terms_measure
terms_places_culture
```

Only `.html` files and the `chat/` and `fudge/` subdirectories should be present.

```bash
ls build/gate-walkers/fudge/
```

The following names must **not** appear:

```
attributes_body
attributes_mind
```

- [ ] **Step 3: Confirm rendered pages still contain Markdown output**

```bash
grep -c "<p>" build/gate-walkers/entities.html
grep -c "<p>" build/gate-walkers/terms.html
grep -c "<p>" build/gate-walkers/gates.html
grep -c "<p>" build/gate-walkers/konungariket.html
grep -c "<p>" build/gate-walkers/fudge/attributes.html
```

Each command must return a non-zero count, confirming Kramdown rendered the fragment content into the page.

---