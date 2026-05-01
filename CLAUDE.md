# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal static site built with [Middleman](https://middlemanapp.com/) (v4.6), hosted on GitHub Pages. Content is primarily tabletop RPG worldbuilding material under `source/gate-walkers/`.

## Build and run

```bash
# Build all container phases in order
./manage-sgi.sh

# Build a single phase only
./manage-sgi.sh --build base    # OS + ruby toolchain (fedora:43)
./manage-sgi.sh --build gems    # bundle install from Gemfile
./manage-sgi.sh --build app     # middleman build + httpd packaging

# Run the site locally (builds app image and serves on port 8888)
./manage-sgi.sh --run
```

Container images are named `sgi-base`, `sgi-gems`, `sgi-app`. The app phase extracts the built site into `build/` on the host.

## Asset pipeline

SCSS is compiled via **Middleman's external pipeline**, not sprockets. The pipeline runs `sass` (from the `sass-embedded` gem) directly:

- SCSS source lives in `styles/` (project root) — **not** under `source/`
- Output lands in `.tmp/dist/styles/main.css`, which Middleman merges into the served tree
- `source/styles/normalize.css` is a static file copied as-is by Middleman

When adding a new font:
1. Add font files under `source/fonts/<FontName>/`
2. Create `styles/_font-name.scss` with `@use "font-mixin" as *;` and `@font-face` declarations using `gen-font-face`
3. Add `@use "font-name"` to `styles/main.scss`

## SCSS structure

| File | Purpose |
|---|---|
| `_color-scheme.scss` | All color variables (`$rgba-*`, `$hex-*`), imported with `as *` |
| `_font-mixin.scss` | Shared `gen-font-face` mixin used by all font partials |
| `_viewport.scss` | Responsive `#container` width at breakpoints (900px–2400px) |
| `_header.scss` | Header/nav font assignments (uses `orbitron`) |
| `_navigation.scss` | Nav layout (uses `share-tech-mono`) |
| `_fira.scss` | Fira Sans + Fira Mono `@font-face` declarations |
| `_orbitron.scss` | Orbitron weights 400–900 |
| `_rajdhani.scss` | Rajdhani weights 300–700 |
| `_roboto-mono.scss` | Roboto Mono weights 100–700, normal + italic |
| `_share-tech-mono.scss` | Share Tech Mono weight 400 |

## Page templates

Pages use double extensions: `.html.md` (Markdown) or `.html.erb` (ERB). All pages render through `source/layouts/layout.erb`. Partials are in `source/partial/`.

## ERB partials — known constraints

**No `local_assigns`** — Tilt ERB does not provide a `local_assigns` hash. Locals passed via `partial "...", locals: { key: val }` are injected as plain Ruby local variables. Use `defined?(var) ? var : default` to handle optional locals safely.

**No block partials with `<%= %>`** — `<%= partial "..." do %>` causes a `SyntaxError` because Tilt wraps `<%= expr %>` in parentheses, preventing the block's `end` from being reached. To pass HTML content into a partial, capture it first with `capture_html` and pass it as a local:

```erb
<% body = capture_html do %>
  <p>content</p>
<% end %>
<%= partial "partial/foo", locals: { content: body } %>
```

Plain strings (e.g. from a data file) can be passed directly as a local without `capture_html`.

## Card component

The card partial lives at `source/partial/_card.erb`. Supported locals:

| Local | Default | Notes |
|---|---|---|
| `colour` | `'grey'` | Applied as `card--<colour>` CSS class |
| `icon` | `nil` | Optional UTF-8 character |
| `title` | `nil` | Optional heading (Orbitron font) |
| `link` | `nil` | Makes the whole card an `<a>`; adds `ACCESS →` footer |
| `content` | `''` | Main body — plain string or `capture_html` result |

Supported colours: `grey` (default), `pink`, `green`, `blue`, `orange`. All map to `-0` palette variables in `_color-scheme.scss`. Glow variables follow the pattern `$rgba-<colour>-glow-near` / `$rgba-<colour>-glow-far` (0.53 / 0.20 opacity), defined as a grouped block at the end of `_color-scheme.scss`.

The card grid partial (`source/partial/_card_grid.erb`) accepts a `columns` local (default `3`) and sets `--card-grid-cols` as an inline CSS custom property consumed by `.card-grid` in `_card.scss`.

## TODO.md

`TODO.md` tracks outstanding work for the site. When completing a task:

- Mark it done with strikethrough: `* ~~Task description~~`
- Do not remove completed entries

When the user asks to update the todo, apply the strikethrough to any tasks completed in the current session.
You don't need to mention todo updates in the git commit messages if the whole commit was about the todo.

## Containerfile phases

| File | From | Produces |
|---|---|---|
| `Containerfile.base` | `fedora:43` | `sgi-base` — dnf packages + bundler |
| `Containerfile.gems` | `sgi-base` | `sgi-gems` — gems from Gemfile |
| `Containerfile.app` | `sgi-gems` → `httpd:2.4` | `sgi-app` — final site in Apache |
