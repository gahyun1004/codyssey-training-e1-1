#!/usr/bin/env bash
set -Eeuo pipefail

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

warn() {
  printf '[WARN] %s\n' "$1" >&2
}

test -r /etc/os-release || fail '/etc/os-release를 읽을 수 없습니다.'
# shellcheck disable=SC1091
source /etc/os-release

PROCESS_NAME="$(ps -p $$ -o comm= | xargs)"
GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
CURRENT_DIR="$(pwd -P)"
KERNEL_RELEASE="$(uname -r)"
DISTRO_NAME="${WSL_DISTRO_NAME:-}"

printf 'OS=%s\n' "${PRETTY_NAME:-unknown}"
printf 'VERSION_ID=%s\n' "${VERSION_ID:-unknown}"
printf 'KERNEL=%s\n' "$KERNEL_RELEASE"
printf 'WSL_DISTRO_NAME=%s\n' "${DISTRO_NAME:-not-set}"
printf 'SHELL=%s\n' "${SHELL:-unknown}"
printf 'PROCESS=%s\n' "$PROCESS_NAME"
printf 'PWD=%s\n' "$CURRENT_DIR"
printf 'GIT_ROOT=%s\n' "${GIT_ROOT:-not-a-git-repository}"
printf 'BRANCH=%s\n' "$(git branch --show-current 2>/dev/null || true)"

test "${VERSION_ID:-}" = '24.04' || fail 'Ubuntu 24.04가 아닙니다.'
printf '%s\n' "$KERNEL_RELEASE" | grep -qiE 'microsoft|wsl' ||
  fail 'WSL 커널로 확인되지 않습니다.'
test -n "$DISTRO_NAME" || fail 'WSL_DISTRO_NAME이 설정되지 않았습니다.'
test "$PROCESS_NAME" = 'bash' || fail '현재 셸 프로세스가 bash가 아닙니다.'
test -n "$GIT_ROOT" || fail '현재 폴더가 Git 저장소가 아닙니다.'
test "$CURRENT_DIR" = "$GIT_ROOT" ||
  fail '현재 폴더와 Git 저장소 루트가 다릅니다.'

case "$CURRENT_DIR" in
  /mnt/*)
    warn "저장소가 Windows 마운트 경로에 있습니다: $CURRENT_DIR"
    warn '성능과 권한 일관성을 위해 WSL Linux 홈 사용을 권장합니다.'
    ;;
  "$HOME"/*)
    printf '[PASS] 저장소가 WSL Linux 홈에 있습니다.\n'
    ;;
esac

if command -v docker >/dev/null 2>&1; then
  if docker version >/dev/null 2>&1; then
    printf '[PASS] Docker Client와 Server 연결을 확인했습니다.\n'
  else
    warn 'Docker CLI는 있지만 Server에 연결하지 못했습니다.'
    warn 'Docker Desktop의 WSL Integration을 확인하세요.'
  fi
else
  warn 'docker 명령을 찾지 못했습니다.'
fi

printf '[PASS] WSL2, Ubuntu 24.04, bash, workspace 및 Git root를 확인했습니다.\n'
