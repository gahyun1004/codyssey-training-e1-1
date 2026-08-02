#!/usr/bin/env bash
set -Eeuo pipefail

GIT_ROOT="$(git rev-parse --show-toplevel)"
cd "$GIT_ROOT"

source /etc/os-release
PROCESS_NAME="$(ps -p $$ -o comm= | xargs)"
BRANCH_NAME="$(git branch --show-current)"

printf 'OS=%s\n' "$PRETTY_NAME"
printf 'SHELL=%s\n' "$SHELL"
printf 'PROCESS=%s\n' "$PROCESS_NAME"
printf 'PWD=%s\n' "$PWD"
printf 'GIT_ROOT=%s\n' "$GIT_ROOT"
printf 'BRANCH=%s\n' "$BRANCH_NAME"

test "${VERSION_ID:-}" = "24.04"
test "$PROCESS_NAME" = "bash"
test "$PWD" = "$GIT_ROOT"
test -n "$BRANCH_NAME"

echo "[PASS] Ubuntu 24.04, bash, workspace folder and Git root verified."
