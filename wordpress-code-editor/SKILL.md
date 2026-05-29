---
name: wordpress-code-editor
description: Edit WordPress sites only through versioned repository code. Use when Codex is asked to modify a WordPress theme, child theme, template, block, PHP behavior, CSS, JavaScript, WooCommerce view, header/footer, shortcode-like behavior, or frontend/admin-facing WordPress feature, while avoiding WP-CLI, new plugins, plugin installation, plugin configuration, production admin changes, database mutations, or any deployment step beyond git-based code delivery.
---

# WordPress Code Editor

## Core Rule

Implement every WordPress request as code that can be committed and deployed with `git push`.

Do not use or recommend:

- `wp` / WP-CLI commands.
- Installing, activating, updating, configuring, or relying on plugins.
- Manual WordPress admin changes as the required solution.
- Direct production database edits, option writes, migrations, imports, or one-off scripts.
- Production-only fixes that cannot be reproduced from the repository.

If a request appears to require one of those actions, pause before changing behavior and propose a code-only alternative. If there is no honest code-only path, say that clearly and explain the blocker.

## Workflow

1. Inspect the repository before editing.
   - Identify the active theme, child theme, custom templates, asset pipeline, and any existing local conventions.
   - Prefer `rg`, `rg --files`, `find`, `sed`, `php -l`, package scripts, and existing test/build commands.
   - Avoid assuming WordPress admin access, WP-CLI availability, or production shell access.

2. Choose the smallest code-owned surface.
   - Prefer theme or child-theme files already responsible for the requested behavior.
   - Use existing template parts, hooks, filters, enqueue patterns, block files, CSS structure, and JS conventions.
   - Do not add a new plugin or a new runtime dependency to solve a site edit.
   - Modify existing project-owned plugin code only when the repository already clearly owns that code and no installation/configuration step is required. Otherwise avoid plugin files.

3. Make the change deployable from git.
   - Commit-ready files must contain the complete behavior.
   - If a build step is required, run the existing build and include generated assets only when this repository already tracks them or production expects them.
   - Keep environment-specific values out of code unless the repo already has a safe configuration pattern.

4. Keep WordPress code safe and conventional.
   - Escape output with `esc_html`, `esc_attr`, `esc_url`, `wp_kses_post`, or the established local helper.
   - Sanitize input with WordPress sanitizers.
   - Use nonces and capability checks for form submissions or admin actions.
   - Preserve translation functions and text domains when present.
   - Use `get_template_part`, hooks, filters, and enqueue APIs according to existing project style.

5. Verify without WP-CLI.
   - Run targeted syntax checks such as `php -l` on edited PHP files.
   - Run existing `npm`, `composer`, lint, test, or build scripts when relevant.
   - If a full local WordPress runtime is unavailable, verify static correctness and report that runtime verification was not possible.

## Handling Common Requests

- Layout, text, styling, responsive behavior: edit theme templates, template parts, CSS/SCSS, or tracked block/view files.
- Header, footer, menus, product cards, archive pages, single pages: find the responsible template hierarchy or partial and update it directly.
- Forms or interactions: implement frontend JS/PHP in existing theme code with validation, sanitization, nonce checks, and clear success/error states.
- WooCommerce display changes: prefer template overrides already present in the theme or WooCommerce hooks/filters in theme code.
- Admin-side behavior: use code hooks only when the behavior ships from the repository and does not require admin toggles.
- Content changes: update versioned templates or seed-like code only if the content is intentionally hard-coded. Do not edit database content through scripts or WP-CLI.

## Response Discipline

When finishing a WordPress task using this skill, report:

- Which code-owned files changed.
- Whether any build or generated asset was updated.
- What validation ran.
- Any remaining manual deployment step, limited to git/deploy mechanics. Do not suggest installing plugins, running WP-CLI, or changing production admin settings.
