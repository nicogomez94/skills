---
name: ssh-vps-key-setup
description: Configure passwordless SSH key access for a new VPS and bootstrap Codex plus the user's skills there. Use when the user wants Codex to generate a dedicated SSH key, install the public key on a remote VPS with a temporary password, verify key-based login, add a permanent local shell alias in ~/.zshrc using absolute paths, mirror the host in ~/.ssh/config, and then install Codex through npm and the user's remote skills installer. Require the current request to provide the remote host, SSH port, SSH user, local alias, and temporary VPS password, or ask for the missing details before running commands.
---

# SSH VPS Key Setup

## Workflow

Use this skill to configure a VPS so the user can connect with a chosen local alias and no password, then install Codex and the user's skills in that VPS user's home directory.

1. Parse the current request for the remote host, SSH port, SSH user, local alias, and temporary VPS password. If any value is missing, ask the user for it before running setup commands.
2. Generate a new dedicated SSH key for the VPS, named from the provided alias, under the user's `~/.ssh`.
3. Install only the public key in the VPS user's `~/.ssh/authorized_keys`.
4. Verify login with the private key using `BatchMode=yes` and password authentication disabled.
5. Add or replace a permanent alias in `~/.zshrc` that uses absolute paths for both the SSH binary and the identity file.
6. Add or replace a matching `Host` entry in `~/.ssh/config` with `HostName`, `User`, `Port`, `IdentityFile`, and `IdentitiesOnly yes`.
7. After key-based login succeeds, connect using the private key and run the following commands as the VPS user:
   - `npm install -g @openai/codex`
   - `curl -fsSL https://raw.githubusercontent.com/nicogomez94/skills/main/install.sh | bash`
8. If `npm` is missing and the remote user is `root` on a Debian/Ubuntu-style VPS with `apt-get`, install `nodejs` and `npm` with `apt-get` before continuing. Otherwise, report the missing prerequisite and stop.
9. Verify that the `codex` executable is available.
10. In the final response, never print the private key. Report the exact command the user will run, normally the local alias or `ssh <host>`, and summarize whether Codex and the skills installer completed.

## Script

Prefer the bundled script for repeatability:

```bash
/Users/nicogomez/.codex/skills/ssh-vps-key-setup/scripts/setup_ssh_vps_key.sh \
  --ip <remote-host> \
  --port <ssh-port> \
  --user <ssh-user> \
  --alias <local-alias>
```

The script prompts for the temporary VPS password without echoing it. If automation is needed, use `--password-stdin` and provide the password over stdin; do not include the password in the final response. The script also updates `~/.ssh/config` with a matching host entry.

After the key-authentication test, the script bootstraps the remote VPS user with `@openai/codex` and runs the supplied skills installer. It requires `curl` and `bash`; if `npm` is missing, it can install `nodejs` and `npm` through `apt-get` only when the remote user is `root` and that package manager is available. If the system-wide npm prefix is not writable, the script may retry with a user-owned npm prefix under the VPS user's home.

## Safety Notes

- Do not display, cat, upload, or paste the private key.
- Do not store the temporary VPS password in `~/.zshrc`, `~/.ssh/config`, scripts, docs, or final messages.
- Do not overwrite an existing private key unless the user explicitly asks. If the script reports that the key path already exists, ask whether to use `--overwrite` or choose another alias/key name.
- If the VPS already has `PasswordAuthentication no`, key installation with the temporary password may fail; report that the server needs a valid password login path or console access for initial setup.
- Do not run the remote Codex or skills installation until key-based login has been verified.
- Run the skills installer as the configured VPS user, not as root via `sudo`, so it installs into that user's Codex home.
