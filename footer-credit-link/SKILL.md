---
name: footer-credit-link
description: Add or standardize a visible, understated footer credit link to ZigoDev. Use when the user asks to put "Hecho por", "Desarrollado por", "Made by", or similar developer/agency attribution in a website footer, especially linking to https://zigodev.com.ar while matching the site's existing visual style.
---

# Footer Credit Link

## Goal

Add a subtle but visible footer credit that links to `https://zigodev.com.ar` and reads `Hecho por ZigoDev` unless the user requests different wording.

## Workflow

1. Inspect the footer template/component and nearby styles before editing.
2. Place the credit in the existing footer bottom/legal area when one exists. If not, add it near copyright or secondary footer links.
3. Use a normal link element with:
   - `href="https://zigodev.com.ar"`
   - `target="_blank"`
   - `rel="noopener"`
   - visible text: `Hecho por ZigoDev`
4. Match the site's current design language: typography, color, spacing, hover treatment, and responsive behavior.
5. Keep it understated, not flashy: no badges, large logos, animations, gradients, or oversized buttons unless the footer already uses that pattern.
6. Ensure it remains visible against the footer background and works on mobile.
7. Validate with the project's normal checks when available, or at least run `git diff --check`.

## Implementation Notes

- In WordPress themes, prefer editing the theme's `footer.php` and existing CSS. Do not use WP admin, WP-CLI, plugins, or database edits for this change.
- If the footer already has a phrase like `Hecho con amor`, replace or extend it only when that is clearly the best visual fit.
- If there is an existing copyright row with two sides, put copyright on one side and the ZigoDev credit on the other.
- If there are multiple footer variants, update the variant used by the current page and note any untouched variants.
- Preserve escaping conventions in templates, such as `esc_url()` and translation helpers if the project uses them.

## Styling Pattern

Prefer a compact text link:

```html
<a href="https://zigodev.com.ar" target="_blank" rel="noopener">Hecho por ZigoDev</a>
```

For dark footers, use a muted base color with a brighter hover color already present in the site palette. For light footers, use the standard body/link color and the established accent on hover.
