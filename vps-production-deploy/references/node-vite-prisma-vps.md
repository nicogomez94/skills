# Node/Vite/Express/Prisma VPS Deployment

## Target Shape

Default stack:
- Monorepo npm workspaces.
- `client`: React + Vite, build in `client/dist`.
- `server`: Node + Express + Prisma + PostgreSQL.
- Root scripts:
  - `npm run build --workspace client`
  - `npm run start --workspace server`
  - `npm run db:generate --workspace server`
- API on `127.0.0.1:3001`.
- Backend endpoints `/health`, `/api/*`, `/uploads`.
- Uploads stored in `server/uploads`.
- Nginx serves `client/dist` and proxies `/api`, `/health`, `/uploads`.

## Variables

Use these names in shell snippets and generated files:

```bash
APP_DIR=/var/www/html/<slug>
DOMAIN=<domain-or-empty>
SERVER_IP=<detected-ip>
API_PORT=3001
NODE_VERSION=22
DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=<slug_with_underscores>
DB_USER=<slug_with_underscores>
DB_PASS=<generated-or-provided>
JWT_SECRET=<provided-or-generated>
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123
DEBUG_MODE=false
RUN_SEED_ON_DEPLOY=false
SERVICE_NAME=<slug>-api
DEPLOY_SCRIPT=/usr/local/bin/deploy-<slug>.sh
```

If the user provided explicit values, use them instead of generated defaults.

## Safe Command Sequence

1. Inspect context:

```bash
pwd
git status --short --branch
node -v || true
npm -v || true
sed -n '1,220p' package.json
sed -n '1,220p' client/package.json
sed -n '1,260p' server/package.json
find server -maxdepth 3 -iname 'schema.prisma' -print
```

2. Install system dependencies on Debian/Ubuntu:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg git nginx postgresql postgresql-contrib certbot python3-certbot-nginx
```

If Node is missing or not version 22, install NodeSource Node 22:

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

3. Prepare app directory:

If already inside the repo, keep working there. If the repo must live in `APP_DIR`, create the parent and move or clone only after confirming the current repo source is clear. Avoid overwriting a non-empty unrelated directory.

```bash
sudo mkdir -p "$(dirname "$APP_DIR")"
sudo chown -R "$USER":"$USER" "$(dirname "$APP_DIR")"
mkdir -p "$APP_DIR/server/uploads"
```

4. Prepare PostgreSQL idempotently:

```bash
sudo systemctl enable --now postgresql
sudo -u postgres psql -v ON_ERROR_STOP=1 \
  -v db_name="$DB_NAME" \
  -v db_user="$DB_USER" \
  -v db_pass="$DB_PASS" <<'SQL'
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'db_user') THEN
    EXECUTE format('CREATE USER %I WITH PASSWORD %L', :'db_user', :'db_pass');
  ELSE
    EXECUTE format('ALTER USER %I WITH PASSWORD %L', :'db_user', :'db_pass');
  END IF;
