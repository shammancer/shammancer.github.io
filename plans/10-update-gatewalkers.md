# Gate Walkers Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert the Gate Walkers section from an HTML ordered-list index to a responsive card-grid layout matching the main site index, with existing prose content above the grid on every page.

**Architecture:** Extend `_card_grid.erb` with optional `header`/`footer` locals. Convert `gate-walkers/index.html.erb` to a card-based index. Create placeholder pages for the two top-level entries that lack pages (Logs, Gate Fudge). Convert each lower page from `.html.md` to `.html.erb`, placing existing prose above a card grid of sub-pages (or content-section cards where no sub-pages exist).

**Tech Stack:** Middleman 4.6, ERB partials, SCSS (sass-embedded external pipeline).

---

### Task 1: Extend `_card_grid.erb` with optional header and footer content

**Files:**
- Modify: `source/partial/_card_grid.erb`

- [ ] **Step 1: Replace `source/partial/_card_grid.erb`**

```erb
<%
  grid_content = defined?(content) ? content : ''
  grid_header  = defined?(header)  ? header  : nil
  grid_footer  = defined?(footer)  ? footer  : nil
%>
<% if grid_header %>
<div class="card-grid__header">
  <%= grid_header %>
</div>
<% end %>
<div class="card-grid">
  <%= grid_content %>
</div>
<% if grid_footer %>
<div class="card-grid__footer">
  <%= grid_footer %>
</div>
<% end %>
```

- [ ] **Step 2: Build to confirm no regressions**

```bash
./manage-sgi.sh --build app
```

Expected: exits 0. The main index (`/index.html`) still renders without errors.

---

### Task 2: Convert Gate Walkers index to card layout

**Files:**
- Modify: `source/gate-walkers/index.html.erb`

Replaces the entire `<ol>` structure. The intro paragraph moves into the grid `header` local. The self-referencing "Table of Contents" link is removed. One card per top-level section. Colour scheme: pink = narrative, blue = world/place, green = mechanics, grey = reference, orange = rules.

- [ ] **Step 1: Replace `source/gate-walkers/index.html.erb`**

```erb
---
title: Gate Walkers
---
<% intro = capture_html do %>
  <p>As a member of the Frontier Guild of the settlement Gransby, you have been tasked to explore the gate network and expand the frontier.</p>
<% end %>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: { colour: 'pink',   icon: '◎', title: 'Logs',         link: 'logs.html',         content: 'Campaign logs. The Exile and The Expansion.' } %>
  <%= partial "partial/card", locals: { colour: 'blue',   icon: '◈', title: 'Konungariket',  link: 'konungariket.html', content: 'The forgotten empire that spanned dimensions.' } %>
  <%= partial "partial/card", locals: { colour: 'green',  icon: '⬡', title: 'Gates',         link: 'gates.html',        content: 'Doorways between dimensions and the gate network.' } %>
  <%= partial "partial/card", locals: { colour: 'green',  icon: '◉', title: 'Mana',          link: 'mana.html',         content: 'The power that flows, pools, and drives the gates.' } %>
  <%= partial "partial/card", locals: { colour: 'blue',   icon: '⟐', title: 'Entities',      link: 'entities.html',     content: 'Bodied and spirit entities across the dimensions.' } %>
  <%= partial "partial/card", locals: { colour: 'grey',   icon: '◇', title: 'Influences',    link: 'influences.html',   content: 'Source material and inspirations for the setting.' } %>
  <%= partial "partial/card", locals: { colour: 'grey',   icon: '⊞', title: 'Terms',         link: 'terms.html',        content: 'Glossary of places, cultures, and units.' } %>
  <%= partial "partial/card", locals: { colour: 'orange', icon: '⊕', title: 'Gate Fudge',    link: 'fudge/index.html',  content: 'Rules: attributes, skills, and character creation.' } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 2: Build and extract**

```bash
./manage-sgi.sh --extract
```

Expected: exits 0.

- [ ] **Step 3: Verify**

```bash
grep -c 'class="card ' build/gate-walkers/index.html
```

Expected: `8`

```bash
grep 'card-grid__header' build/gate-walkers/index.html
```

Expected: one match.

```bash
grep 'Table of Contents' build/gate-walkers/index.html
```

Expected: no output.

---

### Task 3: Create Logs placeholder page

**Files:**
- Create: `source/gate-walkers/logs.html.erb`

- [ ] **Step 1: Create `source/gate-walkers/logs.html.erb`**

```erb
---
title: Gate Walkers - Logs
---
<% intro = capture_html do %>
  <p>Campaign logs documenting the history of the Konungan settlement in Gransby.</p>
