#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

required_files=(
  README.md
  Dockerfile
  .dockerignore
  .gitignore
  .gitattributes
  .vscode/settings.json
  .vscode/extensions.json
  .vscode/tasks.json
  scripts/ubuntu/verify-remote-workspace.sh
  scripts/ubuntu/verify-wsl-workspace.sh
  scripts/ubuntu/select-port.sh
  scripts/ubuntu/collect-evidence.sh
  scripts/windows/setup-wsl.ps1
  scripts/windows/open-vscode-wsl.ps1
  scripts/windows/collect-wsl-host-evidence.ps1
  site/index.html
  bind-test/index.html
  docs/evidence-index.md
  docs/repository-structure.md
  docs/environment.md
  docs/terminal-and-permissions.md
  docs/docker-operations.md
  docs/image-design.md
  docs/port-and-bind.md
  docs/volume-persistence.md
  docs/test-results.md
  docs/troubleshooting.md
  docs/logs/README.md
  docs/screenshots/README.md
)

for path in "${required_files[@]}"; do
  if [[ ! -f "$path" ]]; then
    printf '[FAIL] required file missing: %s\n' "$path" >&2
    exit 1
  fi
done

while IFS= read -r -d '' script; do
  bash -n "$script"
done < <(find scripts -type f -name '*.sh' -print0)

for script in scripts/open-vscode-remote.sh scripts/macos/open-vscode-remote.sh scripts/ubuntu/*.sh; do
  if [[ ! -x "$script" ]]; then
    printf '[FAIL] executable bit missing: %s\n' "$script" >&2
    exit 1
  fi
done

if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PY'
import json
from pathlib import Path

for path in Path('.vscode').glob('*.json'):
    with path.open(encoding='utf-8') as handle:
        json.load(handle)
    print(f'[PASS] JSON: {path}')
PY
elif command -v jq >/dev/null 2>&1; then
  for json_file in .vscode/*.json; do
    jq empty "$json_file"
    printf '[PASS] JSON: %s\n' "$json_file"
  done
else
  echo '[FAIL] python3 or jq is required for JSON validation.' >&2
  exit 1
fi

grep -q '^FROM nginx:' Dockerfile
grep -q 'COPY site/' Dockerfile
grep -q 'Codyssey E1-1' site/index.html

echo '[PASS] repository structure, shell syntax and JSON syntax validated.'
