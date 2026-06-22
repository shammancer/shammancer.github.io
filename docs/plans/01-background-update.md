---                                                                                                                                                                                            
Goal: Match the dark cyberpunk background from Deuterium.ca.html — deep near-black blue body, scanline overlay, and cyan grid overlay.                                                         
                                                                                                                                                                                                
---                                                                                                                                                                                            
1. Add new background color to _color-scheme.scss

Add $bg-deep: #07090f (the reference --bg value). The current $rgba-black-0 is a neutral charcoal #232323; the reference is a very dark blue-black that needs its own variable rather thanreplacing the existing palette.

2. Update body background in main.scss

Change background-color: $rgba-black-0 to background-color: $bg-deep.

3. Add scanline pseudo-element(body::before)

Fixed full-viewport overlay using repeating-linear-gradient that draws a 1px lime-green tinted line every 4px at 4% opacity. Must be pointer-events: none and z-index: 9999 so it sits above everything without blocking interaction.

4. Add grid pseudo-element (body::after)

Fixed full-viewport overlay using two perpendicular linear-gradients (cyan at 3% opacity) on a 40px × 40px background-size, creating a subtle grid. Must be pointer-events: none and z-index: 0.

5. Ensure #container renders above the grid

Add position: relative and z-index: 1 to #container in main.scss so page content sits above the z-index: 0 grid but below the z-index: 9999 scanline.

---
The only files touched are _color-scheme.scss and main.scss. No layout or structural changes needed.
