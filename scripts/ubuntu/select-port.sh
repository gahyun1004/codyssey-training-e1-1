#!/usr/bin/env bash
set -Eeuo pipefail

if (( $# > 0 )); then
  CANDIDATES=("$@")
else
  CANDIDATES=(8080 8081 18080 18081)
fi

port_is_busy() {
  local port="$1"

  if command -v mac >/dev/null 2>&1; then
    if mac lsof -nP -iTCP:"$port" -sTCP:LISTEN 2>/dev/null | grep -q LISTEN; then
      return 0
    fi
  fi

  if command -v docker >/dev/null 2>&1; then
    if docker ps --format '{{.Ports}}' 2>/dev/null \
      | grep -Eq "(^|[,:])${port}->"; then
      return 0
    fi
  fi

  return 1
}

for candidate in "${CANDIDATES[@]}"; do
  if [[ "$candidate" =~ ^[0-9]+$ ]] && ! port_is_busy "$candidate"; then
    printf '%s\n' "$candidate"
    exit 0
  fi
done

echo "[FAIL] 사용할 수 있는 포트를 찾지 못했습니다." >&2
exit 1
