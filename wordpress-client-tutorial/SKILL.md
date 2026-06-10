---
name: wordpress-client-tutorial
description: Create a short, simple, client-facing Spanish tutorial for editing an existing WordPress website from the admin panel. Use when the user asks for a website editing manual, client handoff guide, admin access instructions, or a Google Docs tutorial explaining only the essential steps to log in and make common content changes without technical jargon.
---

# WordPress Client Tutorial

## Goal

Create a very simple Spanish tutorial for a non-technical client who only needs to know how to enter the admin panel and make common changes.

Default style:

- Short, warm, and practical.
- Easy to scan.
- No long explanations.
- No technical terms such as "WordPress", "WooCommerce", "theme", "plugin", "template", "custom post type", "shortcode", "ACF", or "deployment" unless the client must click a menu with that exact name.
- Say "panel", "sitio", "tienda", "productos", "paginas", "imagenes", "pedidos", or the exact menu label the client will see.
- Include only what the client is expected to change.
- Prefer steps with 3-6 actions. Avoid exhaustive documentation.
- Deliver as a Google Docs document and keep a local Markdown copy.

## Required Inputs

Collect or infer these before writing the document:

- Production domain and exact admin URL, normally `https://domain.com/wp-admin/`.
- Client username and password to include in the tutorial, only when the user explicitly provides them.
- Site name or client/company name.
- Any sections the user wants emphasized or excluded.

If credentials are missing, do not invent them. Insert a visible placeholder such as `[USUARIO A CONFIRMAR]` and `[CONTRASENA A CONFIRMAR]`, and tell the user these fields need confirmation.

## Inspection Workflow

Inspect enough of the project to avoid wrong instructions, but keep the final tutorial short.

1. Inspect the project, theme, and visible site structure before drafting. Prefer repo files when available:
   - `wp-content/themes/<theme>/`
   - templates and template parts
   - `functions.php`
   - admin menu labels, custom content labels, product/order areas, and form labels
2. If live site access or screenshots are available, use them to confirm what the client sees.
3. Identify only the common edit paths the client likely needs, such as:
   - `Paginas`
   - `Medios`
   - `Productos`
   - `Pedidos`
   - `Ajustes > Datos de contacto`
   - form section names only if present
4. Mention fixed or delicate areas only in a brief final help section. Do not build a long editable/non-editable map unless the user explicitly asks for it.

## Document Requirements

Use `references/tutorial-template.md` as the content skeleton. Adapt it to the actual site and remove anything that does not apply.

The Google Docs tutorial must include:

- Title with site/client name.
- Exact login URL, username, and password or clearly marked placeholders.
- A short "Antes de editar" note.
- 3-6 sections for common changes only.
- A final "Cuando pedir ayuda" section with a short list.

Avoid tables by default. Use a small table only if it makes the tutorial clearly easier to read.

Keep the tutorial compact. A good default length is 1-3 pages in Google Docs.

Do not include:

- Long site maps.
- Plugin or builder explanations.
- Technical labels unless they are exact visible menu labels.
- Developer-facing observations from code inspection.
- Long lists of things the client should not touch.
- SEO, backups, security, hosting, or domain explanations unless directly requested.

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
- Every instruction names the actual menu path the client will click.
- The tutorial only includes actions the client is expected to perform.
- Technical language has been removed unless unavoidable.
- The final document is short, legible, and useful for making a change quickly.
