---
name: wordpress-client-tutorial
description: Create a client-facing Google Docs tutorial for editing an existing WordPress website from the admin panel. Use when the user asks for a WordPress client manual, tutorial, handoff guide, editable/non-editable site map, admin editing steps, wp-admin access instructions, or a Google Docs document that explains exactly where to log in, what username/password the client should use, and how to update pages, menus, images, forms, posts, products, plugins, or reusable site sections.
---

# WordPress Client Tutorial

## Goal

Create a clear, non-technical tutorial in Spanish for a client who needs to edit their WordPress website from the admin panel. Deliver it as a Google Docs document and keep a local Markdown copy.

## Required Inputs

Collect or infer these before writing the document:

- Production domain and exact admin URL, normally `https://domain.com/wp-admin/`.
- Client username and password to include in the tutorial, only when the user explicitly provides them.
- Site name, client/company name, and desired tutorial title.
- WordPress access level the client will have, such as Administrator, Editor, Shop Manager, or Author.
- Any sections the user wants emphasized or excluded.

If credentials are missing, do not invent them. Insert a visible placeholder such as `[USUARIO A CONFIRMAR]` and `[CONTRASENA A CONFIRMAR]`, and tell the user these fields need confirmation.

## Inspection Workflow

1. Inspect the WordPress project, theme, and available site structure before drafting. Prefer repo files when available:
   - `wp-content/themes/<theme>/`
   - templates and template parts
   - `functions.php`
   - custom post type, taxonomy, shortcode, block, ACF, WooCommerce, and menu registrations
   - CSS/JS only when it reveals component names or site areas
2. If live site access or screenshots are available, use them to confirm the visible page layout and admin labels. Do not rely on guesses when the site has custom fields, builders, or WooCommerce.
3. Map the site into client-friendly areas:
   - Header, navigation, hero, main pages, repeated blocks, footer, forms, blog/news, products/services, legal pages, SEO basics.
   - Mark each area as editable from the panel, partially editable, or not editable from the panel.
4. Identify the safest edit path for each editable area:
   - Pages: `Paginas > Todas las paginas > Editar`
   - Posts/news: `Entradas`
   - Menus: `Apariencia > Menus` or Site Editor navigation, depending on theme
   - Media: `Medios`
   - Forms: plugin-specific section, such as Contact Form 7, WPForms, Gravity Forms, Elementor Forms
   - WooCommerce: `Productos`, `Pedidos`, `Cupones`, `Ajustes`
   - ACF/custom fields: explain field labels as they appear to the client
   - Elementor/Divi/blocks: name the editor and describe only the needed actions
5. Separate "what the client can edit" from "what should be requested as a developer change." Be explicit when a change requires code, layout work, plugin configuration, or deployment.

## Document Requirements

Use `references/tutorial-template.md` as the content skeleton. Adapt headings to the actual site and remove sections that do not apply.

The Google Docs tutorial must include:

- Title with site/client name.
- Short intro in plain Spanish.
- Exact login URL, username, and password or clearly marked placeholders.
- A site map/table showing each visible section, where it is edited, and whether the client should edit it.
- Step-by-step instructions for the common edits the client will need.
- Notes about image sizes, links, buttons, SEO titles, forms, and backups when relevant.
- A final "Cuando pedir ayuda" section for code-only, layout, plugin, hosting, domain, email, or security changes.

Keep the tone practical and calm. Avoid developer jargon unless the client will see the same label in WordPress.

## Google Docs Delivery

Prefer the Google Drive/Docs connector or the `google-drive:google-docs` skill when available.

1. Draft the tutorial locally as Markdown first, with a filename like `tutorial-wordpress-<cliente>.md`.
2. Create a Google Docs document from the final content.
3. Verify the document title and enough content after creation.
4. Return the Google Docs link to the user and mention the local Markdown copy path.

If Google Docs creation is unavailable, finish the local Markdown copy and clearly state that Google Docs delivery could not be completed.

## Quality Checklist

Before final delivery, confirm:

- The domain/admin URL is exact and uses the production domain, not a local URL.
- Credentials are either user-provided or visible placeholders.
- The editable/non-editable table matches the inspected theme/site structure.
- Every instruction names the actual WordPress menu path the client will click.
- No unsupported claims are made about plugins, builders, products, or forms.
- The document is understandable for a non-technical client.
