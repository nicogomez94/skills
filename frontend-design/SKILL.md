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
- Do not spend time inventing a logo when none is provided.
- If the user does not provide a logo, use a simple text placeholder such as the brand name or initials and clearly note that the logo is missing.
- Do not use `imagegen` or any other image generation workflow to fabricate a logo.
- Make sure the hero never exceeds the visible viewport height on first load.
- Keep the hero title, copy, CTAs, and any supporting visual fully contained within the initial viewport on common desktop sizes.
- If the hero includes a marquee, ticker, announcement strip, or other horizontal scrolling band, treat it as part of the hero's height budget: it must be visible in the initial viewport together with the rest of the hero, without requiring any vertical scroll. Account for the header, marquee, content, buttons, supporting visual, and mobile browser UI when sizing the hero.
- If the hero needs to be taller for visual reasons, reduce type scale, tighten spacing, or move supporting content below the fold instead of letting it overflow.
- Do not use `clamp()` for font sizes on hero text or headings.
- Set `h1` and hero typography with explicit sizes per breakpoint instead of fluid `clamp()` scaling.

### Marquee and ticker behavior

- When a marquee is requested, make it a genuinely continuous loop with text always present. Render at least two identical consecutive copies of the content (or an equivalent seamless repeating track) and animate by exactly one copy's width so the reset is imperceptible.
- Never let the track travel into an empty state, end with a blank gap, or expose an empty side of the container. The repeated content must be long enough to cover the viewport at every breakpoint, including wide desktop and narrow mobile screens.
- Do not apply side fades, opacity masks, gradient masks, clipping that reveals blank space, or one-shot translations that make the text disappear at either edge. `overflow: hidden` is allowed only on the marquee viewport to contain the loop; it must not create page-level horizontal scrolling.
- Keep the marquee visible in the hero on first load. Do not position it below the fold, hide it until an animation starts, or let it be pushed down by oversized hero content. If the content does not fit, compact the hero or move secondary content below the fold.
- Respect `prefers-reduced-motion`: keep the repeated text visible and readable, using a static full-width arrangement or a paused track instead of hiding the marquee.

## Build Rules

When implementing a full project:
- Use React + Vite.
- Use plain CSS, CSS Modules, or styled-components.
- Do not use Tailwind or PostCSS.
- Prefer scoped styles with `Component.module.css` when there are multiple components.
- Keep hero typography on fixed breakpoint-driven sizes, not `clamp()`.
- Avoid oversized H1s that push hero content below the fold on standard laptop viewport heights.
- When a hero has a marquee, verify the complete first-screen composition at representative desktop and mobile viewport heights. The marquee must be inside the visible hero on initial load, and its loop must continuously show text with no blank interval or disappearing tail.

### Render deployment

- For every completed web page or simple website, use Render Free as the default hosting target unless the user explicitly requests another provider.
- Deploy the finished site directly with Render CLI and wait for the deployment to complete before finishing the task. For a static Vite build, use the appropriate build command and publish directory (normally `dist`); for a vanilla static page, publish the project root or its static output directory.
- If the Render service already exists, trigger a new deployment and wait for it to finish instead of creating a duplicate service.
- Do not create, copy, suggest, or leave behind a `render.yaml` file for this workflow. Configure the service directly through Render CLI.
- Return the live Render URL in the final response so the user can open the page immediately.
- If deployment cannot be completed because the project has no Git remote, Render CLI is unavailable, or authentication is missing, report the exact blocker and do not fabricate a URL. Do not fall back to generating `render.yaml`.

### Commit and handoff

- On every skill invocation that changes project files, finish by checking `git status` and reviewing the diff, then commit the changes made for that invocation with a concise, descriptive message.
- Stage only files belonging to the current request. Preserve unrelated user changes; never use reset, checkout, or broad staging to force a clean tree.
- Verify that the commit exists and the working tree is ready to push. Do not run `git push` unless the user explicitly requests it.
- If there are no changes, do not create an empty commit. If the project is not a Git repository or the commit cannot be created, report the exact blocker.

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
