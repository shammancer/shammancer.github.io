# Plan 04 — Header Typewriter Effect on H2

Animate the page title in `<h2>` so it types itself out character by character on page load, with a blinking cursor, matching the `Typewriter` component behaviour in `Deuterium.ca.html`.

---

## Reference behaviour

From `Deuterium.ca.html`:

- Characters are revealed one at a time on a fixed interval (60ms default).
- A blinking block cursor `█` follows the last revealed character, animated with a 1s `blink` keyframe.
- The cursor disappears once typing is complete (interval clears itself).
- A `//` prefix is rendered before the text in the reference — omit this for the h2 since it already has heading semantics and styling.

---

## Steps

### 1. Add keyframe to `styles/_animations.scss`

```scss
@keyframes blink {
    0%, 100% { opacity: 1; }
    50%       { opacity: 0; }
}
```

### 2. Add cursor style to `styles/_header.scss`

Add a style for the cursor span that will be injected by JS:

```scss
h2 .typewriter-cursor {
    animation: blink 1s infinite;
}
```

### 3. Implement typewriter in `source/scripts/main.js`

On `DOMContentLoaded`, find the h2, extract its text content, clear it, then reveal characters at 60ms intervals. Inject a cursor `<span class="typewriter-cursor">█</span>` after the revealed text. Remove the cursor once typing is complete.

```js
document.addEventListener('DOMContentLoaded', () => {
    const h2 = document.querySelector('header h2');
    if (!h2 || !h2.textContent.trim()) return;

    const text = h2.textContent;
    const cursor = document.createElement('span');
    cursor.className = 'typewriter-cursor';
    cursor.textContent = '█';

    h2.textContent = '';
    h2.appendChild(cursor);

    let i = 0;
    const interval = setInterval(() => {
        h2.insertBefore(document.createTextNode(text[i]), cursor);
        i++;
        if (i >= text.length) {
            clearInterval(interval);
            cursor.remove();
        }
    }, 60);
});
```

The h2 is hidden from view until JS runs by setting `visibility: hidden` in CSS and toggling it on once JS starts — avoiding a flash of the raw text before the animation begins.

### 4. Handle the no-title case

Pages without a `title` in frontmatter render an empty h2. The JS guard (`if (!h2.textContent.trim()) return`) covers this — no animation runs and the empty h2 stays hidden. Add `visibility: hidden` only when content is present via the JS, not in CSS, to keep the no-title case clean.

---

## Files changed

| File | Change |
|---|---|
| `styles/_animations.scss` | Add `blink` keyframe |
| `styles/_header.scss` | Add `.typewriter-cursor` style |
| `source/scripts/main.js` | Implement typewriter logic on DOMContentLoaded |
