# GitHub automation instructions

These rules apply to `.github/` and its descendants, in addition to the root `AGENTS.md`.

## Workflow safety

- Keep workflow permissions at the minimum required level.
- Pin third-party Actions to a full commit SHA and retain a nearby version comment.
- Do not introduce secrets, write permissions, deployment credentials, or external publishing without explicit authorization.
- Prefer deterministic runner labels such as `ubuntu-24.04` over moving aliases when the repository depends on a specific environment.
- Set a reasonable job timeout.
- Ensure cleanup steps use `if: always()` when temporary containers or files may remain.

## Validation policy

Repository CI should continue to cover, as applicable:

- required repository structure
- Bash syntax and ShellCheck
- JSON syntax
- Markdown relative links
- PowerShell parser and PSScriptAnalyzer
- Dockerfile pinning controls
- basic credential-pattern checks
- Docker build and HTTP smoke test

Do not remove a validation step merely to make CI pass. Fix the underlying issue or document why a check no longer applies.

## Evidence boundary

GitHub Actions validates repository reproducibility. It does not prove that Windows/WSL or macOS/OrbStack steps were performed on the user's device. Do not update personal-device evidence status from CI alone.

## Pull requests

PR descriptions should include:

- purpose and scope
- important files changed
- validation performed
- validation not performed and reasons
- remaining personal-device work
- evidence and privacy impact
