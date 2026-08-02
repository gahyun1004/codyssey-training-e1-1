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
  .github/workflows/validate.yml
  .vscode/settings.json
  .vscode/extensions.json
  .vscode/tasks.json
  scripts/ci/check-dockerfile.sh
  scripts/ci/check-markdown-links.py
  scripts/ci/check-powershell-syntax.ps1
  scripts/ubuntu/lib/redact.sh
  scripts/ubuntu/verify-remote-workspace.sh
  scripts/ubuntu/verify-wsl-workspace.sh
  scripts/ubuntu/select-port.sh
  scripts/ubuntu/collect-environment.sh
  scripts/ubuntu/collect-terminal-permissions.sh
  scripts/ubuntu/collect-docker-evidence.sh
  scripts/ubuntu/collect-evidence.sh
  scripts/ubuntu/validate-repository.sh
  scripts/windows/setup-wsl.ps1
  scripts/windows/open-vscode-wsl.ps1
  scripts/windows/collect-wsl-host-evidence.ps1
  site/index.html
  bind-test/index.html
  docs/repository-audit.md
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
echo '[PASS] Shell syntax validated.'

# 저장소의 셸 스크립트는 문서·Task·CI에서 모두 `bash <path>`로 실행합니다.
# 따라서 Git 실행 비트에 의존하지 않고, 문법과 호출 경로를 검증합니다.

if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PY'
import json
from pathlib import Path

for path in Path('.vscode').glob('*.json'):
    with path.open(encoding='utf-8') as handle:
        json.load(handle)
    print(f'[PASS] JSON: {path}')
PY
else
  echo '[FAIL] python3 is required for repository validation.' >&2
  exit 1
fi

python3 scripts/ci/check-markdown-links.py
bash scripts/ci/check-dockerfile.sh

if command -v pwsh >/dev/null 2>&1; then
  pwsh -NoProfile -File scripts/ci/check-powershell-syntax.ps1
else
  echo '[INFO] pwsh not found; PowerShell syntax check is delegated to GitHub Actions.'
fi

grep -q 'Codyssey E1-1' site/index.html

if git grep -n -E 'https?://[^/@[:space:]]+@' -- ':!docs/troubleshooting.md'; then
  echo '[FAIL] credential-like URL found in tracked files.' >&2
  exit 1
fi

echo '[PASS] repository structure, syntax, links, Dockerfile and basic secret patterns validated.'
