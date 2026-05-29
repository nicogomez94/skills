# WordPress LEMP VPS Deployment

## Target Shape

Default stack:
- Ubuntu 22.04 VPS.
- nginx, no Apache.
- PHP-FPM 8.2.
- MySQL or MariaDB.
- Existing WordPress source repo at `APP_DIR`.
- WP-CLI installed globally.
- WooCommerce installed and active.
- Existing custom theme activated.
- Repeatable deploy script at `/usr/local/bin/deploy-<slug>.sh`.
- Aliases: `gs`, `dirgit`, `redeploy`, `codexf`.

## Variables

Use these names in shell snippets and generated files:

```bash
APP_DIR=/var/www/html/<slug>
DOMAIN=<domain>
SERVER_IP=<detected-ip>
PHP_VERSION=8.2
DB_NAME=<slug_with_underscores>
DB_USER=<slug_with_underscores>
DB_PASS=<generated-or-provided>
WP_ADMIN_USER=admin
WP_ADMIN_PASS=<generated-or-provided>
WP_ADMIN_EMAIL=admin@<domain>
WP_THEME_NAME=<theme-folder>
SLUG=<slug>
DEPLOY_SCRIPT=/usr/local/bin/deploy-<slug>.sh
NGINX_SITE=/etc/nginx/sites-available/<slug>
PHP_FPM_SERVICE=php8.2-fpm
```

Use user-provided values over generated defaults.

## Stage 1: Validate Environment

Explain that the stage checks the VPS, repo, and WordPress base before changing anything.

Run:

```bash
lsb_release -a || cat /etc/os-release
test -d "$APP_DIR"
test -d "$APP_DIR/.git"
git -C "$APP_DIR" remote -v
git -C "$APP_DIR" branch --show-current
git -C "$APP_DIR" status --short --branch
git config --global --add safe.directory "$APP_DIR" || true
test -d "$APP_DIR/wp-admin" && test -d "$APP_DIR/wp-includes" && test -f "$APP_DIR/index.php"
test -f "$APP_DIR/wp-config.php" && echo "wp-config.php exists" || echo "wp-config.php missing"
```

If WordPress core files are missing, do not install core blindly. Inspect the repo and ask unless the user clearly requested a fresh install.

## Stage 2: Install Dependencies

Explain that this installs only the LEMP packages needed for WordPress/WooCommerce on a small VPS.

For Ubuntu 22.04 PHP 8.2, add Ondrej PPA only if `php8.2-fpm` is unavailable from configured repos:

```bash
sudo apt-get update
if ! apt-cache show php8.2-fpm >/dev/null 2>&1; then
  sudo apt-get install -y software-properties-common ca-certificates lsb-release apt-transport-https
  sudo add-apt-repository -y ppa:ondrej/php
  sudo apt-get update
fi

sudo apt-get install -y \
  nginx \
  mysql-server \
  php8.2-fpm php8.2-cli php8.2-mysql php8.2-curl php8.2-gd \
  php8.2-mbstring php8.2-xml php8.2-zip php8.2-intl \
  php8.2-bcmath php8.2-soap php8.2-imagick \
  curl unzip git rsync

sudo systemctl enable --now nginx
sudo systemctl enable --now mysql || sudo systemctl enable --now mariadb
sudo systemctl enable --now php8.2-fpm
```

If `mysql-server` is unavailable, install `mariadb-server` and adapt the service name.

## Stage 3: Prepare MySQL

Explain that this creates or reuses the database and user without deleting existing data.

Prefer socket auth as root:

```bash
sudo mysql <<SQL
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
ALTER USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
SQL
```

Never drop or recreate a database unless explicitly confirmed.

## Stage 4: Prepare wp-config.php

Explain that this configures production database access and salts while preserving any existing config.

If `wp-config.php` exists:
- Do not overwrite.
- Make a timestamped backup before any approved edit.
- Show the relevant differences before changing DB constants.

If missing, create it from `wp-config-sample.php` if available, otherwise write a standard config:

