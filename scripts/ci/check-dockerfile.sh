#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

EXPECTED_FROM='FROM nginx:1.30.4-alpine3.24@sha256:97d490c12ba55b4946b01546d1c3ed324e8d41ab1c9fcb2a616aa470620e5b46'
ACTUAL_FROM="$(grep -m1 '^FROM ' Dockerfile || true)"

if [[ "$ACTUAL_FROM" != "$EXPECTED_FROM" ]]; then
  printf '[FAIL] Dockerfile base image mismatch.\nExpected: %s\nActual:   %s\n' \
    "$EXPECTED_FROM" "$ACTUAL_FROM" >&2
  exit 1
fi

if grep -Eq '^FROM .*:(latest|alpine)(@|$)' Dockerfile; then
  echo '[FAIL] Dockerfile uses a moving tag.' >&2
  exit 1
fi

grep -q '^COPY site/ /usr/share/nginx/html/$' Dockerfile
grep -q '^EXPOSE 80$' Dockerfile

printf '[PASS] Dockerfile base tag and multi-platform index digest are pinned.\n'
