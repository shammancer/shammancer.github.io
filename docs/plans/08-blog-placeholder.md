# Blog Placeholder Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a placeholder blog page at `/blog.html` using the existing card partial.

**Architecture:** A single ERB page that renders the `_card.erb` partial directly — no `capture_html` needed since the content is a plain string. The nav link to `/blog.html` and the blue colour in the card map already exist; no other files need changing.

**Tech Stack:** Middleman 4.6, ERB, existing `_card.erb` partial, `sgi-app` container build.

---

### Task 1: Create the blog placeholder page

**Files:**
- Create: `source/blog.html.erb`

- [ ] **Step 1: Create the file**

`source/blog.html.erb`:
```erb
---
title: Blog
---

<%= partial "partial/card", locals: {
  colour:  'blue',
  icon:    '◈',
  title:   'Blog',
  content: 'POSTS INCOMING — AIs PONDERING'
} %>
```

- [ ] **Step 2: Build and extract the site**

```bash
./manage-sgi.sh --extract
```

Expected: build completes with no errors and `build/blog.html` is present.

- [ ] **Step 3: Verify the output**

```bash
grep -A 5 'card--blue' build/blog.html
```

Expected: output contains `card--blue`, the `◈` icon, the title `Blog`, and the text `POSTS INCOMING — AIs PONDERING`.

- [ ] **Step 4: Commit**

```bash
git add source/blog.html.erb
git commit -m "Add blog placeholder page"
```
