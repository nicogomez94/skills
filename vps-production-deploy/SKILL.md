---
name: vps-production-deploy
description: Deploy a Node.js monorepo to production on a Linux VPS. Use when Codex must act as SRE/DevOps on the current VPS for npm workspaces with React/Vite client, Express server, Prisma, PostgreSQL, nginx, systemd, certbot HTTPS, production env files, repeatable deploy scripts, gitignore hardening, shell aliases, and real command execution without Docker.
---

# VPS Production Deploy

## Workflow

Use this skill to execute a production deployment directly on the current VPS, not to provide a high-level explanation.

Before making changes:
- Inspect the repo with `pwd`, `git status`, `package.json`, workspace package files, Prisma schema, `.env.example` files, existing nginx/systemd config, and current listening ports.
- Identify the app slug from the repo folder unless the user provides one.
- Resolve placeholders such as `CAMBIAR` conservatively:
  - `APP_DIR`: current repo path if already under `/var/www`, otherwise `/var/www/html/<slug>`.
  - `DOMAIN`: user-provided domain; if unavailable, use server IP for non-HTTPS checks and skip certbot.
  - `SERVER_IP`: detect with `hostname -I` or a public IP lookup.
  - `DB_NAME` and `DB_USER`: normalized slug with underscores.
  - `DB_PASS`: generate a strong value if not provided.
  - `API_PORT`: `3001`.
  - `NODE_VERSION`: `22`.
- Continue with reasonable defaults when ambiguity is low. Ask only when proceeding could target the wrong project, domain, or database.

Read [references/node-vite-prisma-vps.md](references/node-vite-prisma-vps.md) before executing the deployment. It contains the required command sequence, config templates, deploy script shape, aliases, smoke tests, and idempotency rules.

## Execution Rules

- Run real commands on the VPS when the user asks to deploy or prepare production.
- Use idempotent checks before creating databases, users, nginx sites, services, directories, aliases, and env files.
- Do not use Docker.
- Do not revert user changes in the repo.
- Use `sudo` where system paths require it.
- Keep secrets out of git. Ensure `.env`, uploads, build output, logs, and local deployment artifacts are ignored.
- Use `npm ci` when a lockfile exists; otherwise use `npm install`.
- For Prisma, run `npm run db:generate --workspace server` and `npx prisma migrate deploy` from the server workspace, adapting only if the repo exposes an equivalent script.
- Enable HTTPS with certbot only when the domain resolves to this VPS.
- Finish with local and domain smoke tests and report exact service names, paths, aliases, and any skipped steps.
