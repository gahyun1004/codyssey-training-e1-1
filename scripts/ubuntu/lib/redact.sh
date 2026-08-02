#!/usr/bin/env bash

redact_stream() {
  local current_user
  current_user="${USER:-$(id -un 2>/dev/null || true)}"

  if [[ -n "$current_user" ]]; then
    sed -E \
      -e 's#(https?://)[^/@[:space:]]+@#\1***@#g' \
      -e 's#(/home/)[^/[:space:]]+#\1<USER>#g' \
      -e 's#(/Users/)[^/[:space:]]+#\1<USER>#g' \
      -e 's#(/mnt/[[:alpha:]]/Users/)[^/[:space:]]+#\1<USER>#g' \
      -e "s#${current_user}#<USER>#g"
  else
    sed -E \
      -e 's#(https?://)[^/@[:space:]]+@#\1***@#g' \
      -e 's#(/home/)[^/[:space:]]+#\1<USER>#g' \
      -e 's#(/Users/)[^/[:space:]]+#\1<USER>#g' \
      -e 's#(/mnt/[[:alpha:]]/Users/)[^/[:space:]]+#\1<USER>#g'
  fi
}

redact_file() {
  local target="$1"
  local temporary

  test -f "$target" || {
    printf '[FAIL] redact target not found: %s\n' "$target" >&2
    return 1
  }

  temporary="$(mktemp)"
  redact_stream < "$target" > "$temporary"
  cat "$temporary" > "$target"
  rm -f "$temporary"
}
