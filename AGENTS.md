# Codex 저장소 작업 지침

## 목적

이 저장소는 다음 두 실행 환경 중 하나에서 Codyssey E1-1 개발 워크스테이션 미션을 수행하고 검증하기 위한 저장소입니다.

- Windows 11 Pro + WSL2 Ubuntu 24.04 + VS Code Remote-WSL + Docker Desktop WSL Integration
- macOS + OrbStack Ubuntu 24.04 + VS Code Remote-SSH + OrbStack Docker

저장소의 자동화, 템플릿과 `.gitkeep` 파일은 미션 수행을 돕는 구조입니다. 이러한 파일 자체는 미션을 실제로 수행했다는 증거가 아닙니다.

## 적용 범위

이 지침은 저장소 전체에 적용됩니다. 하위 디렉터리에 더 구체적인 `AGENTS.md`가 있으면 해당 디렉터리와 하위 경로에는 그 규칙도 함께 적용합니다. 지침이 충돌하면 현재 사용자 요청이나 안전 요구사항에 어긋나지 않는 범위에서 더 구체적인 하위 규칙을 우선합니다.

## 작성 언어 원칙

- 설명, 작업 원칙, 금지 사항, 수용 기준과 보고 내용은 기본적으로 한국어로 작성합니다.
- 파일명, 경로, 명령어, 코드, 옵션, 환경 변수와 제품·도구의 공식 명칭은 원문 표기를 유지합니다.
- `Docker`, `ShellCheck`, `PowerShell`, `PSScriptAnalyzer`, `PASS`, `WARN`, `FAIL`처럼 기술적으로 통용되는 용어는 억지로 번역하지 않습니다.
- 번역으로 인해 명령의 의미나 식별자가 바뀌지 않도록 합니다.

## 파일 변경 전 필수 확인

저장소 전반에 영향을 주는 작업을 시작하기 전에 최소한 다음 파일을 읽습니다.

1. `README.md`
2. `docs/repository-audit.md`
3. `docs/repository-structure.md`
4. `docs/evidence-index.md`
5. 작업과 관련된 플랫폼 문서
   - `docs/windows-wsl.md`
   - `docs/macos-orbstack-guide.md`
6. 변경 대상 경로에 적용되는 모든 `AGENTS.md`
7. 제공된 경우 `docs/codex/tasks/` 아래의 작업 명세

템플릿의 빈 필드, 예상 파일 경로나 체크리스트 항목을 완료된 결과로 간주하지 않습니다.

## 기준 정보 우선순위

저장소 문서끼리 내용이 다를 때는 다음 순서로 판단합니다.

1. 현재 사용자 요청
2. 적용되는 `AGENTS.md` 지침
3. `docs/codex/tasks/` 아래의 작업 명세
4. 실제 저장소 파일과 실행 가능한 동작
5. 증거 상태를 관리하는 `docs/evidence-index.md`
6. 플랫폼별 상세 가이드
7. `README.md`
8. 기타 설명 문서

실제 명령 출력과 확인된 증거가 설명 문서보다 우선합니다. 문서를 맞추기 위해 관찰된 사실을 임의로 바꾸지 않습니다.

## 반드시 지켜야 할 증거 규칙

- 실행하지 않은 명령 출력, 로그, 스크린샷, 시각, 버전, commit SHA, 경로, 테스트 결과와 트러블슈팅 사례를 만들지 않습니다.
- 연결된 증거가 실제로 존재하고 검토된 경우에만 증거 상태를 `완료`로 변경합니다.
- 생성된 템플릿, `.gitkeep`, CI 출력과 예시를 개인 장비 수행 증거로 표현하지 않습니다.
- 작업에서 안전한 변환을 명시적으로 요구하지 않는 한 실제 사용자 로그와 스크린샷을 보존합니다.
- 예시 출력과 가상 절차는 반드시 예시임을 표시합니다.
- 사용하지 않은 플랫폼 항목은 `완료`가 아니라 `해당 없음`으로 유지합니다.
- 실행하지 못한 검증과 그 이유를 명확히 보고합니다.

## 안전과 개인정보 보호

- 토큰, 비밀번호, 인증 코드, 개인키, 쿠키, `.env.local`과 URL에 포함된 credential을 커밋하지 않습니다.
- 증거에서 불필요한 사용자 홈 경로, 사용자 이름, 이메일, 내부 호스트명과 개인정보를 마스킹합니다.
- 명시적인 승인 없이 `wsl --unregister`, 광범위한 Docker prune, 전용 임시 경로 밖의 재귀 삭제, Docker volume 삭제와 같은 파괴적 명령을 추가하거나 실행하지 않습니다.
- 기존 WSL 배포판, Docker volume과 개인 장비 증거를 덮어쓰지 않습니다.
- 문서화된 근거 없이 기존 secret 검사, 로그 마스킹, dependency pinning과 CI 보안 통제를 약화하지 않습니다.

