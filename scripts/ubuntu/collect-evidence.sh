#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

LOG_DIR="$ROOT/docs/logs"
mkdir -p "$LOG_DIR" practice/terminal practice/permissions/permission-dir

require_command() {
  local command_name="$1"
  if ! command -v "$command_name" >/dev/null 2>&1; then
    printf '[FAIL] required command not found: %s\n' "$command_name" >&2
    exit 1
  fi
}

require_command git
require_command docker
require_command curl

{
  echo '$ date --iso-8601=seconds'
  date --iso-8601=seconds
  echo '$ cat /etc/os-release'
  cat /etc/os-release
  echo '$ uname -a'
  uname -a
  echo '$ whoami'
  whoami
  echo '$ printf "SHELL=%s\\n" "$SHELL"'
  printf 'SHELL=%s\n' "$SHELL"
  echo '$ printf "WSL_DISTRO_NAME=%s\\n" "${WSL_DISTRO_NAME:-not-wsl}"'
  printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-not-wsl}"
  echo '$ pwd'
  pwd
  echo '$ git rev-parse --show-toplevel'
  git rev-parse --show-toplevel
  echo '$ git branch --show-current'
  git branch --show-current
  echo '$ git remote -v'
  git remote -v
  echo '$ git --version'
  git --version
  if command -v gh >/dev/null 2>&1; then
    echo '$ gh --version | head -n 1'
    gh --version | head -n 1
  else
    echo '[INFO] GitHub CLI is not installed; Git commands remain available.'
  fi
  echo '$ docker --version'
  docker --version
  echo '$ docker version'
  docker version
} 2>&1 | tee "$LOG_DIR/environment.txt"

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  cp "$LOG_DIR/environment.txt" "$LOG_DIR/windows-wsl-environment.txt"
fi

{
  cd "$ROOT/practice/terminal"
  echo '$ pwd'
  pwd
  echo '$ ls -la'
  ls -la
  echo '$ touch sample.txt'
  touch sample.txt
  echo '$ echo "Codyssey E1-1" > sample.txt'
  echo 'Codyssey E1-1' > sample.txt
  echo '$ cat sample.txt'
  cat sample.txt
  echo '$ cp sample.txt sample-copy.txt'
  cp sample.txt sample-copy.txt
  echo '$ mv sample-copy.txt renamed.txt'
  mv sample-copy.txt renamed.txt
  echo '$ mkdir -p archive && mv renamed.txt archive/'
  mkdir -p archive
  mv renamed.txt archive/
  echo '$ ls -la archive'
  ls -la archive
  echo '$ rm archive/renamed.txt && rmdir archive'
  rm archive/renamed.txt
  rmdir archive
  echo '$ realpath sample.txt'
  realpath sample.txt
} 2>&1 | tee "$LOG_DIR/terminal-basic.txt"

{
  cd "$ROOT/practice/permissions"
  echo '$ touch permission-file.txt'
  touch permission-file.txt
  echo '$ ls -l permission-file.txt'
  ls -l permission-file.txt
  echo '$ chmod 644 permission-file.txt'
  chmod 644 permission-file.txt
  ls -l permission-file.txt
  echo '$ chmod 600 permission-file.txt'
  chmod 600 permission-file.txt
  ls -l permission-file.txt
  echo '$ chmod 755 permission-dir'
  chmod 755 permission-dir
  ls -ld permission-dir
  echo '$ chmod 700 permission-dir'
  chmod 700 permission-dir
  ls -ld permission-dir
} 2>&1 | tee "$LOG_DIR/permissions.txt"

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
} 2>&1 | tee "$LOG_DIR/docker-basic.txt"

{
  echo '$ docker run --rm hello-world'
  docker run --rm hello-world
} 2>&1 | tee "$LOG_DIR/hello-world.txt"

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  {
    echo '$ docker context show'
    docker context show
    echo '$ docker version'
    docker version
    echo '$ docker info'
    docker info
  } 2>&1 | tee "$LOG_DIR/windows-wsl-docker.txt"
fi

cat <<'NEXT'
[PASS] 기본 환경·터미널·권한·Docker 로그를 생성했습니다.
[NEXT] attach/exec, Docker build, 포트, 바인드 마운트, 볼륨과 화면 캡처는 README 절차에 따라 직접 수행하세요.
[NEXT] 실제 결과를 확인한 뒤에만 docs/evidence-index.md 상태를 완료로 변경하세요.
NEXT
