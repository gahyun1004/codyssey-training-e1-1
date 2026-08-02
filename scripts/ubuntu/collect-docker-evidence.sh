#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

source "$ROOT/scripts/ubuntu/lib/redact.sh"

LOG_DIR="$ROOT/docs/logs"
DOCKER_RAW="$(mktemp)"
HELLO_RAW="$(mktemp)"
WSL_RAW="$(mktemp)"
trap 'rm -f "$DOCKER_RAW" "$HELLO_RAW" "$WSL_RAW"' EXIT
mkdir -p "$LOG_DIR"

command -v docker >/dev/null 2>&1 || {
  echo '[FAIL] docker command not found.' >&2
  exit 1
}

docker version >/dev/null 2>&1 || {
  echo '[FAIL] Docker Server connection failed.' >&2
  exit 1
}

docker info >/dev/null 2>&1 || {
  echo '[FAIL] docker info failed.' >&2
  exit 1
}

{
  echo '$ docker --version'
  docker --version
  echo '$ docker version'
  docker version
  echo '$ docker info'
  docker info
  echo '$ docker images'
  docker images
  echo '$ docker ps -a'
  docker ps -a
  echo '$ docker stats --no-stream'
  docker stats --no-stream
} > "$DOCKER_RAW" 2>&1
redact_stream < "$DOCKER_RAW" | tee "$LOG_DIR/docker-basic.txt"

{
  echo '$ docker run --rm hello-world'
  docker run --rm hello-world
} > "$HELLO_RAW" 2>&1
redact_stream < "$HELLO_RAW" | tee "$LOG_DIR/hello-world.txt"

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  {
    echo '$ docker context show'
    docker context show
    echo '$ docker version'
    docker version
    echo '$ docker info'
    docker info
  } > "$WSL_RAW" 2>&1
  redact_stream < "$WSL_RAW" | tee "$LOG_DIR/windows-wsl-docker.txt"
fi

cat <<'NEXT'
[PASS] Docker Client·Server, 기본 운영과 hello-world 로그를 생성했습니다.
[NEXT] attach/exec, build, 포트, 바인드 마운트와 볼륨은 별도 절차로 직접 수행하세요.
NEXT
