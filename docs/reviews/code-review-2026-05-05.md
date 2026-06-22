# Code Review — cyber branch
**Date:** 2026-05-05
**Range:** `4d70cedf` (origin/master) → `1ea98039` (HEAD)
**Scope:** Card component BEM removal, font SCSS restructuring, about page card grid conversion, index two-column limit

---

## Strengths

**ERB partial conventions are correctly applied throughout.** `capture_html { partial "..." }` is used consistently in `about.html.erb` to pre-render Markdown partials before passing them as locals to the card component. No `<%= partial ... do %>` block pattern is used anywhere. The `defined?(var) ? var : default` idiom is applied to every local in both `_card.erb` and `_card_grid.erb`, which is exactly right for Tilt ERB.

**The BEM removal is clean and complete.** `card`, `pink`, `wide-title`, `icon`, `title`, `content`, `access` are all short contextual names scoped by SCSS nesting. The `@at-root` workaround for `a.card.#{$name}:visited/:hover` is a sound alternative to `a&.#{$name}` and produces identical CSS output. The resulting selectors in the compiled CSS are correct.

**Font pipeline is correctly wired.** All used fonts (`fira`, `orbitron`, `rajdhani`, `share-tech-mono`) are declared in `styles/fonts/` with the `gen-font-face` mixin and imported in `main.scss`. The `@use "font-mixin" as *` inside each font partial resolves correctly because sass-embedded 1.x searches relative to the including file for bare (non-`./`) imports when no separate load path is set — confirmed by the presence of 38 `@font-face` declarations in the compiled `build/styles/main.css`.

**The `card-grid` CSS formula handles the `columns: 1` and `columns: 2` override cleanly.** `repeat(min(var(--card-grid-cols, 2), 2), ...)` at the 600px breakpoint correctly caps at 2, so passing `columns: 1` from the about page gives a single column at all widths.

**The `data/index.json` → card data pipeline is straightforward and safe.** Plain strings from the JSON are passed directly as `content` locals without `capture_html`, which is the right approach per the CLAUDE.md convention.

**The color scheme variables are complete for all five card colours.** All glow pairs (`-glow-near` / `-glow-far`) are defined and consumed symmetrically in both `_card.scss` and `_button.scss`.

**Build confirmed working.** The `build/about.html` and `build/index.html` files are dated today and reflect the current implementation correctly — card grid, semantic elements, correct colour classes, and font preloads.

---

## Issues

### Critical (Must Fix)

None. The build succeeds and produces correct output.

### Important (Should Fix)

**1. Missing Continuous Learning card — spec deviation**

- **Files:** `source/about/`, `source/about.html.erb`
- **What's wrong:** `specs/12-about-page-card-grid.md` specifies five cards including a `_continuous-learning.html.md` partial between Education and Work Experience. The file is absent and no corresponding card call exists in `about.html.erb`. The implementation delivers four cards.
- **Why it matters:** The spec is a committed contract. If the omission was a deliberate scope cut, the spec should note it; if it was overlooked, it's incomplete work.
- **How to fix:** Either add `source/about/_continuous-learning.html.md` with content and a matching card call in `about.html.erb`, or annotate the spec that the card was deferred.

**2. Duplicate `$rgba-green-0` variable declaration**

- **File:** `styles/_color-scheme.scss`, lines 56–57
- **What's wrong:** `$rgba-green-0` is defined twice in sequence with identical values (`rgba(170,243,0,1)`). This is a copy-paste artifact.
- **Why it matters:** Harmless now since both values are identical, but creates ambiguity. Sass with `@use` treats this as a reassignment and will emit a deprecation warning in future versions.
- **How to fix:** Delete the duplicate line 57.

**3. `_roboto-mono.scss` is an orphaned file**

- **File:** `styles/fonts/_roboto-mono.scss`
- **What's wrong:** The file exists with 14 `@font-face` declarations but `main.scss` does not `@use` it. The font is not compiled into the output. The font files are in `source/fonts/RobotoMono/` but will never be served via `@font-face`.
- **Why it matters:** If RobotoMono is unused, the SCSS file is misleading dead code. If it was intended to be used, it's missing its import.
- **How to fix:** If intentional, delete both `styles/fonts/_roboto-mono.scss` and `source/fonts/RobotoMono/`. If you plan to use it later, add `@use "fonts/roboto-mono";` to `main.scss`.

### Minor (Nice to Have)

**4. Hardcoded background colors in `_card.scss` not referenced from the color scheme**

- **File:** `styles/_card.scss`, lines 9 and 69
- **What's wrong:** `background: #0e1420` (resting state) and `background: #101c28` (hover state) are magic hex values with no corresponding named variable in `_color-scheme.scss`. Everything else references a variable.
- **How to fix:** Add `$hex-card-bg: #0e1420` and `$hex-card-bg-hover: #101c28` to `_color-scheme.scss` and reference them in `_card.scss`.

**5. Missing semicolon on `display: block` in `main.scss`**

- **File:** `styles/main.scss`, line 128
- **What's wrong:** `display: block` has no trailing semicolon. SCSS is lenient when it is the last property in a block, and the build succeeds. It is still a style inconsistency.
- **How to fix:** Add the semicolon: `display: block;`

**6. `cursor: pointer` on `a.card:hover` is redundant**

- **File:** `styles/_card.scss`, line 72
- **What's wrong:** `<a>` elements already render with `cursor: pointer` by default. The declaration has no effect.
- **How to fix:** Remove `cursor: pointer;` from the hover block.

**7. Inconsistent nesting depth in `_header.scss`**

- **File:** `styles/_header.scss`, lines 15 and 30
- **What's wrong:** `h1 .glitch-wrap` and `h1 .glitch-ghost` are written as descendant selector strings inside `header {}` rather than as fully-nested `h1 { .glitch-wrap { ... } }`. Mixes nesting styles and departs from the CLAUDE.md convention.
- **How to fix:** Nest them properly: `h1 { .glitch-wrap { ... } .glitch-ghost { ... } }`.

---

## Recommendations

**Consider the `markdown: true` path vs Middleman rendering.** Two patterns are used: (a) `capture_html { partial "some-file.html.md" }` — correct for underscore-prefixed partials processed through Middleman's pipeline; and (b) `File.read("some-file.md")` with `markdown: true` — used in gate-walkers pages, bypassing the pipeline. Those files live in `source/` without underscore prefix, meaning Middleman may also try to build them as standalone pages. Worth confirming they're excluded or that the naming prevents Middleman from picking them up as HTML pages.

**The `wide-title` breakpoint sequence is fragile.** The cascade of breakpoints (600px → 650px → 1200px → 1425px → 1500px → 2900px) was clearly tuned for a specific title string. A future title change would silently break the layout. A comment explaining the breakpoint rationale would prevent future confusion.

---

## Assessment

**Ready to merge: Yes**, with the minor caveat around the continuous-learning card.

The build is clean and the core deliverables — BEM removal, font SCSS restructuring, about page card grid conversion, and two-column index limit — are all correctly implemented and verified in the compiled output. The duplicate variable and missing semicolon are cosmetic. The only substantive finding is the missing fifth card from the about page spec; whether that matters depends on whether the spec was treated as a strict contract or a starting template.
