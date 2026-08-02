# Script instructions

These rules apply to `scripts/` and its descendants, in addition to the root `AGENTS.md`.

## General rules

- Keep host-specific logic in `windows/` or `macos/` and shared Ubuntu logic in `ubuntu/`.
- Prefer small, composable scripts over one script that performs unrelated tasks.
- Do not add destructive cleanup, distribution removal, broad Docker prune, or evidence deletion.
- Quote variables and paths.
- Return a nonzero exit code when a required check fails.
- Print clear `[PASS]`, `[WARN]`, `[FAIL]`, and `[NEXT]` messages where useful.
- Do not treat a warning as a final pass when the warned condition is required for the command's purpose.
- Do not log credentials or unnecessary personal paths.

## Bash

- Use `#!/usr/bin/env bash`.
- Use `set -Eeuo pipefail` for executable workflows unless there is a documented reason not to.
- Invoke repository scripts as `bash scripts/<path>.sh` in documentation, VS Code tasks, and CI.
- Use arrays for command lists and quote expansions.
- Use `mktemp` and `trap` for temporary files that require cleanup.
- Source shared helpers relative to the script location, not the caller's working directory.
- Preserve redaction through `scripts/ubuntu/lib/redact.sh` for generated evidence.
- Pass `bash -n` and ShellCheck at warning severity or stricter.

## PowerShell

- Use `[CmdletBinding()]` when parameters or advanced behavior are present.
- Use `Set-StrictMode -Version Latest`.
- Use `$ErrorActionPreference = "Stop"` for workflows that must fail closed.
- Use `-LiteralPath` for paths that may contain wildcard characters.
- Do not auto-unregister or overwrite WSL distributions.
- Do not emit Windows usernames or WSL home usernames into committed logs when they are not required.
- Pass the PowerShell parser check and PSScriptAnalyzer at Error severity.

## Evidence collectors

- Evidence collectors must record the command label and real command output.
- They may generate logs but must not update `docs/evidence-index.md` to `완료` automatically.
- Separate environment, terminal/permission, and Docker collection so an unavailable Docker service does not destroy earlier progress.
- Keep automatic redaction enabled and instruct the user to review the output manually.
- Do not generate screenshots.

## Validation changes

When adding or renaming scripts:

1. Update `scripts/README.md`.
2. Update `docs/repository-structure.md`.
3. Update `scripts/ubuntu/validate-repository.sh` if the file is required.
4. Update `.vscode/tasks.json` only when a user-facing task is useful.
5. Update `.github/workflows/validate.yml` when CI coverage changes.