END
$$;
SELECT format('CREATE DATABASE %I OWNER %I', :'db_name', :'db_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'db_name')\gexec
GRANT ALL PRIVILEGES ON DATABASE :"db_name" TO :"db_user";
SQL
```

5. Create production env files.

Use examples as reference, but ensure at minimum:

`server/.env`:

```bash
NODE_ENV=production
PORT=3001
DATABASE_URL=postgresql://DB_USER:DB_PASS@127.0.0.1:5432/DB_NAME?schema=public
JWT_SECRET=JWT_SECRET_VALUE
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123
DEBUG_MODE=false
RUN_SEED_ON_DEPLOY=false
```

`client/.env`:

```bash
VITE_API_BASE_URL=https://DOMAIN
```

If no domain is available, use `http://SERVER_IP`. If the app expects only API path roots, use the same origin base that matches the existing frontend code.

6. Harden `.gitignore`.

Add missing entries without deleting existing ones:

```gitignore
node_modules/
.env
.env.*
!.env.example
client/dist/
server/uploads/
*.log
.DS_Store
```

7. Install, generate, migrate, and build:

```bash
cd "$APP_DIR"
if [ -f package-lock.json ]; then npm ci; else npm install; fi
npm run db:generate --workspace server
(cd server && npx prisma migrate deploy)
npm run build --workspace client
```

If `RUN_SEED_ON_DEPLOY=true`, run the repo's seed command only if it exists.

8. Create systemd service at `/etc/systemd/system/<SERVICE_NAME>.service`:

```ini
[Unit]
Description=<slug> Express API
After=network.target postgresql.service

[Service]
Type=simple
WorkingDirectory=APP_DIR
Environment=NODE_ENV=production
Environment=PORT=3001
ExecStart=/usr/bin/npm run start --workspace server
Restart=always
RestartSec=5
User=APP_USER
Group=APP_GROUP

[Install]
WantedBy=multi-user.target
```

Then:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now "$SERVICE_NAME"
sudo systemctl restart "$SERVICE_NAME"
sudo systemctl status "$SERVICE_NAME" --no-pager
```

9. Create nginx site at `/etc/nginx/sites-available/<slug>`:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name DOMAIN_OR_UNDERSCORE;

    root APP_DIR/client/dist;
    index index.html;

    client_max_body_size 25m;

    location /api/ {
        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location = /health {
        proxy_pass http://127.0.0.1:3001/health;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /uploads/ {
        proxy_pass http://127.0.0.1:3001/uploads/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

Use `_` as `server_name` only when no domain is configured.

Enable:

```bash
sudo ln -sfn "/etc/nginx/sites-available/$SLUG" "/etc/nginx/sites-enabled/$SLUG"
sudo nginx -t
sudo systemctl reload nginx
```

10. Enable HTTPS only when DNS resolves:

```bash
getent ahosts "$DOMAIN" | awk '{print $1}' | sort -u
```

If `DOMAIN` resolves to `SERVER_IP`:

```bash
sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m "admin@$DOMAIN" --redirect
sudo systemctl reload nginx
```

If it does not resolve, skip certbot and explicitly report that DNS must be fixed first.

11. Create repeatable deploy script at `/usr/local/bin/deploy-<slug>.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

APP_DIR="APP_DIR_VALUE"
SERVICE_NAME="SERVICE_NAME_VALUE"
RUN_SEED_ON_DEPLOY="${RUN_SEED_ON_DEPLOY:-false}"

cd "$APP_DIR"

echo "== git pull =="
git pull --ff-only

echo "== install deps =="
if [ -f package-lock.json ]; then npm ci; else npm install; fi

echo "== prisma generate =="
npm run db:generate --workspace server

echo "== prisma migrate deploy =="
(cd server && npx prisma migrate deploy)

if [ "$RUN_SEED_ON_DEPLOY" = "true" ] && npm run --workspace server | grep -qE '(^| )seed($|:)'; then
  echo "== seed =="
  npm run seed --workspace server
fi

echo "== build client =="
npm run build --workspace client

echo "== restart api =="
sudo systemctl restart "$SERVICE_NAME"

echo "== smoke tests =="
curl -fsS http://127.0.0.1:3001/health
sudo nginx -t
sudo systemctl is-active --quiet "$SERVICE_NAME"

echo "Deploy OK"
```

Install it:

```bash
sudo tee "$DEPLOY_SCRIPT" >/dev/null < deploy-script-source
sudo chmod +x "$DEPLOY_SCRIPT"
```

Prefer writing the script with a heredoc from Codex using the resolved values.

12. Add shell aliases idempotently to the user's shell rc file (`~/.bashrc` and `~/.zshrc` if present, otherwise `~/.bashrc`):

```bash
alias gs='git status'
alias gl='git log'
alias dirgit='cd APP_DIR_VALUE'
alias redeploy='sudo /usr/local/bin/deploy-SLUG_VALUE.sh'
alias codexf='codex --approval-mode full-access'
```

Append only if each alias is missing.

13. Smoke tests:

```bash
curl -fsS http://127.0.0.1:3001/health
curl -I http://127.0.0.1
curl -I http://SERVER_IP
curl -fsS http://DOMAIN/health
curl -I https://DOMAIN
systemctl status SERVICE_NAME --no-pager
journalctl -u SERVICE_NAME -n 80 --no-pager
```

Run domain/HTTPS checks only when configured.

## Final Report

Return:
- App directory.
- Domain and HTTPS status.
- Systemd service name.
- Nginx site path.
- Deploy script path.
- PostgreSQL database/user names, without printing the password.
- Aliases added.
- Smoke test results.
- Any skipped step and exact reason.
