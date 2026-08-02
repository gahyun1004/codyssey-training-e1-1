# Documentation instructions

These rules apply to `docs/` and its descendants, in addition to the root `AGENTS.md`.

## Documentation integrity

- Describe only behavior supported by the repository or by verified execution results.
- Do not fill blank result fields with plausible values.
- Label examples, placeholders, and expected output clearly.
- Do not infer a platform, version, date, path, port, commit SHA, or success state from a template.
- Keep `docs/evidence-index.md` synchronized with real evidence only.
- A file path listed in documentation is not proof that the file exists or contains valid evidence.

## Evidence files

- Treat files under `docs/logs/` and `docs/screenshots/` as user evidence.
- Do not fabricate, reconstruct, or visually imitate evidence.
- Do not replace a real failure log with a clean example.
- Preserve errors that are relevant to `docs/troubleshooting.md`.
- Redact credentials and unnecessary personal information without changing the technical meaning.
- Do not mark CI output as Windows/WSL or macOS/OrbStack personal-device evidence.

## Structure and links

- Use relative links for repository files.
- Update `docs/repository-structure.md` when files are added, moved, or removed.
- Update `docs/repository-audit.md` when a repository-level control is added or retired.
- Avoid copying full procedures into multiple documents. Keep `README.md` as the central workflow and platform guides as detailed references.
- Run the repository Markdown link checker after changing links or headings.

## Status language

Use these evidence states consistently:

- `미완료`: required evidence or result is not available
- `진행 중`: work has started, but acceptance criteria are not met
- `완료`: evidence exists, was checked, and supports the result
- `해당 없음`: the item does not apply to the selected execution platform

Do not use `완료` for templates, scripts, planned procedures, or unverified files.

## Codex task documents

Files under `docs/codex/tasks/` are work specifications, not evidence. They must state:

- the objective
- scope boundaries
- acceptance criteria
- validation requirements
- personal-device-only steps
- reporting format

Archive or update obsolete task instructions rather than leaving conflicting active specifications.
