---
name: wordpress-vps-production-deploy
description: Deploy an existing WordPress project to production on a Linux VPS. Use when Codex must act as SRE/DevOps for WordPress on Ubuntu with nginx, PHP-FPM, MySQL or MariaDB, WP-CLI, WooCommerce, custom themes, production wp-config.php, safe permissions, aliases, smoke tests, and a repeatable deploy script, without Docker, Apache, panels, destructive git resets, or overwriting an existing WordPress install.
---

# WordPress VPS Production Deploy

## Workflow

Use this skill to execute a production WordPress deployment directly on the current VPS.

Before changing the server:
- Explain the next stage briefly, then run the commands.
- Inspect Ubuntu version, current directory, `APP_DIR`, Git state, existing WordPress files, existing `wp-config.php`, nginx sites, PHP-FPM version, database service, and listening ports.
- Treat `APP_DIR` as the source of truth. If it already contains `wp-admin`, `wp-includes`, and `index.php`, do not download WordPress core over it.
- Resolve placeholders conservatively:
  - `APP_DIR`: `/var/www/html/<slug>` unless provided.
  - `DOMAIN`: user-provided domain; if missing, use IP-only nginx and skip HTTPS.
  - `SERVER_IP`: detect if not provided.
  - `PHP_VERSION`: `8.2`.
  - `DB_NAME`, `DB_USER`: normalized slug.
  - `DB_PASS`, `WP_ADMIN_PASS`: generate strong values if not provided.
  - `WP_ADMIN_USER`: `admin`.
  - `WP_ADMIN_EMAIL`: `admin@<domain>` if domain exists.
  - `WP_THEME_NAME`: use the provided value; if absent and `ferreteria-theme` exists, use `ferreteria-theme`.
- Ask only if ambiguity could target the wrong app, domain, database, or theme.

Read [references/lemp-wordpress-vps.md](references/lemp-wordpress-vps.md) before executing. It contains the required command sequence, templates, idempotency checks, aliases, deploy script, smoke tests, and final report format.

## Execution Rules

- Run real commands; do not only explain.
- Use idempotent checks for packages, database, user, config files, nginx sites, WP-CLI install, plugin/theme activation, aliases, and deploy script.
- Do not use Docker, Apache, or hosting panels.
- Do not overwrite `wp-config.php` if it already exists; show a diff or proposed changes first.
- Do not delete databases, uploads, themes, plugins, or user code without explicit confirmation.
- Do not use `git reset --hard` without explicit confirmation.
- Avoid permissions `777`; keep Git usable while allowing WordPress to write `wp-content`.
- Do not print full database or admin passwords in the final report or logs.
- Optimize PHP-FPM and PHP limits for a 1 GB RAM VPS.
- Finish with HTTP, `/wp-json`, wp-admin, WooCommerce, and active theme checks.
