#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

source "$ROOT/scripts/ubuntu/lib/redact.sh"

LOG_DIR="$ROOT/docs/logs"
RAW_LOG="$(mktemp)"
trap 'rm -f "$RAW_LOG"' EXIT
mkdir -p "$LOG_DIR"

command -v git >/dev/null 2>&1 || {
  echo '[FAIL] git command not found.' >&2
  exit 1
}

{
  echo '$ date --iso-8601=seconds'
  date --iso-8601=seconds
  echo '$ cat /etc/os-release'
  cat /etc/os-release
  echo '$ uname -a'
  uname -a
  echo '$ id -un'
  id -un
  echo '$ printf "HOME=%s\\n" "$HOME"'
  printf 'HOME=%s\n' "$HOME"
  echo '$ printf "SHELL=%s\\n" "$SHELL"'
  printf 'SHELL=%s\n' "${SHELL:-unknown}"
  echo '$ printf "WSL_DISTRO_NAME=%s\\n" "${WSL_DISTRO_NAME:-not-wsl}"'
  printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-not-wsl}"
  echo '$ pwd'
  pwd
  echo '$ git rev-parse --show-toplevel'
  git rev-parse --show-toplevel
  echo '$ git branch --show-current'
  git branch --show-current
  echo '$ git remote get-url origin'
  git remote get-url origin 2>/dev/null || echo '[INFO] origin remote is not configured.'
  echo '$ git --version'
  git --version
  if command -v gh >/dev/null 2>&1; then
    echo '$ gh --version | head -n 1'
    gh --version | head -n 1
  else
    echo '[INFO] GitHub CLI is not installed; Git commands remain available.'
  fi
} > "$RAW_LOG" 2>&1

redact_stream < "$RAW_LOG" | tee "$LOG_DIR/environment.txt"

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  cp "$LOG_DIR/environment.txt" "$LOG_DIR/windows-wsl-environment.txt"
fi

cat <<'NEXT'
[PASS] 환경과 Git 기본 로그를 생성하고 사용자 경로·URL 자격정보를 마스킹했습니다.
[NEXT] 커밋 전에 로그 전체를 다시 검토하세요.
NEXT
