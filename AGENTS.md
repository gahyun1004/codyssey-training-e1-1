# Codex repository instructions

## Purpose

This repository supports the Codyssey E1-1 workstation mission on one of two execution platforms:

- Windows 11 Pro + WSL2 Ubuntu 24.04 + VS Code Remote-WSL + Docker Desktop WSL Integration
- macOS + OrbStack Ubuntu 24.04 + VS Code Remote-SSH + OrbStack Docker

Repository automation, templates, and `.gitkeep` files help perform the mission. They are not evidence that the mission was executed.

## Scope

These instructions apply to the entire repository. A more specific `AGENTS.md` in a subdirectory adds rules for files in that subtree. When instructions conflict, follow the more specific rule unless it contradicts the current user request or safety requirements.

## Read before changing files

Read at least the following before starting a repository-wide task:

1. `README.md`
2. `docs/repository-audit.md`
3. `docs/repository-structure.md`
4. `docs/evidence-index.md`
5. The platform guide relevant to the task:
   - `docs/windows-wsl.md`
   - `docs/macos-orbstack-guide.md`
6. Any `AGENTS.md` that applies to the target path
7. The task specification under `docs/codex/tasks/`, when one is provided

Do not assume that a template field, expected file path, or checklist item represents a completed result.

## Source-of-truth order

Use the following order when repository documents differ:

1. The current user request
2. Applicable `AGENTS.md` instructions
3. The task specification under `docs/codex/tasks/`
4. Actual repository files and executable behavior
5. `docs/evidence-index.md` for evidence status
6. Platform-specific guides
7. `README.md`
8. Other explanatory documents

Actual command output and real evidence take precedence over prose. Do not rewrite observed facts merely to make documents agree.

## Non-negotiable evidence rules

- Never invent command output, logs, screenshots, timestamps, versions, commit SHAs, paths, test results, or troubleshooting incidents.
- Never change an evidence state to `완료` unless the referenced evidence exists and has been checked.
- Never present generated templates, `.gitkeep` files, CI output, or examples as personal-device evidence.
- Preserve real user-generated logs and screenshots unless the task explicitly requests a safe transformation.
- Mark sample output and hypothetical procedures explicitly as examples.
- Keep unused platform items as `해당 없음`, not `완료`.
- State clearly when a verification could not be run and why.

## Safety and privacy

- Do not commit tokens, passwords, authentication codes, private keys, cookies, `.env.local`, or credentials embedded in URLs.
- Mask user home paths, usernames, email addresses, internal hostnames, and other unnecessary personal data in evidence.
- Do not add or run destructive commands such as `wsl --unregister`, broad Docker prune operations, recursive deletion outside a dedicated temporary path, or volume deletion without explicit authorization.
- Do not overwrite existing WSL distributions, Docker volumes, or personal-device evidence.
- Do not weaken existing secret checks, log redaction, pinned dependencies, or CI security controls without a documented reason.

## Platform discipline

- Keep Windows/WSL and macOS/OrbStack procedures distinct.
- Do not combine both platforms into one required execution path.
- Put shared Linux commands in common documentation or `scripts/ubuntu/` only when they work in both environments.
- Put host-specific behavior in `scripts/windows/` or `scripts/macos/`.
- Docker Desktop users must not be instructed to install a second Docker Engine inside WSL unless the task explicitly changes the architecture.

## Change discipline

- Modify only files required for the task.
- Prefer updating an existing source-of-truth document over creating duplicate guidance.
- Keep implementation, README instructions, VS Code tasks, validation scripts, and CI synchronized when a command or path changes.
- When adding, moving, or deleting repository files, update `docs/repository-structure.md` and any affected indexes.
- When adding a required file, update `scripts/ubuntu/validate-repository.sh` when appropriate.
- Keep Markdown relative links valid.
- Maintain LF line endings for shell scripts and CRLF policy for PowerShell through `.gitattributes`.
- Do not silently reformat unrelated files.

## Shell invocation policy

Repository documentation, VS Code tasks, and CI invoke Bash scripts with:

```bash
bash scripts/<path>.sh
```

Do not introduce a second calling convention without a concrete need. Quote paths and variables. Bash entry points should use `#!/usr/bin/env bash` and strict mode where appropriate.

## Required validation

Run the smallest relevant set during development and the full available set before completion.

Baseline repository validation:

```bash
bash scripts/ubuntu/validate-repository.sh
```

Bash lint:

```bash
find scripts -type f -name '*.sh' -print0 \
  | xargs -0 shellcheck -x --severity=warning
```

PowerShell syntax, when `pwsh` is available:

```bash
pwsh ./scripts/ci/check-powershell-syntax.ps1
```

PowerShell analysis, when available:

```powershell
$results = @(Invoke-ScriptAnalyzer -Path scripts -Recurse -Severity Error)
$results | Format-Table -AutoSize
if ($results.Count -gt 0) { exit 1 }
```

Docker-affecting changes, when Docker is available:

```bash
docker build --pull -t codyssey-e1-1-web:codex .
docker rm -f e1-1-codex-test 2>/dev/null || true
docker run -d \
  --name e1-1-codex-test \
  -p 127.0.0.1:18080:80 \
  codyssey-e1-1-web:codex
curl -fsS http://127.0.0.1:18080/ | grep -q 'Codyssey E1-1'
docker rm -f e1-1-codex-test
```

Do not claim that a command passed unless it was actually run successfully. CI does not replace required personal-device evidence.

## Task specifications

Use `docs/codex/TASK_TEMPLATE.md` for substantial work. Place active specifications in `docs/codex/tasks/` with a descriptive kebab-case filename.

A task specification should identify:

- objective and problem statement
- allowed and prohibited scope
- required behavior
- acceptance criteria
- required validation
- personal-device-only work
- expected completion report

## Completion report

Use `docs/codex/CHANGE_REPORT_TEMPLATE.md` or provide the equivalent information:

1. Summary
2. Files changed
3. Rationale
4. Validation commands actually run
5. Validation results
6. Checks not run and reasons
7. Remaining personal-device work
8. Evidence and privacy review
9. Risks or follow-up items

A task is not complete merely because files were edited. It is complete only when its acceptance criteria are met or remaining blockers are reported accurately.
