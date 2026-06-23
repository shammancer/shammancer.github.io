Use Middleman partial helper to render markdown fragments

Remove the custom `fragment` helper and the `markdown: true` card local.
Markdown fragments are now rendered via Middleman's built-in `partial()`
helper, which processes `.md` files through Kramdown natively. The card
partial always receives a pre-rendered HTML string as `content`.
