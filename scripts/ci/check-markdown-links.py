#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parents[2]
LINK_PATTERN = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")
SKIP_PREFIXES = ("http://", "https://", "mailto:", "tel:", "#")


def normalize_target(raw_target: str) -> str:
    target = raw_target.strip()
    if target.startswith("<") and target.endswith(">"):
        target = target[1:-1]
    if " \"" in target:
        target = target.split(" \"", 1)[0]
    if " '" in target:
        target = target.split(" '", 1)[0]
    return unquote(target)


def main() -> int:
    failures: list[str] = []

    for markdown in sorted(ROOT.rglob("*.md")):
        text = markdown.read_text(encoding="utf-8")
        for match in LINK_PATTERN.finditer(text):
            target = normalize_target(match.group(1))
            if not target or target.startswith(SKIP_PREFIXES):
                continue

            file_part = target.split("#", 1)[0]
            if not file_part:
                continue

            resolved = (markdown.parent / file_part).resolve()
            try:
                resolved.relative_to(ROOT)
            except ValueError:
                failures.append(
                    f"{markdown.relative_to(ROOT)}: repository 밖을 가리키는 링크: {target}"
                )
                continue

            if not resolved.exists():
                failures.append(
                    f"{markdown.relative_to(ROOT)}: 존재하지 않는 링크 대상: {target}"
                )

    if failures:
        print("[FAIL] Markdown link validation failed:", file=sys.stderr)
        for failure in failures:
            print(f"  - {failure}", file=sys.stderr)
        return 1

    print("[PASS] Markdown relative links validated.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
