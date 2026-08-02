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

case "${1:-}" in
  "") ;;
  --skip-docker) REQUIRE_DOCKER=0 ;;
  --help|-h)
    cat <<'HELP'
Usage:
  bash scripts/ubuntu/verify-remote-workspace.sh
  bash scripts/ubuntu/verify-remote-workspace.sh --skip-docker
HELP
    exit 0
    ;;
  *)
    echo '[FAIL] unsupported option.' >&2
    exit 2
    ;;
esac

GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
test -n "$GIT_ROOT" || fail '현재 폴더가 Git 저장소가 아닙니다.'
cd "$GIT_ROOT"

source /etc/os-release
PROCESS_NAME="$(ps -p $$ -o comm= | xargs)"
BRANCH_NAME="$(git branch --show-current)"

printf 'OS=%s\n' "$PRETTY_NAME"
printf 'SHELL=%s\n' "${SHELL:-unknown}"
printf 'PROCESS=%s\n' "$PROCESS_NAME"
printf 'PWD=%s\n' "$PWD"
printf 'GIT_ROOT=%s\n' "$GIT_ROOT"
printf 'BRANCH=%s\n' "$BRANCH_NAME"

test "${VERSION_ID:-}" = "24.04" || fail 'Ubuntu 24.04가 아닙니다.'
test "$PROCESS_NAME" = "bash" || fail '현재 셸 프로세스가 bash가 아닙니다.'
test "$PWD" = "$GIT_ROOT" || fail '현재 폴더와 Git root가 다릅니다.'
test -n "$BRANCH_NAME" || fail '현재 Git branch를 확인하지 못했습니다.'

if (( REQUIRE_DOCKER == 1 )); then
  command -v docker >/dev/null 2>&1 || fail 'docker 명령을 찾지 못했습니다.'
  docker version >/dev/null 2>&1 || fail 'Docker Server에 연결하지 못했습니다.'
  docker info >/dev/null 2>&1 || fail 'docker info 실행에 실패했습니다.'
  printf 'DOCKER_CLIENT=%s\n' "$(docker --version)"
  echo '[PASS] Ubuntu 24.04, bash, workspace, Git root와 Docker 연결을 확인했습니다.'
else
  warn 'Docker 검증을 건너뛰었습니다.'
  echo '[PASS] Ubuntu 24.04, bash, workspace와 Git root를 확인했습니다.'
fi