<% end %>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: { colour: 'pink', icon: '◎', title: 'The Exile',     link: 'the-exile.html',     content: 'The flight from Grindarnastad and the founding of Gransby.' } %>
  <%= partial "partial/card", locals: { colour: 'pink', icon: '◎', title: 'The Expansion', link: 'the-expansion.html', content: 'Fifteen years on — the guilds grow and the Frontier Guild is reestablished.' } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 2: Build to confirm no errors**

```bash
./manage-sgi.sh --build app
```

Expected: exits 0.

---

### Task 4: Create Gate Fudge index page

**Files:**
- Create: `source/gate-walkers/fudge/index.html.erb`

- [ ] **Step 1: Create `source/gate-walkers/fudge/index.html.erb`**

```erb
---
title: Gate Fudge
---
<% intro = capture_html do %>
  <p>Rules for playing Gate Walkers using the Fudge system.</p>
<% end %>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: { colour: 'blue',  icon: '⊕', title: 'Attributes',        link: 'attributes.html',        content: 'Physical and mental attributes that define a character.' } %>
  <%= partial "partial/card", locals: { colour: 'blue',  icon: '⊕', title: 'Skills',             link: 'skills.html',            content: 'Athletic, combat, social, and artistic skill lists.' } %>
  <%= partial "partial/card", locals: { colour: 'green', icon: '⊕', title: 'Character Creation', link: 'character-creation.html', content: 'Objective character creation — attributes, skills, gifts, and faults.' } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 2: Build to confirm no errors**

```bash
./manage-sgi.sh --build app
```

Expected: exits 0.

---

### Task 5: Convert konungariket to card layout

**Files:**
- Delete: `source/gate-walkers/konungariket.html.md`
- Create: `source/gate-walkers/konungariket.html.erb`

Grindarnastad has no page yet — its card is non-linking (no `link` local).

- [ ] **Step 1: Create `source/gate-walkers/konungariket.html.erb`**

```erb
---
title: Gate Walkers - The Konungariket
---
<% intro = capture_html do %>
  <p>The Konungariket is a forgotten empire that spanned dimensions through the cosmos. Thousands of dimensions were under its influence. During the reign of the empire its population prospered, trade flourished, and the arts grew.</p>
  <p>However, as all great things must come to an end so did the Konungariket, and with it the links that held the people together across the dimensions collapsed as well.</p>
  <h2>Flag</h2>
  <p>The royal flag of the Konungariket is a rampant lion on a field of purple, with the outline of an archway representing the gates.</p>
<% end %>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: { colour: 'blue', icon: '◈', title: 'Gransby',      link: 'gransby.html',   content: 'The frontier settlement and last hold of the Konungan.' } %>
  <%= partial "partial/card", locals: { colour: 'blue', icon: '◈', title: 'Kaningard',     link: 'kaningard.html', content: 'The collapsed mine — a barren depression hiding a thriving forest.' } %>
  <%= partial "partial/card", locals: { colour: 'blue', icon: '◈', title: 'Carcov',         link: 'carcov.html',    content: 'Details to be added.' } %>
  <%= partial "partial/card", locals: { colour: 'grey', icon: '◈', title: 'Grindarnastad',  content: 'The City of Gates — the ancient capital of the Konungariket.' } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 2: Delete the old markdown file**

```bash
rm source/gate-walkers/konungariket.html.md
```

- [ ] **Step 3: Build and verify**

```bash
./manage-sgi.sh --extract
grep -c 'class="card ' build/gate-walkers/konungariket.html
```

