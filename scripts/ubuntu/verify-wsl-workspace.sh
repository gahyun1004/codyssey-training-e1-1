#!/usr/bin/env bash
set -Eeuo pipefail

REQUIRE_DOCKER=1

fail() {
  printf '[FAIL] %s\n' "$1" >&2
  exit 1
}

warn() {
  printf '[WARN] %s\n' "$1" >&2
}

usage() {
  cat <<'HELP'
Usage:
  bash scripts/ubuntu/verify-wsl-workspace.sh
  bash scripts/ubuntu/verify-wsl-workspace.sh --skip-docker

기본 실행은 Docker Client·Server 연결까지 필수로 검증합니다.
Docker Desktop 설정 전 단계만 확인할 때 --skip-docker를 사용합니다.
HELP
}

case "${1:-}" in
  "") ;;
  --skip-docker) REQUIRE_DOCKER=0 ;;
  --help|-h)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

test -r /etc/os-release || fail '/etc/os-release를 읽을 수 없습니다.'
source /etc/os-release

PROCESS_NAME="$(ps -p $$ -o comm= | xargs)"
GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
CURRENT_DIR="$(pwd -P)"
KERNEL_RELEASE="$(uname -r)"
DISTRO_NAME="${WSL_DISTRO_NAME:-}"
BRANCH_NAME="$(git branch --show-current 2>/dev/null || true)"

printf 'OS=%s\n' "${PRETTY_NAME:-unknown}"
printf 'VERSION_ID=%s\n' "${VERSION_ID:-unknown}"
printf 'KERNEL=%s\n' "$KERNEL_RELEASE"
printf 'WSL_DISTRO_NAME=%s\n' "${DISTRO_NAME:-not-set}"
printf 'SHELL=%s\n' "${SHELL:-unknown}"
printf 'PROCESS=%s\n' "$PROCESS_NAME"
printf 'PWD=%s\n' "$CURRENT_DIR"
printf 'GIT_ROOT=%s\n' "${GIT_ROOT:-not-a-git-repository}"
printf 'BRANCH=%s\n' "$BRANCH_NAME"

test "${VERSION_ID:-}" = '24.04' || fail 'Ubuntu 24.04가 아닙니다.'
printf '%s\n' "$KERNEL_RELEASE" | grep -qiE 'microsoft|wsl' \
  || fail 'WSL 커널로 확인되지 않습니다.'
test -n "$DISTRO_NAME" || fail 'WSL_DISTRO_NAME이 설정되지 않았습니다.'
test "$PROCESS_NAME" = 'bash' || fail '현재 셸 프로세스가 bash가 아닙니다.'
test -n "$GIT_ROOT" || fail '현재 폴더가 Git 저장소가 아닙니다.'
test "$CURRENT_DIR" = "$GIT_ROOT" \
  || fail '현재 폴더와 Git 저장소 루트가 다릅니다.'
test -n "$BRANCH_NAME" || fail '현재 Git branch를 확인하지 못했습니다.'

case "$CURRENT_DIR" in
  /mnt/*)
    warn "저장소가 Windows 마운트 경로에 있습니다: $CURRENT_DIR"
    warn '성능과 권한 일관성을 위해 WSL Linux 홈 사용을 권장합니다.'
    ;;
  "$HOME"/*)
    printf '[PASS] 저장소가 WSL Linux 홈에 있습니다.\n'
    ;;
  *)
    warn '저장소가 HOME 아래에 있지 않습니다. 실제 의도한 경로인지 확인하세요.'
    ;;
esac

if (( REQUIRE_DOCKER == 1 )); then
  command -v docker >/dev/null 2>&1 \
    || fail 'docker 명령을 찾지 못했습니다.'
  docker version >/dev/null 2>&1 \
    || fail 'Docker Server에 연결하지 못했습니다. Docker Desktop WSL Integration을 확인하세요.'
  docker info >/dev/null 2>&1 \
    || fail 'docker info 실행에 실패했습니다.'
  printf 'DOCKER_CLIENT=%s\n' "$(docker --version)"
  printf '[PASS] Docker Client와 Server 연결을 확인했습니다.\n'
  printf '[PASS] WSL2, Ubuntu 24.04, bash, workspace, Git root와 Docker를 확인했습니다.\n'
else
  warn 'Docker 검증을 건너뛰었습니다.'
  printf '[PASS] WSL2, Ubuntu 24.04, bash, workspace와 Git root를 확인했습니다.\n'
fi
