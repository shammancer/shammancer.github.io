# Plan 02 — Header Flicker Animation

Match the neon flicker and glow effect from `Deuterium.ca.html` on the site header.

---

## Reference behaviour

From `Deuterium.ca.html`:

- `flicker` — subtle opacity dip (1 → 0.6 → 1) that fires in a narrow window near the end of an 8s cycle, giving a rare, almost-imperceptible power-fluctuation feel.
- `neonFlicker` — rapidly toggles `text-shadow` on and off at frames 20%, 24%, and 55% of the cycle, simulating a neon tube with an unstable gas charge.

The title element runs both simultaneously:
`animation: glitch 6s infinite, flicker 8s infinite`
with `text-shadow` driven by `neonFlicker` applied to the same element.

---

## Steps

### 1. Create `styles/_animations.scss`

Define both keyframes here so they can be reused by other components later:

```scss
@keyframes flicker {
    0%, 97%, 100% { opacity: 1; }
    98%           { opacity: 0.6; }
    99%           { opacity: 1; }
}

@keyframes neon-flicker {
    0%, 19%, 21%, 23%, 25%, 54%, 56%, 100% { text-shadow: 0 0 20px $rgba-pink-0-glow-near, 0 0 40px $rgba-pink-0-glow-far; }
    20%, 24%, 55%                           { text-shadow: none; }
}
```

`_animations.scss` uses `@use "color-scheme" as *` for the pink glow values.

### 2. Add glow variables to `_color-scheme.scss`

Add two convenience variables for the pink glow levels used in `neon-flicker`:

```scss
$rgba-pink-0-glow-near: rgba(210, 0, 132, 0.53);   // ~88 alpha
$rgba-pink-0-glow-far:  rgba(210, 0, 132, 0.20);   // ~33 alpha
```

### 3. Update `styles/_header.scss`

- `@use "animations"` at the top.
- Apply to `header h1 a`:
  - `animation: flicker 8s infinite, neon-flicker 8s infinite;`
- Apply to `header h2`:
  - `animation: neon-flicker 8s infinite;` — opacity throb only, no neon-flicker or text-shadow toggling.

### 4. Add `@use "animations"` to `main.scss`

Keyframes must be emitted into the compiled CSS. Since `_animations.scss` only contains `@keyframes` (no output on its own unless `@use`d from a file that Sass compiles), add `@use "animations"` to `main.scss`.

---

## Files changed

| File | Change |
|---|---|
| `styles/_animations.scss` | New file — keyframe definitions |
| `styles/_color-scheme.scss` | Add `$rgba-pink-0-glow-near`, `$rgba-pink-0-glow-far` |
| `styles/_header.scss` | Add `@use "animations"`, apply animations to h1 a and h2 |
| `styles/main.scss` | Add `@use "animations"` |