```bash
cd "$APP_DIR"
SALTS="$(curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/)"
```

Required values:

```php
define( 'DB_NAME', '<DB_NAME>' );
define( 'DB_USER', '<DB_USER>' );
define( 'DB_PASSWORD', '<DB_PASS>' );
define( 'DB_HOST', 'localhost' );
define( 'DB_CHARSET', 'utf8mb4' );
define( 'DB_COLLATE', '' );
define( 'WP_DEBUG', false );
define( 'DISALLOW_FILE_EDIT', true );
```

Also set:

```php
$table_prefix = 'wp_';
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
```

Set file permissions after creation:

```bash
sudo chown www-data:www-data "$APP_DIR/wp-config.php"
sudo chmod 640 "$APP_DIR/wp-config.php"
```

## Stage 5: Install WP-CLI

Explain that WP-CLI is used for database install, theme/plugin activation, and checks.

```bash
if ! command -v wp >/dev/null 2>&1; then
  curl -fsSL -o /tmp/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  php /tmp/wp-cli.phar --info
  sudo mv /tmp/wp-cli.phar /usr/local/bin/wp
  sudo chmod +x /usr/local/bin/wp
fi
wp --info
```

Run WP-CLI as `www-data` for WordPress operations:

```bash
sudo -u www-data wp --path="$APP_DIR" <command>
```

If `www-data` cannot read Git-owned files yet, fix permissions before WP-CLI operations.

## Stage 6: Install WordPress Database Only

Explain that core files are reused and only DB installation runs if needed.

```bash
if sudo -u www-data wp --path="$APP_DIR" core is-installed; then
  echo "WordPress already installed"
else
  sudo -u www-data wp --path="$APP_DIR" core install \
    --url="https://$DOMAIN" \
    --title="$DOMAIN" \
    --admin_user="$WP_ADMIN_USER" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email
fi
```

If HTTPS is not ready yet, use `http://$DOMAIN` and update to HTTPS after certbot.

Set site URLs:

```bash
sudo -u www-data wp --path="$APP_DIR" option update home "https://$DOMAIN"
sudo -u www-data wp --path="$APP_DIR" option update siteurl "https://$DOMAIN"
```

Use HTTP instead when HTTPS is skipped.

## Stage 7: Theme

Explain that this verifies and activates the existing custom theme.

Use the user-provided `WP_THEME_NAME`. If the prompt says to verify `ferreteria-theme`, prefer that exact folder when it exists.

```bash
test -d "$APP_DIR/wp-content/themes/$WP_THEME_NAME"
sudo -u www-data wp --path="$APP_DIR" theme list
sudo -u www-data wp --path="$APP_DIR" theme activate "$WP_THEME_NAME"
sudo -u www-data wp --path="$APP_DIR" theme status "$WP_THEME_NAME"
```

Do not create a new theme folder if the expected one exists. If the expected theme is missing, list available themes and ask before choosing.

## Stage 8: WooCommerce

Explain that this installs or activates WooCommerce without removing existing plugin data.

```bash
if sudo -u www-data wp --path="$APP_DIR" plugin is-installed woocommerce; then
  sudo -u www-data wp --path="$APP_DIR" plugin update woocommerce || true
else
  sudo -u www-data wp --path="$APP_DIR" plugin install woocommerce
fi

sudo -u www-data wp --path="$APP_DIR" plugin activate woocommerce
sudo -u www-data wp --path="$APP_DIR" plugin is-active woocommerce
```

Do not run destructive WooCommerce setup or sample data import unless requested.

## Stage 9: nginx

Explain that nginx will serve WordPress with PHP-FPM, pretty permalinks, upload limits, and the selected domain/IP.

