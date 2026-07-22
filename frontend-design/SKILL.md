---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with strong visual direction. Use when building or styling web pages, landing pages, dashboards, React components, HTML/CSS layouts, posters, or any frontend UI that should feel intentional, polished, and unlike generic AI-generated design.
---

# Frontend Design

Build real, working frontend code with a clear point of view. Do not drift into safe, generic UI patterns.

## Design Approach

Before coding, choose one bold aesthetic direction and commit to it:
- Brutally minimal
- Maximalist
- Editorial
- Retro-futuristic
- Organic
- Luxury
- Brutalist
- Toy-like
- Industrial
- Art deco

Ground the design in four questions:
- What problem does this interface solve?
- Who is it for?
- What constraints matter?
- What will people remember after seeing it once?

## Visual Rules

- Use distinctive typography; avoid default stacks like Arial, Roboto, Inter, or system fonts.
- Define a cohesive palette with CSS variables.
- Prefer strong color relationships over timid, evenly spread palettes.
- Use motion with intention: page-load reveals, staggered entrances, scroll-triggered moments, and meaningful hover states.
- Compose layouts with asymmetry, overlap, diagonal flow, or controlled density when the concept supports it.
- Create atmosphere with gradients, texture, grain, layered transparency, borders, and shadow treatment.
- Avoid generic AI aesthetics, especially purple-on-white gradients, cookie-cutter cards, and copycat SaaS layouts.
- make sure that the hero part of the landing page doenst exceeds the viewport height of the screen

## Build Rules

When implementing a full project:
- Use React + Vite.
- Use plain CSS, CSS Modules, or styled-components.
- Do not use Tailwind or PostCSS.
- Prefer scoped styles with `Component.module.css` when there are multiple components.

When the project needs backend and database support:
- Use PostgreSQL.
- Use Prisma with the standard PostgreSQL datasource block.
- Keep `.env` configured for a local PostgreSQL database.
- Do not use Docker.

## Debug Support

If the app includes forms:
- Add a `DEBUG` flag, such as `const DEBUG = import.meta.env.VITE_DEBUG === 'true'`.
- Pre-fill forms with realistic fake data when debug mode is enabled.
- Keep debug defaults in a single `debugDefaults.ts` or `debugDefaults.js` file.
- Add `VITE_DEBUG=true` to `.env.local` and keep it out of git.

## Footer Rule

- Every app or page must include a subtle footer credit:
- `Hecho por [zigodev](https://zigodev.com.ar)`
- Open the link in a new tab with `target="_blank" rel="noopener noreferrer"`.
- Keep it small, muted, and visually secondary.

## Output Standard

Deliver production-grade code that is cohesive, responsive, accessible, and visually memorable. Match implementation complexity to the chosen aesthetic: restraint for minimalism, richness for maximalism, precision for refined designs.