## 플랫폼 구분 원칙

- Windows/WSL 절차와 macOS/OrbStack 절차를 구분합니다.
- 두 플랫폼을 하나의 필수 실행 흐름으로 합치지 않습니다.
- 두 Ubuntu 환경에서 모두 동작하는 경우에만 공통 Linux 명령을 공통 문서나 `scripts/ubuntu/`에 둡니다.
- 호스트별 동작은 `scripts/windows/` 또는 `scripts/macos/`에 둡니다.
- 작업에서 아키텍처 변경을 명시적으로 요구하지 않는 한 Docker Desktop 사용자가 WSL 내부에 별도의 Docker Engine을 중복 설치하도록 안내하지 않습니다.

## 변경 원칙

- 작업에 필요한 파일만 수정합니다.
- 중복 안내 문서를 새로 만들기보다 기존 기준 문서를 갱신합니다.
- 명령이나 경로가 변경되면 구현, README, VS Code Task, 검증 스크립트와 CI 중 영향받는 항목을 함께 동기화합니다.
- 파일을 추가·이동·삭제하면 `docs/repository-structure.md`와 관련 인덱스를 갱신합니다.
- 필수 파일을 추가한 경우 필요하면 `scripts/ubuntu/validate-repository.sh`도 갱신합니다.
- Markdown 상대 링크를 유효하게 유지합니다.
- `.gitattributes`를 통해 Shell script의 LF와 PowerShell의 CRLF 정책을 유지합니다.
- 작업과 무관한 파일을 조용히 재포맷하지 않습니다.

## Shell script 실행 정책

저장소 문서, VS Code Task와 CI에서는 Bash script를 다음 형식으로 실행합니다.

```bash
bash scripts/<path>.sh
```

구체적인 필요 없이 별도의 실행 방식을 추가하지 않습니다. 경로와 변수를 적절히 인용합니다. Bash 진입점은 필요한 경우 `#!/usr/bin/env bash`와 strict mode를 사용합니다.

## 필수 검증

개발 중에는 작업과 관련된 최소 검증을 실행하고, 완료 전에는 현재 환경에서 가능한 전체 검증을 실행합니다.

저장소 기본 검증:

```bash
bash scripts/ubuntu/validate-repository.sh
```

Bash lint:

```bash
find scripts -type f -name '*.sh' -print0 \
  | xargs -0 shellcheck -x --severity=warning
```

`pwsh`를 사용할 수 있는 경우 PowerShell 구문 검사:

```bash
pwsh ./scripts/ci/check-powershell-syntax.ps1
```

사용 가능한 경우 PowerShell 분석:

```powershell
$results = @(Invoke-ScriptAnalyzer -Path scripts -Recurse -Severity Error)
$results | Format-Table -AutoSize
if ($results.Count -gt 0) { exit 1 }
```

Docker 관련 변경이고 Docker를 사용할 수 있는 경우:

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

실제로 성공적으로 실행하지 않은 명령을 통과했다고 보고하지 않습니다. CI는 필수 개인 장비 증거를 대신하지 않습니다.

## 작업 명세

규모가 있는 작업은 `docs/codex/TASK_TEMPLATE.md`를 사용합니다. 진행 중인 작업 명세는 설명이 명확한 kebab-case 파일명으로 `docs/codex/tasks/`에 둡니다.

작업 명세에는 다음 내용을 포함합니다.

- 목적과 현재 문제
- 허용 범위와 금지 범위
- 필수 동작
- 수용 기준
- 필수 검증
- 개인 장비에서만 가능한 작업
- 완료 보고 형식

## 완료 보고

`docs/codex/CHANGE_REPORT_TEMPLATE.md`를 사용하거나 다음과 동등한 내용을 보고합니다.

1. 요약
2. 변경 파일
3. 변경 이유
4. 실제로 실행한 검증 명령
5. 검증 결과
6. 실행하지 못한 검증과 이유
7. 실제 장비에서 남은 작업
8. 증거와 개인정보 검토
9. 위험 또는 후속 작업

파일을 수정했다는 사실만으로 작업이 완료되는 것은 아닙니다. 수용 기준을 충족했거나 남은 차단 요인을 정확하게 보고했을 때 작업을 종료합니다.
