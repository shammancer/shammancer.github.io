# Fix Card Grid Collapse Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the card grid responsive — 3 columns at ≥ 1200px, 2 columns at 600–1199px, 1 column below 600px — and remove the now-unused `--card-grid-cols` custom property mechanism.

**Architecture:** Add `@media` breakpoints directly to `.card-grid` in `_card.scss` using hard-coded column counts. Strip the inline `--card-grid-cols` style from `_card_grid.erb` and the `columns` local from `index.html.erb`. No new files needed.

**Tech Stack:** Middleman 4.6, SCSS (sass-embedded external pipeline), ERB partials.

---

### Task 1: Make the card grid responsive

**Files:**
- Modify: `styles/_card.scss` (lines 107–111, the `.card-grid` block)
- Modify: `source/partial/_card_grid.erb`
- Modify: `source/index.html.erb`

- [ ] **Step 1: Update `.card-grid` in `styles/_card.scss`**

Replace the existing `.card-grid` block (currently the last rule in the file):

```scss
.card-grid {
    display: grid;
    grid-template-columns: repeat(var(--card-grid-cols, 3), minmax(0, 1fr));
    gap: 1rem;
}
```

With:

```scss
.card-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 1rem;

    @media (max-width: 1199px) {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    @media (max-width: 599px) {
        grid-template-columns: 1fr;
    }
}
```

- [ ] **Step 2: Update `source/partial/_card_grid.erb`**

Replace the entire file content with:

```erb
<%
  grid_content = defined?(content) ? content : ''
%>
<div class="card-grid">
  <%= grid_content %>
</div>
```

- [ ] **Step 3: Update `source/index.html.erb`**

Replace:

```erb
<%= partial "partial/card_grid", locals: { columns: 2, content: cards_html } %>
```

With:

```erb
<%= partial "partial/card_grid", locals: { content: cards_html } %>
```

- [ ] **Step 4: Build and extract the site**

```bash
./manage-sgi.sh --extract
```

Expected: build completes with no errors.

- [ ] **Step 5: Verify the output**

```bash
grep 'card-grid' build/index.html
```

Expected: `<div class="card-grid">` with no `style` attribute containing `--card-grid-cols`.

```bash
grep 'card-grid-cols' build/index.html
```

Expected: no output (the custom property is gone).

- [ ] **Step 6: Commit**

```bash
git add styles/_card.scss source/partial/_card_grid.erb source/index.html.erb
git commit -m "Make card grid responsive (1/2/3 cols by viewport)"
```