Create `/etc/nginx/sites-available/<slug>`:

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name DOMAIN SERVER_IP;

    root APP_DIR;
    index index.php index.html index.htm;

    client_max_body_size 64m;

    access_log /var/log/nginx/SLUG.access.log;
    error_log /var/log/nginx/SLUG.error.log;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
        fastcgi_read_timeout 120;
    }

    location ~* \.(?:css|js|jpg|jpeg|gif|png|webp|svg|ico|woff|woff2|ttf|eot)$ {
        expires 30d;
        access_log off;
        try_files $uri =404;
    }

    location ~ /\. {
        deny all;
    }

    location = /xmlrpc.php {
        deny all;
    }
}
```

If no domain is available, use `server_name SERVER_IP _;`.

Enable safely:

```bash
sudo ln -sfn "$NGINX_SITE" "/etc/nginx/sites-enabled/$SLUG"
sudo nginx -t
sudo systemctl reload nginx
```

Do not enable Apache configs.

## Stage 10: PHP Tuning for 1 GB RAM

Explain that PHP-FPM is tuned conservatively for a small VPS.

Edit `/etc/php/8.2/fpm/php.ini` idempotently:

```ini
memory_limit = 256M
upload_max_filesize = 64M
post_max_size = 64M
max_execution_time = 120
max_input_vars = 3000
```

Edit `/etc/php/8.2/fpm/pool.d/www.conf` idempotently:

```ini
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
pm.max_requests = 500
```

Then:

```bash
sudo systemctl restart php8.2-fpm
sudo systemctl reload nginx
```

## Stage 11: Permissions

Explain that permissions will allow nginx/PHP writes while keeping Git usable.

Conservative defaults:

```bash
sudo chown -R "$USER":www-data "$APP_DIR"
sudo find "$APP_DIR" -type d -exec chmod 775 {} \;
sudo find "$APP_DIR" -type f -exec chmod 664 {} \;
sudo chown www-data:www-data "$APP_DIR/wp-config.php"
sudo chmod 640 "$APP_DIR/wp-config.php"
sudo chown -R www-data:www-data "$APP_DIR/wp-content/uploads" "$APP_DIR/wp-content/cache" 2>/dev/null || true
sudo find "$APP_DIR" -type d -name .git -prune -o -type d -exec chmod 775 {} \;
```

Avoid `777`. If Git becomes unable to write, adjust group membership or ownership without loosening web permissions globally.

## Stage 12: Aliases

Append idempotently to `~/.bashrc` and `~/.zshrc` if present, otherwise `~/.bashrc`:

```bash
alias gs='git status'
alias dirgit='cd APP_DIR_VALUE'
alias redeploy='sudo /usr/local/bin/deploy-SLUG_VALUE.sh'
alias codexf='codex --approval-mode full-access'
```

The user asked for `/usr/local/bin/redeploy.sh` in one alias description, but the deploy objective names `/usr/local/bin/deploy-CAMBIAR.sh`. Prefer the project-specific script and optionally create `/usr/local/bin/redeploy.sh` as a symlink to it when this VPS hosts only this app:

```bash
sudo ln -sfn "$DEPLOY_SCRIPT" /usr/local/bin/redeploy.sh
```

## Stage 13: Deploy Script

Create `/usr/local/bin/deploy-<slug>.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

APP_DIR="APP_DIR_VALUE"
SLUG="SLUG_VALUE"
NGINX_SITE="/etc/nginx/sites-available/SLUG_VALUE"
PHP_FPM_SERVICE="php8.2-fpm"
BACKUP_DIR="/var/backups/wordpress-$SLUG/$(date +%Y%m%d-%H%M%S)"

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

echo "== backup critical files =="
sudo mkdir -p "$BACKUP_DIR"
[ -f "$APP_DIR/wp-config.php" ] && sudo cp -a "$APP_DIR/wp-config.php" "$BACKUP_DIR/wp-config.php"
[ -f "$APP_DIR/.htaccess" ] && sudo cp -a "$APP_DIR/.htaccess" "$BACKUP_DIR/.htaccess"
[ -f "$NGINX_SITE" ] && sudo cp -a "$NGINX_SITE" "$BACKUP_DIR/nginx-site"

echo "== git pull =="
cd "$APP_DIR"
git pull --ff-only || fail "git pull failed"

