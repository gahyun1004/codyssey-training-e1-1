# 스크립트 작업 지침

이 규칙은 루트 `AGENTS.md`에 추가하여 `scripts/`와 그 하위 경로에 적용합니다.

## 공통 규칙

- 호스트별 로직은 `windows/` 또는 `macos/`에 두고, 공통 Ubuntu 로직은 `ubuntu/`에 둡니다.
- 서로 관련 없는 작업을 하나의 큰 스크립트에 넣기보다 작고 조합 가능한 스크립트를 선호합니다.
- 파괴적인 정리, WSL 배포판 삭제, 광범위한 Docker prune 또는 증거 파일 삭제를 추가하지 않습니다.
- 변수와 경로를 적절히 인용합니다.
- 필수 검증이 실패하면 nonzero exit code를 반환합니다.
- 필요한 경우 `[PASS]`, `[WARN]`, `[FAIL]`, `[NEXT]` 메시지를 명확하게 출력합니다.
- 명령 목적에 필수인 조건이 충족되지 않았는데 warning만 출력하고 최종 성공으로 처리하지 않습니다.
- credential이나 불필요한 개인정보 경로를 로그에 남기지 않습니다.

## Bash

- `#!/usr/bin/env bash`를 사용합니다.
- 문서화된 예외 사유가 없다면 실행 workflow에 `set -Eeuo pipefail`을 사용합니다.
- 문서, VS Code Task와 CI에서는 저장소 script를 `bash scripts/<path>.sh` 형식으로 실행합니다.
- command 목록에는 array를 사용하고 expansion을 적절히 인용합니다.
- 정리가 필요한 임시 파일에는 `mktemp`와 `trap`을 사용합니다.
- 공통 helper는 호출자의 현재 작업 디렉터리가 아니라 script 파일 위치를 기준으로 source합니다.
- 생성되는 증거에는 `scripts/ubuntu/lib/redact.sh`를 통한 마스킹을 유지합니다.
- `bash -n`과 warning severity 이상의 ShellCheck를 통과해야 합니다.

## PowerShell

- parameter나 advanced behavior가 있으면 `[CmdletBinding()]`을 사용합니다.
- `Set-StrictMode -Version Latest`를 사용합니다.
- 실패 시 안전하게 중단해야 하는 workflow에서는 `$ErrorActionPreference = "Stop"`을 사용합니다.
- wildcard 문자 가능성이 있는 경로에는 `-LiteralPath`를 사용합니다.
- WSL 배포판을 자동 unregister하거나 덮어쓰지 않습니다.
- 필요하지 않은 Windows 사용자 이름이나 WSL 홈 사용자 이름을 커밋되는 로그에 출력하지 않습니다.
- PowerShell parser 검사와 Error severity의 PSScriptAnalyzer를 통과해야 합니다.

## 증거 수집 스크립트

- 증거 수집기는 command label과 실제 command output을 함께 기록해야 합니다.
- 로그를 생성할 수는 있지만 `docs/evidence-index.md`를 자동으로 `완료`로 변경하면 안 됩니다.
- Docker service를 사용할 수 없어도 이전 단계의 진행 결과가 손실되지 않도록 환경, 터미널·권한, Docker 수집을 분리합니다.
- 자동 마스킹을 유지하고 사용자가 결과를 직접 검토하도록 안내합니다.
- 스크린샷을 자동 생성하지 않습니다.

## 검증 관련 변경

스크립트를 추가하거나 이름을 변경할 때 다음 항목을 확인합니다.

1. `scripts/README.md` 갱신
2. `docs/repository-structure.md` 갱신
3. 필수 파일이라면 `scripts/ubuntu/validate-repository.sh` 갱신
4. 사용자용 Task가 유용한 경우에만 `.vscode/tasks.json` 갱신
5. CI 범위가 바뀌면 `.github/workflows/validate.yml` 갱신
