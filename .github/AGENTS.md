# GitHub 자동화 작업 지침

이 규칙은 루트 `AGENTS.md`에 추가하여 `.github/`와 그 하위 경로에 적용합니다.

## Workflow 안전 원칙

- workflow permission은 필요한 최소 수준으로 유지합니다.
- 외부 Action은 전체 commit SHA로 고정하고 가까운 위치에 버전 주석을 유지합니다.
- 명시적인 승인 없이 secret, write permission, 배포 credential 또는 외부 publishing을 추가하지 않습니다.
- 저장소가 특정 환경에 의존하면 이동하는 alias보다 `ubuntu-24.04`처럼 재현 가능한 runner label을 우선합니다.
- job에 합리적인 timeout을 설정합니다.
- 임시 container나 파일이 남을 수 있는 경우 cleanup step에 `if: always()`를 사용합니다.

## 검증 정책

저장소 CI는 해당되는 범위에서 다음 검사를 계속 포함해야 합니다.

- 필수 저장소 구조
- Bash 구문과 ShellCheck
- JSON 구문
- Markdown 상대 링크
- PowerShell parser와 PSScriptAnalyzer
- Dockerfile pinning 통제
- 기본 credential pattern 검사
- Docker build와 HTTP smoke test

CI를 통과시키기 위해 검증 단계를 단순히 제거하지 않습니다. 근본 원인을 수정하거나 해당 검사가 더 이상 적용되지 않는 이유를 문서화합니다.

## 증거 경계

GitHub Actions는 저장소의 재현성을 검증합니다. Windows/WSL 또는 macOS/OrbStack 절차가 사용자 개인 장비에서 실제로 수행되었다는 증거는 아닙니다. CI 결과만으로 개인 장비 증거 상태를 갱신하지 않습니다.

## Pull request

PR 설명에는 다음 내용을 포함합니다.

- 목적과 범위
- 주요 변경 파일
- 실행한 검증
- 실행하지 못한 검증과 이유
- 실제 장비에서 남은 작업
- 증거와 개인정보에 미치는 영향
