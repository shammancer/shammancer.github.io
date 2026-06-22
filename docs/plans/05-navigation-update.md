# Plan 05 — Navigation Update

Update navigation to match `Deuterium.ca.html`, remove the `<hr>` separator, and replace it with a bottom border on the nav and bottom margin on the header.

---

## Reference behaviour

From `Deuterium.ca.html`:

- Nav has `display: flex`, `gap: 0.25rem`, `padding: 0.75rem 0`, `flex-wrap: wrap`
- Nav has a `border-bottom: 1px solid #1a2a3a` (dark blue-grey separator line)
- Each nav item is uppercase, `letter-spacing: 0.1em`, `font-size: 0.85rem`, `padding: 0.35rem 0.85rem`
- Each item has a `1px solid transparent` border at rest — so the box doesn't shift on hover
- On hover: color shifts to cyan (`$rgba-blue-1`), border colour shifts to a faint cyan tint
- No `<hr>` — the nav border-bottom replaces it

---

## Steps

### 1. Add border colour variable to `_color-scheme.scss`

The reference border `#1a2a3a` has no palette equivalent. Add it as a standalone variable under  $hex-background-black:

```scss
$hex-border-black: #1a2a3a;
```

### 2. Remove `<hr>` from `source/partial/_header.erb`

Delete the `<hr>` line entirely.

### 3. Add bottom margin to `header` in `styles/_header.scss`

Replace the visual gap that `<hr>` provided with explicit margin on the header:

```scss
header {
    margin-bottom: 1.25rem;
    // … existing styles
}
```

### 4. Rewrite `styles/_navigation.scss`

Replace the current list-margin approach with the reference layout. Style the `<a>` elements directly to match the reference button appearance — bordered box, uppercase, letter-spaced:

```scss
nav {
    font-family: share-tech-mono, sans;
    display: flex;
    gap: 0.25rem;
    padding: 0.75rem 0;
    border-bottom: 1px solid $hex-border-black;
    flex-wrap: wrap;

    ul {
        display: flex;
        gap: 0.25rem;
        flex-wrap: wrap;
        margin: 0;
        padding: 0;
        list-style: none;
    }

    ul li a {
        display: inline-block;
        padding: 0.35rem 0.85rem;
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        color: $rgba-black-5;
        border: 1px solid transparent;
        text-decoration: none;
        transition: color 0.2s, border-color 0.2s;
    }

    ul li a:hover {
        color: $rgba-blue-1;
        border-color: rgba(50, 163, 212, 0.4);
    }

    ul li a:visited {
        color: $rgba-black-5;
    }

    ul li a:visited:hover {
        color: $rgba-blue-1;
    }
}
```

---

## Files changed

| File | Change |
|---|---|
| `styles/_color-scheme.scss` | Add `$hex-border-black` |
| `source/partial/_header.erb` | Remove `<hr>` |
| `styles/_header.scss` | Add `margin-bottom: 1.25rem` to `header` |
| `styles/_navigation.scss` | Rewrite to match reference layout and link styling |
