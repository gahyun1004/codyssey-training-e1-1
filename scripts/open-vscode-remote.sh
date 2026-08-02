#!/usr/bin/env bash
set -Eeuo pipefail

MACHINE_NAME="${1:-codyssey-training}"
REPOSITORY_PATH="${2:-codyssey-training/codyssey-training-e1-1}"
REMOTE_HOST="${MACHINE_NAME}@orb"

find_code_bin() {
  local candidate

  if command -v code >/dev/null 2>&1; then
    command -v code
    return 0
  fi

  for candidate in \
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  do
    if [[ -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done

  return 1
}

if ! command -v orb >/dev/null 2>&1; then
  echo "[FAIL] OrbStack CLI(orb)를 찾지 못했습니다." >&2
  exit 1
fi

if ! command -v ssh >/dev/null 2>&1; then
  echo "[FAIL] SSH 클라이언트를 찾지 못했습니다." >&2
  exit 1
fi

CODE_BIN="$(find_code_bin || true)"
if [[ -z "$CODE_BIN" ]]; then
  echo "[FAIL] VS Code CLI를 찾지 못했습니다." >&2
  echo "VS Code에서 'Shell Command: Install code command in PATH'를 실행하거나 앱 설치 위치를 확인하세요." >&2
  exit 1
fi

orb status >/dev/null
orb info "$MACHINE_NAME" >/dev/null

if ! ssh \
  -o BatchMode=yes \
  -o ConnectTimeout=10 \
  "$REMOTE_HOST" \
  'test -n "$HOME" && command -v bash >/dev/null'
then
  echo "[FAIL] SSH 연결에 실패했습니다: $REMOTE_HOST" >&2
  exit 1
fi

REMOTE_DIR="$(ssh "$REMOTE_HOST" \
  "cd \"\$HOME/$REPOSITORY_PATH\" && pwd -P")"

if [[ -z "$REMOTE_DIR" ]]; then
  echo "[FAIL] 원격 저장소 경로를 확인하지 못했습니다." >&2
  exit 1
fi

if ! ssh "$REMOTE_HOST" \
  "test -d \"$REMOTE_DIR/.git\" && test -f \"$REMOTE_DIR/README.md\""
then
  echo "[FAIL] 원격 경로가 Git 저장소가 아닙니다: $REMOTE_DIR" >&2
  exit 1
fi

if ! "$CODE_BIN" --help | grep -q -- '--remote'; then
  echo "[FAIL] 현재 VS Code CLI가 --remote 옵션을 지원하지 않습니다." >&2
  exit 1
fi

if ! "$CODE_BIN" --list-extensions | grep -Fxq 'ms-vscode-remote.remote-ssh'; then
  echo "[INFO] Remote - SSH 확장을 설치합니다."
  "$CODE_BIN" --install-extension ms-vscode-remote.remote-ssh
fi

printf '[INFO] Remote host: %s\n' "$REMOTE_HOST"
printf '[INFO] Remote folder: %s\n' "$REMOTE_DIR"

exec "$CODE_BIN" \
  --new-window \
  --remote "ssh-remote+$REMOTE_HOST" \
  "$REMOTE_DIR"
