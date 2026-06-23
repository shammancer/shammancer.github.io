# Code Review — cyber branch
**Date:** 2026-06-22
**Range:** `4d70cedfcb` (origin/master) → `33e2165177` (HEAD)
**Scope:** SCSS nesting refactor in `_header.scss` — flattened `h1` descendant rules moved inside the `h1 {}` block

---

## Findings

```json
[
  {
    "file": "styles/_header.scss",
    "line": 25,
    "summary": "`a:visited` is a sibling block of `a {}` inside `h1` instead of nested inside it with `&:visited`",
    "failure_scenario": "CLAUDE.md states: 'Use the `&` combinator to nest child and modifier selectors inside their parent block rather than writing separate top-level classes.' The `:visited` pseudo-class is a modifier of the `a` element, not a separate child — it belongs as `a { &:visited { color: $rgba-pink-0; } }`. As written, a future maintainer adding properties to the `a {}` block may miss the separate `a:visited {}` override and create silent specificity conflicts."
  },
  {
    "file": "styles/_header.scss",
    "line": 49,
    "summary": "`h2 .typewriter-cursor` is a flat sibling selector left outside `h2 {}`, inconsistent with the nesting refactor applied to `h1` in this diff",
    "failure_scenario": "The diff nested all `h1` child selectors inside `h1 {}`, but the adjacent `h2 .typewriter-cursor {}` block at line 49 remains a flat sibling of `h2 {}` at the `header {}` scope. This violates the same CLAUDE.md rule and leaves the file with mixed nesting styles, making the structure harder to read."
  },
  {
    "file": "styles/_header.scss",
    "line": 26,
    "summary": "`a:visited` sets `color: $rgba-pink-0` — the same value already set by `a {}` — creating a silent divergence risk",
    "failure_scenario": "The `a:visited` block is functionally necessary to suppress browser default visited-link coloring, but it duplicates the `$rgba-pink-0` value already declared in `a {}`. If the `a {}` color is changed later, the `:visited` block must be updated separately or the two states will silently diverge. Merging into `a { &:visited { color: $rgba-pink-0; } }` keeps both declarations co-located and eliminates the drift risk."
  }
]
```

---

## Notes

**No correctness bugs were introduced.** The compiled CSS output is semantically identical to the old flat-sibling rules — confirmed against `build/styles/main.css`. Specificity is unchanged for all four affected selectors (`h1 .glitch-wrap`, `h1 a`, `h1 a:visited`, `h1 .glitch-ghost`). The HTML structure in `source/partial/_header.erb` matches the selector paths produced by the new nesting.

All three findings are conventions/cleanup in nature. Findings 1 and 3 are directly addressable by finishing the nesting with `&:visited`. Finding 2 is pre-existing but the diff drew attention to it by partially addressing the same pattern.
