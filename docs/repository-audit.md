# 저장소 보완 점검

점검 기준: E1-1 미션 수행 가이드, 실제 저장소 구조, Windows 11 Pro + WSL2와 macOS + OrbStack 지원, Docker·Git·증거 재현성.

## 1. 반영 완료

- README와 세부 문서의 역할 분리
- Windows 11 Pro + WSL2 + Ubuntu 24.04 수행 경로
- macOS + OrbStack + Ubuntu 24.04 수행 경로
- WSL 배포판 데이터 위치 `C:\WSL\codyssey-ubuntu24`와 프로젝트 `/home/...` 분리
- VS Code Remote-SSH·Remote-WSL 설정과 단계별 검증 Task
- WSL·Ubuntu·OrbStack·Docker 게시 포트를 확인하는 포트 선택 스크립트
- WSL과 일반 Ubuntu 검증에서 Docker Client·Server 연결 실패를 실제 실패로 처리
- Docker 설정 전 단계에는 명시적인 `--skip-docker` 옵션 제공
- 환경·터미널·권한·Docker 증거 수집 스크립트 분리
- 전체·Docker 제외·Docker 전용 수집 옵션 제공
- Ubuntu와 Windows 증거 로그의 URL 자격정보 및 사용자 홈 경로 자동 마스킹
- 모든 셸 스크립트를 `bash <path>` 방식으로 실행하도록 문서·Task·CI 정책 통일
- Docker `attach`·`exec` 내부 명령과 관찰 양식
- 플랫폼 중립적인 커스텀 웹 페이지
- NGINX·Alpine 버전과 multi-platform index digest 고정
- clean clone 후 build·run·HTTP 검증 절차
- 증거 상태 `미완료`, `진행 중`, `완료`, `해당 없음` 구분
- Ubuntu 24.04 GitHub Actions runner 사용
- 외부 checkout Action을 전체 commit SHA로 고정
- ShellCheck, Markdown 상대 링크, PowerShell parser와 PSScriptAnalyzer 검사
- Docker build와 HTTP smoke test 자동 검증

## 2. 자동화로 대체할 수 없는 남은 작업

다음 항목은 실제 Windows·WSL 또는 macOS·OrbStack 장비에서 직접 수행해야 합니다.

1. 실제 수행 플랫폼 확정
2. OS, WSL 또는 OrbStack, VS Code, Git, Docker 버전 기록
3. 터미널 기본 명령과 권한 변경 전후 실행
4. Docker `attach`와 `exec` 직접 관찰
5. 커스텀 이미지 build와 브라우저 접속
6. 바인드 마운트 파일 변경 전후 확인
7. 컨테이너 삭제 후 볼륨 데이터 확인
8. GitHub·VS Code Source Control 화면 캡처
9. 실제 트러블슈팅 사례 최소 2건 기록
10. clean clone 최종 검증
11. `docs/evidence-index.md` 상태 변경

## 3. 수행 플랫폼 표기

하나의 플랫폼만 수행해도 됩니다.

### Windows에서 수행한 경우

```text
Windows 11 Pro
WSL2 Ubuntu 24.04
VS Code Remote-WSL
Docker Desktop WSL Integration
```

macOS·OrbStack 증거 항목은 `해당 없음`으로 표시합니다.

### macOS에서 수행한 경우

```text
macOS
OrbStack Ubuntu 24.04
VS Code Remote-SSH
OrbStack Docker
```

Windows·WSL 증거 항목은 `해당 없음`으로 표시합니다.

## 4. 단계별 기본 로그 생성

### Windows PowerShell

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\collect-wsl-host-evidence.ps1
```

### WSL 또는 OrbStack Ubuntu

환경·Git:

```bash
bash scripts/ubuntu/collect-environment.sh
```

터미널·권한:

```bash
bash scripts/ubuntu/collect-terminal-permissions.sh
```

Docker:

```bash
bash scripts/ubuntu/collect-docker-evidence.sh
```

전체:

```bash
bash scripts/ubuntu/collect-evidence.sh
```

Docker 설정 전에는 `--skip-docker`, Docker만 다시 수집할 때는 `--docker-only`를 사용합니다. 자동 생성 로그는 마스킹 결과와 실제 내용을 검토한 뒤 커밋합니다.

## 5. 저장소 정적 검증

```bash
bash scripts/ubuntu/validate-repository.sh
```

검사 범위:

- 필수 파일
- 셸과 JSON 문법
- Markdown 상대 링크
- PowerShell parser 문법
- Dockerfile 태그·digest 고정
- 기본 credential URL 패턴

GitHub Actions는 추가로 ShellCheck, PSScriptAnalyzer, Docker build와 HTTP smoke test를 실행합니다.

## 6. 검증 정책

### Docker 포함 최종 환경 검증

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh
bash scripts/ubuntu/verify-remote-workspace.sh
```

Docker CLI가 없거나 Server 연결이 실패하면 검증도 실패합니다.

### Docker 설정 전 사전 검증

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh --skip-docker
bash scripts/ubuntu/verify-remote-workspace.sh --skip-docker
```

이 결과는 Docker까지 포함한 최종 환경 완료 증거로 사용하지 않습니다.

## 7. 최종 판정 기준

현재 구조와 자동화만으로 미션이 완료되는 것은 아닙니다. 다음 조건을 모두 충족했을 때 최종 완료로 판정합니다.

- 실제 로그가 존재하고 명령과 출력이 함께 있음
- 필수 스크린샷이 실제 수행 환경을 보여 줌
- 빈 결과 문서가 실제 값으로 채워짐
- 트러블슈팅 2건 이상이 실제 사례임
- clean clone에서 Docker build·run·HTTP 검증 성공
- 증거 인덱스 상태가 실제 결과와 일치함
- 자동 마스킹 후에도 민감정보가 저장소와 캡처에 없음
