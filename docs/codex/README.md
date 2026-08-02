# Codex 작업 운영 가이드

이 디렉터리는 Codex에 저장소 작업을 맡길 때 사용하는 명세와 보고 형식을 관리합니다. 사람용 미션 수행 절차는 루트 `README.md`, Codex의 전체 작업 규칙은 루트 `AGENTS.md`를 기준으로 합니다.

## 작성 언어

- 작업 설명, 원칙, 금지 사항, 수용 기준과 결과 보고는 기본적으로 한국어로 작성합니다.
- 파일명, 경로, 명령어, 코드, 옵션, 환경 변수와 제품·도구의 공식 명칭은 원문 표기를 유지합니다.
- 기술 용어를 번역하면 의미가 불분명해지는 경우 `Docker`, `ShellCheck`, `PowerShell`, `PSScriptAnalyzer`, `build`, `smoke test`, `clean clone` 등의 표기를 그대로 사용할 수 있습니다.
- 한국어 설명과 원문 기술 식별자를 함께 사용해 사용자의 가독성과 Codex의 명령 정확성을 모두 유지합니다.

## 문서 역할

| 파일 | 역할 |
|---|---|
| [`../../AGENTS.md`](../../AGENTS.md) | 저장소 전체 Codex 운영 규칙 |
| [`TASK_TEMPLATE.md`](TASK_TEMPLATE.md) | 작업별 지시서 작성 양식 |
| [`ACCEPTANCE_CRITERIA.md`](ACCEPTANCE_CRITERIA.md) | 공통 완료 판정 기준 |
| [`CHANGE_REPORT_TEMPLATE.md`](CHANGE_REPORT_TEMPLATE.md) | 작업 종료 보고 양식 |
| [`tasks/README.md`](tasks/README.md) | 실제 작업 명세의 위치와 관리 규칙 |

## 권장 사용 흐름

1. 작업 요청자가 `TASK_TEMPLATE.md`를 복사해 `tasks/`에 작업 명세를 작성합니다.
2. Codex에 다음과 같이 지시합니다.

```text
루트 AGENTS.md와 docs/codex/tasks/<작업명>.md를 먼저 읽고,
허용 범위와 수용 기준 안에서 작업하세요.
관련 AGENTS.md를 모두 준수하고 검증을 실제로 실행한 뒤,
docs/codex/CHANGE_REPORT_TEMPLATE.md 형식으로 결과를 보고하세요.
```

3. Codex는 현재 사용자 요청, 적용되는 `AGENTS.md`, 작업 명세와 실제 저장소 상태를 확인합니다.
4. 변경 후 관련 검증을 실행합니다.
5. 실행하지 못한 검증은 성공으로 간주하지 않고 이유를 보고합니다.
6. 실제 장비에서만 가능한 로그·스크린샷·트러블슈팅은 사용자가 수행합니다.

## 지시서 작성 원칙

좋은 작업 명세는 다음을 분명히 합니다.

- 무엇을 해결해야 하는지
- 어떤 파일과 기능을 수정할 수 있는지
- 무엇을 수정하면 안 되는지
- 성공한 결과가 어떤 모습인지
- 어떤 검증을 실행해야 하는지
- 실제 Windows/WSL 또는 macOS/OrbStack 장비에서만 가능한 부분이 무엇인지

다음과 같은 포괄적 지시는 피합니다.

```text
레포를 알아서 완성해 줘.
```

대신 다음처럼 범위와 결과를 지정합니다.

```text
AGENTS.md와 docs/codex/tasks/improve-wsl-evidence.md를 읽고 작업하세요.
Windows WSL 증거 수집 스크립트와 관련 문서만 수정하고,
실제 장비 증거는 생성하지 마세요.
정적 검증과 PowerShell 검사를 실행한 뒤 결과를 보고하세요.
```

## 상태와 증거 구분

Codex가 구현할 수 있는 항목:

- 문서와 스크립트 수정
- 정적 검증
- CI 수정
- Docker가 사용 가능한 환경에서 build와 smoke test
- 예시와 템플릿 작성

Codex가 실제 사용자 장비 없이 완료할 수 없는 항목:

- Windows 11 Pro 제품 정보 증거
- 실제 WSL 설치 상태와 설치 폴더 증거
- Docker Desktop 설정 화면
- VS Code Remote 상태 화면
- 개인 장비 명령 로그
- 실제로 발생한 트러블슈팅 사례
- 사용자의 최종 clean clone 검증 화면

이 경계를 작업 명세와 결과 보고에 반드시 반영합니다.

## 문서 충돌 방지

- 동일 절차를 여러 작업 명세에 복사하지 않습니다.
- 공통 규칙은 `AGENTS.md` 또는 `ACCEPTANCE_CRITERIA.md`에 둡니다.
- 완료된 작업 명세가 현재 구현과 충돌하면 갱신하거나 보관 상태를 명시합니다.
- 작업 명세는 증거 파일이 아니며 `docs/evidence-index.md`의 완료 상태를 바꾸지 않습니다.