Expected: `4`

---

### Task 6: Convert gates to card layout

**Files:**
- Delete: `source/gate-walkers/gates.html.md`
- Create: `source/gate-walkers/gates.html.erb`

- [ ] **Step 1: Create `source/gate-walkers/gates.html.erb`**

```erb
---
title: Gate Walkers - Gates
---
<% intro = capture_html do %>
  <p>Gates are doorways between places — connecting two dimensions together or two places within the same dimension. Being able to tap into the gate network allows travel to many places, though navigating it is difficult as the interconnections are mysterious and ever-changing.</p>
  <p>There are rudimentary gates not properly connected to the network that may be inefficient or unidirectional. Some gates are natural rifts that have been stabilized; others are artificial seams cut between dimensions.</p>
  <p>The gates made by the Konungariket are made of a dark unknown material with a matte finish that changes colour depending on the viewing angle. They sit on a raised platform of local stone beside a flag pole.</p>
<% end %>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: { colour: 'green', icon: '⬡', title: 'The Gate Minders', link: 'gate-guild.html', content: 'The consciousness that maintain and grow the gate network.' } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 2: Delete the old markdown file**

```bash
rm source/gate-walkers/gates.html.md
```

- [ ] **Step 3: Build and verify**

```bash
./manage-sgi.sh --build app
```

Expected: exits 0.

---

### Task 7: Convert entities to card layout

**Files:**
- Delete: `source/gate-walkers/entities.html.md`
- Create: `source/gate-walkers/entities.html.erb`

The two major sections (The Bodied, Spirits) each become a card. There are no separate pages for sub-types, so cards are non-linking.

- [ ] **Step 1: Create `source/gate-walkers/entities.html.erb`**

```erb
---
title: Gate Walkers - Entities
---
<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⟐', title: 'The Bodied',
    content: 'Entities tied to matter and anchored to dimensions. <strong>Sentinents</strong> — higher entities free to roam. <strong>Nymphs</strong> — higher entities bound to natural objects. <strong>Beasts</strong> — lower entities free to roam. <strong>Plants</strong> — rooted to a dimension, will wither if moved without special care.'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⟐', title: 'Spirits',
    content: 'Untied entities free to slip between dimensions. <strong>Gods</strong> — channel mana through prayer; power proportional to worship. <strong>Greater Spirits</strong> — capable of large works. <strong>Lower Spirits</strong> — incapable of large works and unable to survive long between dimensions.'
  } %>
<% end %>

<%= partial "partial/card_grid", locals: { content: cards_html } %>
```

- [ ] **Step 2: Delete the old markdown file**

```bash
rm source/gate-walkers/entities.html.md
```

- [ ] **Step 3: Build and verify**

```bash
./manage-sgi.sh --build app
```

Expected: exits 0.

---

### Task 8: Convert mana, influences, and terms to card layout

**Files:**
- Delete: `source/gate-walkers/mana.html.md`, `source/gate-walkers/influences.html.md`, `source/gate-walkers/terms.html.md`
- Create: `source/gate-walkers/mana.html.erb`, `source/gate-walkers/influences.html.erb`, `source/gate-walkers/terms.html.erb`

**mana** — prose only, no sub-pages. Content goes in the grid header; grid is empty (structural stub).  
**influences** — each source becomes its own card.  
**terms** — each category group (Places & Cultures, Units of Measure) becomes a card.

- [ ] **Step 1: Create `source/gate-walkers/mana.html.erb`**

```erb
---
title: Gate Walkers - Mana
---
<% intro = capture_html do %>
  <p>Mana is the power to affect the world. It can be used to create, control, transform, and destroy. As an entity uses mana it becomes attuned to the shape that the mana takes — making those forms easier to use in future.</p>
  <p>Mana flows, pools, and fountains within dimensions. It powers the gates and stabilizes rifts. Different types of matter have different mana capacity and conductivity. If too much mana is stored or transferred through matter it will burn and be destroyed.</p>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: '' } %>