echo "== cache cleanup =="
if command -v wp >/dev/null 2>&1; then
  sudo -u www-data wp --path="$APP_DIR" cache flush || true
fi
[ -d "$APP_DIR/wp-content/cache" ] && sudo find "$APP_DIR/wp-content/cache" -mindepth 1 -maxdepth 2 -type f -delete || true

echo "== permissions =="
sudo chown -R "$USER":www-data "$APP_DIR"
sudo find "$APP_DIR" -type d -exec chmod 775 {} \;
sudo find "$APP_DIR" -type f -exec chmod 664 {} \;
sudo chown www-data:www-data "$APP_DIR/wp-config.php"
sudo chmod 640 "$APP_DIR/wp-config.php"
sudo chown -R www-data:www-data "$APP_DIR/wp-content/uploads" "$APP_DIR/wp-content/cache" 2>/dev/null || true

echo "== services =="
sudo nginx -t || fail "nginx config invalid"
sudo systemctl restart "$PHP_FPM_SERVICE" || fail "php-fpm restart failed"
sudo systemctl reload nginx || fail "nginx reload failed"

echo "== smoke =="
curl -fsSI http://127.0.0.1 >/dev/null || fail "localhost HTTP check failed"
if command -v wp >/dev/null 2>&1; then
  sudo -u www-data wp --path="$APP_DIR" core is-installed || fail "WordPress is not installed"
fi

echo "Deploy OK. Backup: $BACKUP_DIR"
```

Install:

```bash
sudo tee "$DEPLOY_SCRIPT" >/dev/null < rendered-script
sudo chmod +x "$DEPLOY_SCRIPT"
sudo ln -sfn "$DEPLOY_SCRIPT" /usr/local/bin/redeploy.sh
```

Never delete uploads or overwrite `wp-config.php` in this script.

## Stage 14: Smoke Tests

Run:

```bash
curl -fsSI http://127.0.0.1
curl -fsSI "http://$DOMAIN"
curl -fsS "http://$DOMAIN/wp-json" | head -c 500
curl -fsSI "http://$DOMAIN/wp-admin/"
sudo -u www-data wp --path="$APP_DIR" plugin is-active woocommerce
sudo -u www-data wp --path="$APP_DIR" theme status "$WP_THEME_NAME"
sudo -u www-data wp --path="$APP_DIR" option get home
sudo -u www-data wp --path="$APP_DIR" option get siteurl
```

If HTTPS was configured separately, repeat domain checks with `https://`.

## Optional HTTPS

If certbot is requested or expected and DNS resolves to the VPS:

```bash
sudo apt-get install -y certbot python3-certbot-nginx
getent ahosts "$DOMAIN" | awk '{print $1}' | sort -u
sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos -m "$WP_ADMIN_EMAIL" --redirect
sudo systemctl reload nginx
sudo -u www-data wp --path="$APP_DIR" option update home "https://$DOMAIN"
sudo -u www-data wp --path="$APP_DIR" option update siteurl "https://$DOMAIN"
```

Skip certbot and report the DNS mismatch if the domain does not resolve to `SERVER_IP`.

## Security Rules

- Do not print full `DB_PASS` or `WP_ADMIN_PASS`.
- Reject obviously weak generated passwords; if the user provided weak placeholders, generate replacements and report that secrets were generated.
- Do not run destructive SQL.
- Do not run `git reset --hard`.
- Disable file editing with `DISALLOW_FILE_EDIT`.
- Consider denying `xmlrpc.php` unless the project specifically needs it.

## Final Report

Return:
- Final URL and HTTPS status.
- WordPress path.
- Git remote and branch.
- Active theme.
- WooCommerce active/inactive status.
- nginx site path.
- PHP-FPM service/version.
- Database and user names only, no passwords.
- Deploy script path and `redeploy` alias.
- Useful commands:
  - `dirgit`
  - `redeploy`
  - `sudo systemctl status nginx`
  - `sudo systemctl status php8.2-fpm`
  - `sudo -u www-data wp --path=APP_DIR plugin list`
- Smoke test results and skipped steps with reasons.
