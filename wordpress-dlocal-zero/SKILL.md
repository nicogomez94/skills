---
name: wordpress-dlocal-zero
description: Convert a static HTML landing folder into a custom Spanish WordPress theme compatible with WooCommerce and dLocal, preserving the original design, moving assets into /assets, wiring CSS and JS with wp_enqueue_* functions, and keeping Cart and Checkout on the classic shortcode flow. Use when the user provides a source folder such as `maqueta` and wants a from-scratch WordPress site built from that prototype. If no source folder is provided, do not run anything and ask for it first.
---

# WordPress desde cero con dLocal

## Goal

Convert a static HTML prototype folder into a custom WordPress site with WooCommerce, keeping the design as close as possible to the source markup and leaving the checkout flow on the classic shortcode version for compatibility.

## Required Inputs

Before doing any work, confirm these values:

- Exact path to the source folder, normally `maqueta`.
- Exact WordPress root or Site Shell project path.
- Whether the dLocal plugin, gateway, or credentials were provided.
- Any additional source folder that must be treated as the canonical content source.

If no source folder is provided, stop immediately and ask for it. Do not inspect, edit, install, or run commands.

## Guardrails

- Do not run anything until the source folder is confirmed.
- Do not replace the existing WordPress install.
- Do not invent dLocal credentials, plugin slugs, or payment settings.
- Keep code comments, admin labels, page content, and checkout/cart text in Spanish.
- Use classic WooCommerce Cart and Checkout pages, not block-based ones.
- If the user does not provide the folder that the site must be based on, do not proceed.

## Workflow

1. Inspect the provided source folder and identify the HTML entry point, assets, and reusable sections.
2. Confirm the existing WordPress install and WooCommerce status.
3. Create a custom theme that mirrors the prototype visually.
4. Move or reference static assets through `/assets` and `get_template_directory_uri()`.
5. Enqueue CSS and JS with `wp_enqueue_style()` and `wp_enqueue_script()`.
6. Create the minimum theme files needed to match the design:
   - `style.css`
   - `functions.php`
   - `header.php`
   - `footer.php`
   - `front-page.php`
   - `page-contacto.php`
   - `page-nosotros.php`
   - `woocommerce.php` only if needed
7. Add WooCommerce template overrides when needed to preserve the prototype on shop, product list, cart, product detail, and checkout screens.
8. Install and activate WooCommerce with WP-CLI.
9. Set the Home page from `index.html` and configure the store page.
10. Create or update the Cart and Checkout pages with the classic shortcodes:
    - `[woocommerce_cart]`
    - `[woocommerce_checkout]`
11. Keep all public-facing copy in Spanish and remove leftover English labels from pages, menus, and WooCommerce screens.
12. If dLocal details are available, wire the payment plugin or settings after the theme is in place. If not, leave payment configuration pending and report what is missing.

## WordPress Rules

- The home page must reuse the visual design of `index.html`.
- The checkout and cart pages must keep the same design language as the prototype as much as WooCommerce allows.
- Product listing and product detail screens should match the prototype styling as closely as possible.
- Install WooCommerce if it is missing, then activate it.
- Configure the site language in Spanish when the site is intended for Spanish-speaking users.
- Make sure the site does not keep default English demo pages or labels.
- Use only explicit source folders provided by the user. If the folder is absent, pause and ask.

## Quality Checklist

Before finishing, verify:

- The theme is custom and not based on a page builder.
- The source HTML prototype was the actual basis for the theme.
- Assets load from the theme path correctly.
- Home, shop, cart, and checkout render in Spanish.
- Checkout uses the classic shortcode version, not blocks.
- WooCommerce is installed and active.
- No unwanted English pages remain.
