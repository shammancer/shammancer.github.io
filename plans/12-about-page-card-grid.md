# About Page Card Grid Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the flat Markdown about page with a card grid layout driven by per-card Markdown partials.

**Architecture:** `source/about.html.erb` captures intro, four card partials, and footer into named locals, then delegates to the `card_grid` partial. Card content lives in `source/about/_*.html.md` files; Middleman's leading-underscore convention prevents them from building as standalone pages.

**Tech Stack:** Middleman v4.6, ERB, Kramdown, SCSS (no changes required)

**Note:** Do not run `git commit` or `git add` — the user commits manually.

---

## File Structure

| Action | Path | Purpose |
|---|---|---|
| Delete | `source/about.html.md` | Old flat Markdown page |
| Create | `source/about.html.erb` | New ERB page — card_grid layout |
| Create | `source/about/_education.html.md` | Education card content |
| Create | `source/about/_work-experience.html.md` | Work Experience card content |
| Create | `source/about/_skills.html.md` | Skills card content |
| Create | `source/about/_personal-interests.html.md` | Personal Interests card content |
| Modify | `TODO.md` | Mark about page task complete |

---

### Task 1: Create the Markdown partials

**Files:**
- Create: `source/about/_education.html.md`
- Create: `source/about/_work-experience.html.md`
- Create: `source/about/_skills.html.md`
- Create: `source/about/_personal-interests.html.md`

- [ ] **Step 1: Create `source/about/` directory**

```bash
mkdir -p source/about
```

- [ ] **Step 2: Create `source/about/_education.html.md`**

```markdown
Bachelor of Science in Computer Engineering, University of Alberta. First year completed at Campus St-Jean.
```

- [ ] **Step 3: Create `source/about/_work-experience.html.md`**

```markdown
- Documented requirements for a data visualization product and developed a road map for its implementation
- Developed the data visualization product using a Spring Boot-based API to facilitate the use of modern design patterns
- Created a real-time dashboard to track the daily production and uptime of a manufacturing facility
- Collaborated with stakeholders in a quality review process to refine the user interface of multiple projects
```

- [ ] **Step 4: Create `source/about/_skills.html.md`**

```markdown
- Java, Python, C, Rust
- Strong experience with Archlinux, Fedora, and Red Hat and Derivatives
- Comfortable with Windows
```

- [ ] **Step 5: Create `source/about/_personal-interests.html.md`**

```markdown
- First degree black belt in ICTF Taekwon-do
- Grade 8 Royal Conservatory of Music in Piano
- Science fiction and fantasy novels
- Board games and video games
```

---

### Task 2: Create `source/about.html.erb`

**Files:**
- Delete: `source/about.html.md`
- Create: `source/about.html.erb`

- [ ] **Step 1: Delete the old Markdown page**

```bash
rm source/about.html.md
```

- [ ] **Step 2: Create `source/about.html.erb`**

```erb
---
title: About
---

<% intro = capture_html do %>
  <p>Franco-Albertan information security practitioner with a Bachelor of Science in Computer Engineering from the University of Alberta. Interests span low-level programming, computer architecture, security, and networking.</p>
<% end %>

<% cards_html = capture_html do %>
  <% education_content = capture_html { partial "about/education" } %>
  <%= partial "partial/card", locals: {
    colour:  'green',
    icon:    '◎',
    title:   'Education',
    content: education_content
  } %>

  <% work_content = capture_html { partial "about/work-experience" } %>
  <%= partial "partial/card", locals: {
    colour:  'pink',
    icon:    '◈',
    title:   'Work Experience',
    content: work_content
  } %>

  <% skills_content = capture_html { partial "about/skills" } %>
  <%= partial "partial/card", locals: {
    colour:  'green',
    icon:    '⬡',
    title:   'Skills',
    content: skills_content
  } %>

  <% interests_content = capture_html { partial "about/personal-interests" } %>
  <%= partial "partial/card", locals: {
    colour:  'pink',
    icon:    '◇',
    title:   'Personal Interests',
    content: interests_content
  } %>
<% end %>

<% footer_html = capture_html do %>
  <p>If you have any questions about my experience feel free to <a href="/contact.html">contact me</a>.</p>
<% end %>

<%= partial "partial/card_grid", locals: {
  header:  intro,
  content: cards_html,
  footer:  footer_html
} %>
```

---

### Task 3: Build and verify

- [ ] **Step 1: Build the app image and extract the built site**

```bash
./manage-sgi.sh --extract
```
Expected: Build completes without errors and `build/about.html` is present.

- [ ] **Step 3: Open `build/about.html` in a browser and verify**

Check:
- Four cards render: Education (green ◎), Work Experience (pink ◈), Skills (green ⬡), Personal Interests (pink ◇)
- Introduction paragraph appears above the grid
- Footer call-to-action appears below the grid with a working contact link
- Card content is rendered from each Markdown partial (lists display with `›` bullets)
- Grid responds correctly: 1 column on narrow viewports, 2 columns at 600px, 3 columns at 1200px+

---

### Task 4: Update TODO.md

**Files:**
- Modify: `TODO.md`

- [ ] **Step 1: Mark the about page task complete with strikethrough**

Find this entry in `TODO.md`:

```
* Update the about page to a card grid layout. Each card should be a separate markdown file. There should be the following cards:
    * Education, just the bachelors degree.
    * Work Experience: Existing content
    * Skills: Updated to a simple list.
    * Personal Interests: Existing content
  An introduction and footer should still be maintained. The introduction shouldThe footer should contain the call to action
```

Replace with:

```
* ~~Update the about page to a card grid layout. Each card should be a separate markdown file. There should be the following cards:~~
```
