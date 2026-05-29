---
name: render-split-deploy
description: "Create or fix Render deployments for full-stack Node/Vite/React/Express apps, especially repos split into frontend and backend folders, using one Render Web Service that builds the frontend, runs Prisma migrations during build, and starts the backend. Use when the user asks for Render migration, Render blueprint YAML, Prisma deploy commands, monorepo frontend/backend deployment, or avoiding separate Static Site plus Web Service deployments."
---

# Render Single Web Service Deploy

## Core Rule

For Render migrations, default to one Render Web Service for the whole app.

Use a single service even when the repo has separate `frontend/` and `backend/` folders. Make the backend serve the built frontend in production, and make the root project expose one build path and one start path.

Only create a separate Render Static Site plus backend Web Service when the user explicitly asks for split deployment.

## Required Render Pattern

Use this `buildCommand` unless the repo is not Node/Prisma:

```yaml
buildCommand: npm ci --include=dev && npx prisma migrate deploy && npm run build
```

Use this start command by default:

```yaml
startCommand: npm start
```

Keep Prisma migrations in the build command for production deploys. Do not rely on seed commands or manual Prisma commands for production schema changes.

## Workflow

1. Inspect the repository with `rg --files`, `ls`, and package/config files.
2. Determine whether the app is already root-level full stack or split into frontend/backend folders.
3. Ensure the repository root has the Render entrypoint:
   - `package.json`
   - lockfile compatible with `npm ci`
   - `build` script
   - `start` script
   - Prisma CLI in dev dependencies when Prisma is used
4. If Prisma schema is not at `prisma/schema.prisma`, configure root `package.json` with:

```json
{
  "prisma": {
    "schema": "backend/prisma/schema.prisma"
  }
}
```

5. If the frontend is Vite/React, make `npm run build` build the frontend and place assets where the backend can serve them.
6. If the backend is Express, make it serve the frontend build in production:
   - API routes must remain under `/api`.
   - Static assets should be served after API routes.
   - SPA fallback should return `index.html`.
7. Keep frontend API calls same-origin when possible:
   - Prefer `/api/...` in production.
   - Avoid requiring `VITE_API_URL` for the deployed app when using one service.
8. Add or fix `render.yaml`.
9. Validate:
   - Parse `render.yaml` with a YAML parser if available.
   - Run `npm run build`.
   - Run `DATABASE_URL='postgresql://user:pass@localhost:5432/app' npx prisma validate` when Prisma requires `DATABASE_URL` just to validate.

## Blueprint Pattern

Use this shape and adapt names/env vars to the repo:

```yaml
services:
  - type: web
    name: <app-name>
    runtime: node
    plan: free
    buildCommand: npm ci --include=dev && npx prisma migrate deploy && npm run build
    startCommand: npm start
    healthCheckPath: /api/health
    autoDeployTrigger: commit
    envVars:
      - key: NODE_ENV
        value: production
      - key: DATABASE_URL
        fromDatabase:
          name: <app-name>-db
          property: connectionString
      - key: SESSION_SECRET
        generateValue: true

databases:
  - name: <app-name>-db
    plan: free
```

If the app does not use Prisma, omit `npx prisma migrate deploy` from the build command.

If the app uses Prisma but does not need a Render-managed database, use:

```yaml
      - key: DATABASE_URL
        sync: false
```

## Split Folder Normalization

When a repo has `frontend/` and `backend/`, prefer adding or updating root scripts so Render still uses one service:

```json
{
  "scripts": {
    "build": "npm --prefix frontend ci && npm --prefix frontend run build && npm --prefix backend ci --include=dev && npm --prefix backend run build --if-present",
    "start": "npm --prefix backend start"
  },
  "devDependencies": {
    "prisma": "^5.22.0"
  },
  "prisma": {
    "schema": "backend/prisma/schema.prisma"
  }
}
```

Adjust the backend static path to point to `../frontend/dist` or copy the frontend build into a backend-served directory during `build`.

If using `npm ci` inside subfolders, ensure each subfolder has its own lockfile. If not, use `npm install` only as a fallback and note the tradeoff.

## Prisma Rules

- Create migrations for schema changes; do not depend on `prisma db push` in production.
- Use SQL migrations for required production seed data that must exist after deploy, such as new enum-backed product prices.
- Do not rely on Render `initialDeployHook` for recurring production data changes; it may not run on later deploys.
- Keep `npm run prisma:seed` only for initial/demo data unless the user explicitly asks otherwise.
- Use `prisma migrate deploy` in Render, not `prisma migrate dev`.

## User Interaction

Ask only when required information cannot be inferred, usually external `DATABASE_URL` or whether the user truly wants separate Render services.

When the user says they want Render deploys to be simple or reliable, choose the one Web Service pattern without asking.
