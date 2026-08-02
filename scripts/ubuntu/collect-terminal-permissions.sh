#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

source "$ROOT/scripts/ubuntu/lib/redact.sh"

LOG_DIR="$ROOT/docs/logs"
TERMINAL_RAW="$(mktemp)"
PERMISSIONS_RAW="$(mktemp)"
trap 'rm -f "$TERMINAL_RAW" "$PERMISSIONS_RAW"' EXIT

mkdir -p \
  "$LOG_DIR" \
  "$ROOT/practice/terminal" \
  "$ROOT/practice/permissions/permission-dir"

{
  cd "$ROOT/practice/terminal"
  rm -rf archive sample-copy.txt renamed.txt
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
} > "$TERMINAL_RAW" 2>&1

redact_stream < "$TERMINAL_RAW" | tee "$LOG_DIR/terminal-basic.txt"

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
  echo '$ ls -ld permission-dir'
  ls -ld permission-dir
  echo '$ chmod 755 permission-dir'
  chmod 755 permission-dir
  ls -ld permission-dir
  echo '$ chmod 700 permission-dir'
  chmod 700 permission-dir
  ls -ld permission-dir
} > "$PERMISSIONS_RAW" 2>&1

redact_stream < "$PERMISSIONS_RAW" | tee "$LOG_DIR/permissions.txt"

cat <<'NEXT'
[PASS] 터미널과 권한 로그를 생성하고 사용자 경로를 마스킹했습니다.
[NEXT] 변경 전후 출력과 실제 관찰 내용을 문서에 기록하세요.
NEXT
