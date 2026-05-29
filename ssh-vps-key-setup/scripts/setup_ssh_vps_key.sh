#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  setup_ssh_vps_key.sh --ip REMOTE_HOST --port SSH_PORT --user SSH_USER --alias LOCAL_ALIAS [--password-stdin] [--overwrite]

The temporary VPS password is read from a hidden prompt unless --password-stdin is used.
USAGE
}

ip=""
port=""
remote_user=""
local_alias=""
password_stdin="false"
overwrite="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ip)
      ip="${2:-}"
      shift 2
      ;;
    --port)
      port="${2:-}"
      shift 2
      ;;
    --user)
      remote_user="${2:-}"
      shift 2
      ;;
    --alias)
      local_alias="${2:-}"
      shift 2
      ;;
    --password-stdin)
      password_stdin="true"
      shift
      ;;
    --overwrite)
      overwrite="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ -z "$ip" || -z "$port" || -z "$remote_user" || -z "$local_alias" ]]; then
  echo "Missing required --ip, --port, --user, or --alias." >&2
  usage >&2
  exit 2
fi

if [[ ! "$port" =~ ^[0-9]+$ ]]; then
  echo "--port must be numeric." >&2
  exit 2
fi

if [[ ! "$local_alias" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
  echo "--alias must be a valid shell alias name: letters, numbers, underscores, not starting with a number." >&2
  exit 2
fi

for tool in ssh ssh-keygen scp expect awk mktemp; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Required tool not found: $tool" >&2
    exit 1
  fi
done

ssh_bin="$(command -v ssh)"
ssh_dir="$HOME/.ssh"
key_path="$ssh_dir/id_ed25519_${local_alias}"
pub_path="${key_path}.pub"
zshrc="$HOME/.zshrc"

mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"

if [[ -e "$key_path" || -e "$pub_path" ]]; then
  if [[ "$overwrite" != "true" ]]; then
    echo "Key already exists at $key_path. Re-run with --overwrite only if you want to replace it." >&2
    exit 1
  fi
  rm -f "$key_path" "$pub_path"
fi

if [[ "$password_stdin" == "true" ]]; then
  IFS= read -r vps_password
else
  printf "Temporary VPS password: " >&2
  IFS= read -r -s vps_password
  printf "\n" >&2
fi

if [[ -z "${vps_password:-}" ]]; then
  echo "Temporary VPS password cannot be empty." >&2
  exit 2
fi

ssh-keygen -t ed25519 -f "$key_path" -N "" -C "${local_alias}@${ip}" >/dev/null
chmod 600 "$key_path"
chmod 644 "$pub_path"

export VPS_TEMP_PASSWORD="$vps_password"

run_with_password() {
  expect -f - "$@" <<'EXPECT'
set timeout 60
set cmd $argv
spawn {*}$cmd
expect {
  -re {(?i)are you sure you want to continue connecting} {
    send "yes\r"
    exp_continue
  }
  -re {(?i)(password|passphrase).*:} {
    send "$env(VPS_TEMP_PASSWORD)\r"
    exp_continue
  }
  eof {
    catch wait result
    exit [lindex $result 3]
  }
  timeout {
    exit 124
  }
}
EXPECT
}

remote="${remote_user}@${ip}"
remote_pub_name=".ssh/${local_alias}.pub"

run_with_password ssh \
  -p "$port" \
  -o StrictHostKeyChecking=accept-new \
  "$remote" \
  "umask 077; mkdir -p ~/.ssh; touch ~/.ssh/authorized_keys; chmod 700 ~/.ssh; chmod 600 ~/.ssh/authorized_keys"

run_with_password scp \
  -P "$port" \
  -o StrictHostKeyChecking=accept-new \
  "$pub_path" \
  "${remote}:${remote_pub_name}"

run_with_password ssh \
  -p "$port" \
  -o StrictHostKeyChecking=accept-new \
  "$remote" \
  "umask 077; grep -qxFf ~/${remote_pub_name} ~/.ssh/authorized_keys || cat ~/${remote_pub_name} >> ~/.ssh/authorized_keys; rm -f ~/${remote_pub_name}; chmod 600 ~/.ssh/authorized_keys"

unset VPS_TEMP_PASSWORD
unset vps_password

test_output="$("$ssh_bin" -i "$key_path" -p "$port" \
  -o BatchMode=yes \
  -o IdentitiesOnly=yes \
  -o PasswordAuthentication=no \
  -o StrictHostKeyChecking=accept-new \
  -o ConnectTimeout=10 \
  "$remote" 'echo key-auth-ok')"

if [[ "$test_output" != "key-auth-ok" ]]; then
  echo "Key-based SSH test failed." >&2
  exit 1
fi

alias_line="alias ${local_alias}='${ssh_bin} -i ${key_path} -p ${port} -o IdentitiesOnly=yes ${remote}'"
touch "$zshrc"
tmp_zshrc="$(mktemp)"

awk -v alias_name="$local_alias" -v alias_line="$alias_line" '
  BEGIN {
    replaced = 0
    pattern = "^alias[ \t]+" alias_name "="
  }
  $0 ~ pattern {
    if (!replaced) {
      print alias_line
      replaced = 1
    }
    next
  }
  { print }
  END {
    if (!replaced) {
      print alias_line
    }
  }
' "$zshrc" > "$tmp_zshrc"

mv "$tmp_zshrc" "$zshrc"

echo "SSH key created: $key_path"
echo "Public key installed on: $remote"
echo "Key login verified."
echo "Alias added to: $zshrc"
echo "Run this command in a new terminal or after: source $zshrc"
echo "Connect with: $local_alias"