```

- [ ] **Step 2: Create `source/gate-walkers/influences.html.erb`**

```erb
---
title: Gate Walkers - Influences
---
<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: { colour: 'grey', icon: '◇', title: 'The Long Earth Series', content: 'Terry Pratchett, Stephen Baxter' } %>
  <%= partial "partial/card", locals: { colour: 'grey', icon: '◇', title: 'Stargate',              content: 'Stargate SG-1, Stargate Universe, Stargate Atlantis' } %>
  <%= partial "partial/card", locals: { colour: 'grey', icon: '◇', title: 'The West Marches',      content: 'Ben, Ars Ludi' } %>
  <%= partial "partial/card", locals: { colour: 'grey', icon: '◇', title: 'Eli Monpress',          content: 'Rachel Aaron' } %>
<% end %>

<%= partial "partial/card_grid", locals: { content: cards_html } %>
```

- [ ] **Step 3: Create `source/gate-walkers/terms.html.erb`**

```erb
---
title: Gate Walkers - Terms
---
<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: {
    colour: 'grey', icon: '⊞', title: 'Places and Cultures',
    content: '<ul><li><strong>Konungariket</strong> — Kingdom</li><li><strong>Konungan</strong> — The people of the Kingdom</li><li><strong>Kaningard</strong> — Rabbit Warren</li><li><strong>Grindarnastad</strong> — City of Gates</li><li><strong>Gransby</strong> — The Frontier Village</li><li><strong>Dorroppning till Sakerhet</strong> — Doorway to Safety</li></ul>'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'grey', icon: '⊞', title: 'Units of Measure',
    content: '<ul><li><strong>Bowshot</strong> — Approximately 300m</li><li><strong>Race</strong> — Approximately 5km</li></ul>'
  } %>
<% end %>

<%= partial "partial/card_grid", locals: { content: cards_html } %>
```

- [ ] **Step 4: Delete old markdown files**

```bash
rm source/gate-walkers/mana.html.md
rm source/gate-walkers/influences.html.md
rm source/gate-walkers/terms.html.md
```

- [ ] **Step 5: Build and extract**

```bash
./manage-sgi.sh --extract
```

Expected: exits 0.

- [ ] **Step 6: Verify card counts**

```bash
grep -c 'class="card ' build/gate-walkers/influences.html
```

Expected: `4`

```bash
grep -c 'class="card ' build/gate-walkers/terms.html
```

Expected: `2`

---

### Task 9: Convert fudge rules pages to card layout

**Files:**
- Delete: `source/gate-walkers/fudge/attributes.html.md`, `source/gate-walkers/fudge/skills.html.md`, `source/gate-walkers/fudge/character-creation.html.md`
- Create: `source/gate-walkers/fudge/attributes.html.erb`, `source/gate-walkers/fudge/skills.html.erb`, `source/gate-walkers/fudge/character-creation.html.erb`

**attributes** — two sections (Body, Mind) each become a card.  
**skills** — each of the 8 skill groups becomes a card.  
**character-creation** — four sections (Character Sheet, Attributes, Skills, Gifts & Faults) each become a card.

- [ ] **Step 1: Create `source/gate-walkers/fudge/attributes.html.erb`**

```erb
---
title: Rules - Attributes
---
<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Attributes of the Body',
    content: '<ul><li><strong>Constitution</strong> — Physical health, control of your body</li><li><strong>Strength</strong> — Capacity to lift, push, jump</li><li><strong>Dexterity</strong> — Touch your toes, do the splits</li><li><strong>Reflexes</strong> — How fast you respond to stimuli</li><li><strong>Presence</strong> — Your physical presence</li><li><strong>Capacity</strong> — How much mana you can hold</li></ul>'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Attributes of the Mind',
    content: '<ul><li><strong>Will</strong> — Mental health, control of your mind</li><li><strong>Memory</strong> — How much you can remember</li><li><strong>Analytic</strong> — Computational power</li><li><strong>Wisdom</strong> — Deductive and inductive reasoning</li><li><strong>Empathy</strong> — Ability to understand and use emotions</li><li><strong>Affinity</strong> — How easy it is to wield mana</li></ul>'
  } %>
<% end %>

