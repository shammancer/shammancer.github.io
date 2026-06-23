# About Page: Card Grid Layout

**Date:** 2026-05-05

## Goal

Convert the about page from a flat Markdown document to a card grid layout, with each card's content stored in its own Markdown file.

## File Structure

Replace `source/about.html.md` with `source/about.html.erb`. Add a `source/about/` folder containing four Markdown partials (leading underscore prevents Middleman from building them as standalone pages):

```
source/about.html.erb
source/about/_education.html.md
source/about/_work-experience.html.md
source/about/_skills.html.md
source/about/_personal-interests.html.md
```

## Page Architecture

`about.html.erb` renders a `card_grid` partial with:
- **header** — introduction paragraph (captured with `capture_html`)
- **content** — four cards (captured with `capture_html`)
- **footer** — call-to-action (captured with `capture_html`)

Each card's content is rendered from its markdown partial using `capture_html { partial "about/<name>" }` and passed as `content` to the card partial.

## Introduction Text

> Franco-Albertan information security practitioner with a Bachelor of Science in Computer Engineering from the University of Alberta. Interests span low-level programming, computer architecture, security, and networking.

## Cards

| Card | Colour | Icon | Source file |
|---|---|---|---|
| Education | green | `◎` | `_education.html.md` |
| Work Experience | pink | `◈` | `_work-experience.html.md` |
| Skills | green | `⬡` | `_skills.html.md` |
| Personal Interests | pink | `◇` | `_personal-interests.html.md` |

All cards are content-only (no `link`). No `wide_title` modifier — can be revisited after visual testing.

## Card Content

### Education (`_education.html.md`)

Bachelor of Science in Computer Engineering, University of Alberta. First year completed at Campus St-Jean.

### Work Experience (`_work-experience.html.md`)

Existing content from `about.html.md`:
- Documented requirements for a data visualization product and developed a road map for its implementation
- Developed the data visualization product using a Spring Boot-based API to facilitate the use of modern design patterns
- Created a real-time dashboard to track the daily production and uptime of a manufacturing facility
- Collaborated with stakeholders in a quality review process to refine the user interface of multiple projects

### Skills (`_skills.html.md`)

Simple list (updated from existing content):
- Java, Python, C, Rust
- Strong experience with Archlinux, Fedora, and Red Hat and Derivatives
- Comfortable with Windows

### Personal Interests (`_personal-interests.html.md`)

Existing content from `about.html.md`:
- First degree black belt in ICTF Taekwon-do
- Grade 8 Royal Conservatory of Music in Piano
- Science fiction and fantasy novels
- Board games and video games

## Footer Text

> If you have any questions about my experience feel free to [contact me](/contact.html).

## Verification

Run `./manage-sgi.sh --extract` and open `build/about.html` in a browser. Verify:
- All five cards render with correct colours and icons
- Introduction and footer text appear correctly
- Card content renders as expected from each markdown file
- Grid layout responds correctly at narrow and wide viewports
