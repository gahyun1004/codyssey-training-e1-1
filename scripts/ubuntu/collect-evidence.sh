#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

MODE="all"

usage() {
  cat <<'HELP'
Usage:
  bash scripts/ubuntu/collect-evidence.sh
  bash scripts/ubuntu/collect-evidence.sh --skip-docker
  bash scripts/ubuntu/collect-evidence.sh --docker-only

Options:
  --skip-docker  환경·Git·터미널·권한 로그만 생성
  --docker-only  Docker 기본 운영과 hello-world 로그만 생성
HELP
}

case "${1:-}" in
  "")
    MODE="all"
    ;;
  --skip-docker)
    MODE="skip-docker"
    ;;
  --docker-only)
    MODE="docker-only"
    ;;
  --help|-h)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if [[ "$MODE" != "docker-only" ]]; then
  bash "$ROOT/scripts/ubuntu/collect-environment.sh"
  bash "$ROOT/scripts/ubuntu/collect-terminal-permissions.sh"
fi

if [[ "$MODE" != "skip-docker" ]]; then
  bash "$ROOT/scripts/ubuntu/collect-docker-evidence.sh"
fi

case "$MODE" in
  all)
    echo '[PASS] 환경·터미널·권한·Docker 기본 로그 수집을 완료했습니다.'
    ;;
  skip-docker)
    echo '[PASS] Docker를 제외한 기본 로그 수집을 완료했습니다.'
    echo '[NEXT] Docker 연결 후 --docker-only 옵션을 실행하세요.'
    ;;
  docker-only)
    echo '[PASS] Docker 기본 로그 수집을 완료했습니다.'
    ;;
esac

cat <<'NEXT'
[NEXT] 자동 마스킹 결과를 포함해 모든 로그를 직접 검토하세요.
[NEXT] attach/exec, build, 포트, 바인드 마운트, 볼륨과 화면 캡처는 README 절차에 따라 직접 수행하세요.
[NEXT] 실제 결과 확인 후에만 docs/evidence-index.md 상태를 완료로 변경하세요.
NEXT