<%= partial "partial/card_grid", locals: { content: cards_html } %>
```

- [ ] **Step 2: Create `source/gate-walkers/fudge/skills.html.erb`**

```erb
---
title: Rules - Skills
---
<% intro = capture_html do %>
  <p>Based on Fantasy Fudge skills with modifications. Governing attribute shown in parentheses.</p>
<% end %>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Athletic',
    content: 'Jumping, Riding, Running, Throwing, Swimming, Lifting, Pushing — all governed by Strength.'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Finesse',
    content: 'Acrobatics (Dex), Pick Pocketing (Ref), Climbing (Dex), Balance (Ref), Stealth (Pres), Sleight of Hands (Dex).'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Combat',
    content: 'Read Opponent (Wis), Tactics (Ana), Dodging (Dex), Striking (Str), Blocking (Ref), Aiming (Ana).'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Weapon',
    content: 'Short Blades (Ref), Long Blades (Str), Poles (Ref), Bows (Ref), Blunt &amp; Hacking (Str).'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'green', icon: '⊕', title: 'Natural Sciences',
    content: 'Mathematics, Science, Engineering, Baking/Cooking (Ana) · Health, Botany, Cartography (Mem) · Lockpicking, Orienteering (Wis).'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'green', icon: '⊕', title: 'Social Sciences',
    content: 'Linguistic, Philosophy, Law, Tracking (Wis) · History, Lore (Mem) · Theology, Politics (Emp).'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'orange', icon: '⊕', title: 'Artistic',
    content: 'Poetry, Painting/Drawing, Sculpting, Music (Emp) · Handwriting (Dex) · Acting, Makeup, Dancing, Storytelling (Pres).'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'orange', icon: '⊕', title: 'Social',
    content: 'Bluff, Diplomacy, Haggle, Persuasion (Emp) · Lie (Ana) · Etiquette (Mem) · Intimidation, Seduction (Pres).'
  } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 3: Create `source/gate-walkers/fudge/character-creation.html.erb`**

```erb
---
title: Fudge - Character Creation
---
<% intro = capture_html do %>
  <p>Using Objective Character Creation.</p>
<% end %>

<% cards_html = capture_html do %>
  <%= partial "partial/card", locals: {
    colour: 'green', icon: '⊕', title: 'Character Sheet',
    content: '<ul><li>Name</li><li>Attributes &amp; Skills</li><li>Physical Characteristics — sex, height, weight, skin colour, eye colour, blemishes</li><li>Profession</li><li>Social Relationships — 1 PC, 3 NPCs (name, relationship, relevant details)</li></ul>'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Attributes',
    content: '<ul><li>+2 in Physical Attributes (except Capacity)</li><li>+2 in Mental Attributes (except Affinity)</li><li>+1 to any attribute</li><li>May take two −1s in anything to gain additional +1s</li></ul>'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'blue', icon: '⊕', title: 'Skills',
    content: '<ul><li>Everything starts at Poor</li><li>Choose two skill groups to raise to Fair</li><li>15 skill increases, max Great in any skill</li></ul>'
  } %>
  <%= partial "partial/card", locals: {
    colour: 'grey', icon: '⊕', title: 'Gifts and Faults',
    content: 'Case by case basis.'
  } %>
<% end %>

<%= partial "partial/card_grid", locals: { header: intro, content: cards_html } %>
```

- [ ] **Step 4: Delete old markdown files**

```bash
rm source/gate-walkers/fudge/attributes.html.md
rm source/gate-walkers/fudge/skills.html.md
rm source/gate-walkers/fudge/character-creation.html.md
```

- [ ] **Step 5: Build and extract**

```bash
./manage-sgi.sh --extract
```

Expected: exits 0.

- [ ] **Step 6: Verify**

```bash
grep -c 'class="card ' build/gate-walkers/fudge/skills.html
```

Expected: `8`

```bash
grep -c 'class="card ' build/gate-walkers/fudge/attributes.html
```

Expected: `2`

```bash
grep -c 'class="card ' build/gate-walkers/fudge/character-creation.html
```

Expected: `4`
