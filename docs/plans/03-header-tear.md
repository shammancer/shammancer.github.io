# Plan 03 — Header Tear (Glitch) Animation

Add a clip-path tear/glitch effect to the h1 header, matching the reference in `Deuterium.ca.html`.

---

## Reference behaviour

The effect requires **two stacked copies** of the element:

- **Primary** (`glitch`) — fires at 90–97% of its cycle. Uses `clip-path: inset()` to expose a horizontal slice of the element and `transform: translate()` to shift it sideways. Briefly shifts colour to cyan at 95%.
- **Ghost** (`glitch2`) — a duplicate `aria-hidden` element positioned absolutely on top. Stays `opacity: 0` except during its window (92–97%), where it shows a different slice at a larger offset, then fades out. Creates the double-image tear look.

---

## Steps

### 1. Add keyframes to `styles/_animations.scss`

```scss
@keyframes glitch-pink {
    0%, 90%, 100% { clip-path: none; transform: none; }
    91%           { clip-path: inset(20% 0 50% 0); transform: translate(-4px,  2px); }
    93%           { clip-path: inset(60% 0 10% 0); transform: translate( 4px, -2px); }
    95%           { clip-path: inset(40% 0 30% 0); transform: translate(-2px,  1px); color: $rgba-pink-2; }
    97%           { clip-path: none;                transform: translate( 2px,  0);  }
}

@keyframes glitch-ghost {
    0%, 92%, 100% { opacity: 0; }
    93%           { opacity: 1; clip-path: inset(30% 0 40% 0); transform: translate( 6px, -3px); }
    95%           { clip-path: inset(70% 0  5% 0); transform: translate(-6px,  3px); }
    97%           { opacity: 0; }
}
```

Use `$rgba-green-2` for the green colour flash — it is already in the palette.

### 2. Update `source/partial/_header.erb`

Wrap the h1 contents in a `position: relative` container and add an `aria-hidden` ghost span. The ghost must be absolutely positioned over the primary text.

```erb
<header>
    <h1>
        <span class="glitch-wrap">
            <%= link_to 'Deuterium.ca', '/index.html' %>
            <span class="glitch-ghost" aria-hidden="true">Deuterium.ca</span>
        </span>
    </h1>
    <h2><%= current_page.data.title %></h2>
</header>
```

The ghost is a plain `<span>` (not a link) since it is purely decorative.

### 3. Update `styles/_header.scss`

Add styles for the two new elements and apply the animations:

```scss
h1 .glitch-wrap {
    position: relative;
    display: inline-block;
}

h1 a {
    // existing styles …
    animation: flicker 8s infinite, pink-neon-flicker 8s infinite, glitch 6s infinite;
}

h1 .glitch-ghost {
    position: absolute;
    top: 0;
    left: 0;
    color: $rgba-pink-0;
    pointer-events: none;
    animation: glitch-ghost 6s infinite;
}
```

---

## Files changed

| File | Change |
|---|---|
| `styles/_animations.scss` | Add `glitch` and `glitch-ghost` keyframes |
| `source/partial/_header.erb` | Wrap h1 link in `.glitch-wrap`, add `.glitch-ghost` span |
| `styles/_header.scss` | Style `.glitch-wrap` and `.glitch-ghost`, add `glitch` to h1 a animation |
