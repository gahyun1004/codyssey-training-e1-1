# E1-1 개발 워크스테이션 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 작업실 꾸미기  
> **저장소:** `gahyun1004/codyssey-training-e1-1`  
> **기본 브랜치:** `main`

## 현재 상태

| 구분 | 상태 |
|---|---|
| 저장소 구조·플랫폼별 가이드 | 준비 완료 |
| Windows 11 Pro + WSL2 절차 | 준비 완료 |
| macOS + OrbStack 절차 | 준비 완료 |
| Dockerfile·웹 소스 | 준비 완료 |
| 단계별 증거 수집·자동 마스킹 | 준비 완료 |
| 저장소·Shell·PowerShell·Docker CI 검증 | 준비 완료 |
| Codex 지시·작업 명세·완료 보고 체계 | 준비 완료 |
| 실제 개인 장비 로그·스크린샷 | 미완료 |
| 실제 트러블슈팅 2건 | 미완료 |
| clean clone 최종 결과 기록 | 미완료 |

저장소의 문서, 스크립트, 자동화와 `.gitkeep`은 수행을 돕는 구조입니다. **실제로 실행하지 않은 결과를 완료로 표시하지 않습니다.**

---

## 목차

1. [수행 환경 선택](#1-수행-환경-선택)
2. [문서와 저장소 구조](#2-문서와-저장소-구조)
3. [Windows 11 Pro + WSL2 시작](#3-windows-11-pro--wsl2-시작)
4. [macOS + OrbStack 시작](#4-macos--orbstack-시작)
5. [VS Code 검증과 증거 수집](#5-vs-code-검증과-증거-수집)
6. [공통 미션 수행](#6-공통-미션-수행)
7. [Codex 작업 지시](#7-codex-작업-지시)
8. [Git·GitHub 제출](#8-gitgithub-제출)
9. [Clean clone 최종 검증](#9-clean-clone-최종-검증)
10. [평가 전 체크리스트](#10-평가-전-체크리스트)

---

# 1. 수행 환경 선택

두 환경 중 **실제로 사용하는 하나의 환경**을 선택합니다.

| 호스트 | Linux 환경 | VS Code | Docker | 상세 가이드 |
|---|---|---|---|---|
| Windows 11 Pro | WSL2 Ubuntu 24.04 | Remote-WSL | Docker Desktop WSL Integration | [Windows·WSL 가이드](docs/windows-wsl.md) |
| macOS | OrbStack Ubuntu 24.04 | Remote-SSH | OrbStack Docker | [macOS·OrbStack 가이드](docs/macos-orbstack-guide.md) |

사용하지 않은 플랫폼의 증거 상태는 `미완료`가 아니라 `해당 없음`으로 표시합니다.

```text
Windows에서 수행 → macOS·OrbStack 항목: 해당 없음
macOS에서 수행   → Windows·WSL 항목: 해당 없음
```

현재 반영 사항과 남은 수동 작업은 [저장소 보완 점검](docs/repository-audit.md), 증거 상태는 [증거 인덱스](docs/evidence-index.md)에서 관리합니다.

---

# 2. 문서와 저장소 구조

## 사람·평가자용 문서

- [저장소 보완 점검](docs/repository-audit.md)
- [저장소 구조](docs/repository-structure.md)
- [증거 인덱스](docs/evidence-index.md)
- [실행 환경 기록](docs/environment.md)
- [터미널 및 권한 실습](docs/terminal-and-permissions.md)
- [Docker 운영](docs/docker-operations.md)
- [커스텀 이미지 설계](docs/image-design.md)
- [포트 매핑 및 바인드 마운트](docs/port-and-bind.md)
- [Docker 볼륨 영속성](docs/volume-persistence.md)
- [최종 검증 결과](docs/test-results.md)
- [트러블슈팅](docs/troubleshooting.md)
- [로그 작성 규칙](docs/logs/README.md)
- [스크린샷 규칙](docs/screenshots/README.md)

## Codex 작업 문서

- [저장소 전체 Codex 규칙](AGENTS.md)
- [Codex 작업 운영 가이드](docs/codex/README.md)
- [작업 명세 템플릿](docs/codex/TASK_TEMPLATE.md)
- [공통 수용 기준](docs/codex/ACCEPTANCE_CRITERIA.md)
- [변경 보고 템플릿](docs/codex/CHANGE_REPORT_TEMPLATE.md)
- [작업 명세 디렉터리 안내](docs/codex/tasks/README.md)

변경 대상이 `docs/`, `scripts/`, `.github/` 아래라면 해당 디렉터리의 `AGENTS.md`도 함께 적용합니다.

## 핵심 구조

```text
codyssey-training-e1-1/
├── AGENTS.md
├── README.md
├── Dockerfile
├── .github/
│   ├── AGENTS.md
│   └── workflows/validate.yml
├── .vscode/
├── scripts/
│   ├── AGENTS.md
│   ├── ci/
│   ├── macos/
│   ├── windows/
│   └── ubuntu/
├── site/index.html
├── bind-test/index.html
├── practice/
└── docs/
    ├── AGENTS.md
    ├── codex/
    ├── logs/
    └── screenshots/
```

전체 트리는 [저장소 구조](docs/repository-structure.md)에 있습니다.

## 셸 스크립트 실행 정책

문서, VS Code Task와 GitHub Actions는 셸 스크립트를 다음 형식으로 실행합니다.

```bash
bash scripts/ubuntu/<script-name>.sh
```

Git 실행 비트에 의존하지 않고 동일한 실행 방식을 사용합니다.

---

# 3. Windows 11 Pro + WSL2 시작

상세 절차는 [Windows·WSL 가이드](docs/windows-wsl.md)를 기준으로 수행합니다.

## 3.1 설치 위치

| 구분 | 값 |
|---|---|
| WSL 배포판 이름 | `Ubuntu-24.04` |
| Windows 설치 루트 | `C:\WSL` |
| 설치 디렉터리 이름 | `codyssey-ubuntu24` |
| Ubuntu 데이터 위치 | `C:\WSL\codyssey-ubuntu24` |
| 프로젝트 위치 | `/home/<사용자>/codyssey-training/codyssey-training-e1-1` |

Git·Docker·권한 실습은 `/mnt/c/...`가 아니라 WSL Linux 홈의 `/home/...`에서 수행합니다.

## 3.2 WSL 설치

관리자 권한 PowerShell:

```powershell
wsl.exe --install --no-distribution
```

재시작 후:

```powershell
wsl.exe --update
wsl.exe --set-default-version 2
wsl.exe --version
wsl.exe --status
wsl.exe --help | Select-String -SimpleMatch "--location"

New-Item -ItemType Directory -Force -Path "C:\WSL"
wsl.exe --list --online

wsl.exe --install `
  --distribution Ubuntu-24.04 `
  --location "C:\WSL\codyssey-ubuntu24" `
  --no-launch

wsl.exe --set-default Ubuntu-24.04
wsl.exe -d Ubuntu-24.04
```

`Ubuntu-24.04`가 이미 설치되어 있다면 덮어쓰거나 자동으로 unregister하지 않습니다.

설치 보조 스크립트:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

## 3.3 Ubuntu 저장소

```bash
sudo apt update
sudo apt install -y \
  ca-certificates curl wget git gnupg nano vim tree jq tar unzip zip

mkdir -p ~/codyssey-training
cd ~/codyssey-training
git clone https://github.com/gahyun1004/codyssey-training-e1-1.git
cd codyssey-training-e1-1

git status -sb
git remote -v
pwd
```

## 3.4 VS Code와 Docker

Windows PowerShell:

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

WSL Ubuntu 저장소 루트:

```bash
code .
```

Docker Desktop:

```text
Settings
→ General
→ Use the WSL 2 based engine

Settings
→ Resources
→ WSL Integration
→ Ubuntu-24.04 활성화
→ Apply & Restart
```

Docker 설정 전 WSL 사전 검증:

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh --skip-docker
```

Docker 포함 최종 검증:

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh
```

기본 검증은 Docker CLI 또는 Server 연결이 실패하면 종료 코드 1로 실패합니다.

---

# 4. macOS + OrbStack 시작

상세 설치 과정은 [macOS·OrbStack 가이드](docs/macos-orbstack-guide.md)를 따릅니다.

```bash
orb version
orb status
orb list
orb info codyssey-training
ssh codyssey-training@orb
```

Mac Terminal에서 저장소를 VS Code Remote-SSH로 엽니다.

```bash
code --new-window \
  --remote "ssh-remote+codyssey-training@orb" \
  "$(ssh codyssey-training@orb \
  'cd ~/codyssey-training/codyssey-training-e1-1 && pwd -P')"
```

저장소 스크립트 사용:

```bash
bash scripts/open-vscode-remote.sh
```

Docker 설정 전 사전 검증:

```bash
bash scripts/ubuntu/verify-remote-workspace.sh --skip-docker
```

Docker 포함 최종 검증:

```bash
bash scripts/ubuntu/verify-remote-workspace.sh
```

---

# 5. VS Code 검증과 증거 수집

## 5.1 VS Code Task

```text
Ctrl/Command + Shift + P
→ Tasks: Run Task
```

| Task | 용도 |
|---|---|
| `E1-1: Verify Ubuntu Remote Workspace` | OrbStack·일반 Ubuntu와 Docker 검증 |
| `E1-1: Verify WSL Ubuntu Workspace` | WSL2 Ubuntu와 Docker 검증 |
| `E1-1: Verify WSL Before Docker` | Docker 설정 전 WSL 사전 검증 |
| `E1-1: Collect Environment Evidence` | OS·Git·workspace 로그 생성 |
| `E1-1: Collect Terminal and Permission Evidence` | 터미널·권한 로그 생성 |
| `E1-1: Collect Docker Evidence` | Docker·hello-world 로그 생성 |
| `E1-1: Collect All Basic Evidence` | 모든 기본 로그 순차 생성 |
| `E1-1: Collect Evidence Without Docker` | Docker 제외 기본 로그 생성 |
| `E1-1: Validate Repository` | 구조·문법·링크·Dockerfile·Codex 지시 계층 검증 |

## 5.2 Windows 호스트 로그

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\collect-wsl-host-evidence.ps1
```

생성 파일:

```text
docs/logs/windows-wsl-host.txt
```

## 5.3 단계별 Ubuntu 로그

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

Docker 제외 또는 Docker 전용:

```bash
bash scripts/ubuntu/collect-evidence.sh --skip-docker
bash scripts/ubuntu/collect-evidence.sh --docker-only
```

수집 스크립트는 URL 자격정보와 사용자 홈 경로를 기본 마스킹합니다. **자동 마스킹은 보조 장치이므로 커밋 전에 로그 전체를 직접 검토합니다.**

`attach`, 커스텀 build, 포트, 바인드 마운트, 볼륨과 화면 캡처는 직접 수행합니다.

---

# 6. 공통 미션 수행

## 6.1 터미널과 권한

세부 명령과 관찰 항목은 [터미널 및 권한 실습](docs/terminal-and-permissions.md)에 기록합니다.

```text
755 = 소유자 rwx, 그룹 r-x, 기타 r-x
644 = 소유자 rw-, 그룹 r--, 기타 r--
```

## 6.2 Docker attach와 exec

```bash
docker rm -f e1-1-attach 2>/dev/null || true
docker run -dit --name e1-1-attach ubuntu:24.04 bash
docker attach e1-1-attach
```

컨테이너 내부:

```bash
pwd
ls -la
echo "inside ubuntu container"
cat /etc/os-release
```

컨테이너를 종료하지 않고 분리합니다.

```text
Ctrl + P
Ctrl + Q
```

호스트 Ubuntu 터미널:

```bash
docker exec e1-1-attach \
  bash -lc 'echo "exec creates another process"; ps -ef'
```

관찰 결과는 [Docker 운영](docs/docker-operations.md)에 기록합니다.

## 6.3 커스텀 이미지 build

현재 Dockerfile은 버전과 multi-platform index digest를 고정합니다.

```dockerfile
FROM nginx:1.30.4-alpine3.24@sha256:97d490c12ba55b4946b01546d1c3ed324e8d41ab1c9fcb2a616aa470620e5b46
```

```bash
{
  echo '$ docker build --pull -t codyssey-e1-1-web:1.0 .'
  docker build --pull -t codyssey-e1-1-web:1.0 .
  docker image inspect codyssey-e1-1-web:1.0 \
    --format 'ID={{.Id}} CREATED={{.Created}} SIZE={{.Size}}'
} 2>&1 | tee docs/logs/docker-build.txt
```

설계 이유는 [커스텀 이미지 설계](docs/image-design.md)에 기록합니다.

## 6.4 포트 매핑

```bash
HOST_PORT="$(bash scripts/ubuntu/select-port.sh)"
printf 'HOST_PORT=%s\n' "$HOST_PORT" > .env.local
source .env.local

docker rm -f e1-1-web 2>/dev/null || true
docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0

{
  docker ps --filter name=e1-1-web
  docker port e1-1-web
  docker logs e1-1-web
  curl -fsS "http://localhost:${HOST_PORT}"
} 2>&1 | tee docs/logs/port-mapping.txt
```

브라우저에서 `http://localhost:<HOST_PORT>`에 접속하고 주소창과 페이지를 함께 캡처합니다.

## 6.5 바인드 마운트

```bash
source .env.local
docker rm -f e1-1-web e1-1-bind 2>/dev/null || true

docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:${HOST_PORT}:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:1.30.4-alpine3.24@sha256:97d490c12ba55b4946b01546d1c3ed324e8d41ab1c9fcb2a616aa470620e5b46

curl -fsS "http://localhost:${HOST_PORT}"
```

`bind-test/index.html`을 수정한 뒤 컨테이너를 재시작하지 않고 다시 확인합니다.

```bash
{
  docker inspect e1-1-bind \
    --format '{{range .Mounts}}{{.Type}} {{.Source}} -> {{.Destination}}{{println}}{{end}}'
  curl -fsS "http://localhost:${HOST_PORT}"
} 2>&1 | tee docs/logs/bind-mount-after.txt
```

## 6.6 Docker 볼륨 영속성

```bash
{
  docker volume create e1-1-data

  docker rm -f e1-1-volume-1 2>/dev/null || true
  docker run -d \
    --name e1-1-volume-1 \
    -v e1-1-data:/data \
    ubuntu:24.04 sleep infinity

  docker exec e1-1-volume-1 \
    bash -lc 'echo "persistent data" > /data/result.txt; cat /data/result.txt'

  docker rm -f e1-1-volume-1

  docker rm -f e1-1-volume-2 2>/dev/null || true
  docker run -d \
    --name e1-1-volume-2 \
    -v e1-1-data:/data \
    ubuntu:24.04 sleep infinity

  docker exec e1-1-volume-2 cat /data/result.txt
} 2>&1 | tee docs/logs/volume-persistence.txt
```

마지막 명령에서 `persistent data`가 출력되어야 합니다.

## 6.7 증거

필수 로그와 화면 파일명은 [로그 작성 규칙](docs/logs/README.md)과 [스크린샷 규칙](docs/screenshots/README.md)을 따릅니다.

실제로 발생한 오류 또는 시행착오를 [트러블슈팅](docs/troubleshooting.md)에 최소 2건 기록합니다. 예시 문구를 실제 사례처럼 작성하지 않습니다.

---

# 7. Codex 작업 지시

## 7.1 기본 원칙

Codex에 저장소 작업을 맡길 때 README 전체를 단독 지시문으로 사용하지 않습니다. 루트 [AGENTS.md](AGENTS.md)를 전체 작업 계약으로 사용하고, 작업별 요구사항은 `docs/codex/tasks/`에 작성합니다.

다음 경계를 유지합니다.

- Codex가 할 수 있는 일: 문서·스크립트·CI 수정, 정적 검증, 사용 가능한 환경에서 Docker build와 smoke test
- 실제 사용자 장비에서 해야 하는 일: Windows/WSL 또는 macOS/OrbStack 로그, 스크린샷, 실제 트러블슈팅과 최종 개인 장비 검증
- Codex는 실제 장비 증거를 생성하거나 `docs/evidence-index.md`를 근거 없이 완료 처리하지 않음

## 7.2 작업 명세 작성

```bash
cp \
  docs/codex/TASK_TEMPLATE.md \
  docs/codex/tasks/<작업명>.md
```

명세에는 다음을 작성합니다.

- 목적과 현재 문제
- 허용 범위와 금지 범위
- 필수 요구사항
- 수용 기준
- 실행할 검증
- 실제 장비에서만 가능한 항목
- 완료 보고 형식

## 7.3 Codex 지시 예시

```text
루트 AGENTS.md와 docs/codex/tasks/<작업명>.md를 먼저 읽으세요.
변경 대상에 적용되는 하위 AGENTS.md를 모두 준수하세요.
허용 범위 안에서 작업하고 검증 명령을 실제로 실행하세요.
실행하지 못한 검증과 실제 장비에서 남은 작업을 숨기지 말고,
docs/codex/CHANGE_REPORT_TEMPLATE.md 형식으로 결과를 보고하세요.
```

## 7.4 Codex 작업 완료 기준

공통 기준은 [Codex 공통 수용 기준](docs/codex/ACCEPTANCE_CRITERIA.md)을 따릅니다.

최소 검증:

```bash
bash scripts/ubuntu/validate-repository.sh
```

변경 영향에 따라 ShellCheck, PowerShell 검사, Docker build와 HTTP smoke test를 추가합니다. 실행하지 않은 검증은 성공으로 표현하지 않습니다.

Codex 작업 완료와 E1-1 개인 장비 미션 완료는 별개입니다.

---

# 8. Git·GitHub 제출

GitHub CLI는 선택 사항입니다. `git clone`, `git push`와 GitHub 웹으로도 수행할 수 있습니다.

```bash
git switch main
git pull --ff-only origin main
git switch -c feat/e1-1-workstation
```

실제 증거를 검토한 뒤:

```bash
git status -sb
git diff

git add \
  AGENTS.md README.md Dockerfile \
  .dockerignore .gitignore .gitattributes \
  .github/ .vscode/ scripts/ site/ bind-test/ practice/ docs/

git diff --cached
git commit -m "Feat: complete E1-1 workstation mission"
git push -u origin feat/e1-1-workstation
```

토큰, 비밀번호, 인증 코드, 개인키, `.env.local`은 커밋하지 않습니다.

---

# 9. Clean clone 최종 검증

```bash
RETEST_DIR="$HOME/codyssey-retest/e1-1-$(date +%Y%m%d-%H%M%S)"

git clone \
  https://github.com/gahyun1004/codyssey-training-e1-1.git \
  "$RETEST_DIR"
cd "$RETEST_DIR"

git status -sb
git rev-parse HEAD
bash scripts/ubuntu/validate-repository.sh

docker build --pull -t codyssey-e1-1-web:retest .
HOST_PORT="$(bash scripts/ubuntu/select-port.sh 18080 18081 28080)"

docker run -d \
  --name e1-1-retest \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:retest

curl -fsS "http://localhost:${HOST_PORT}"
docker rm -f e1-1-retest
```

실제 경로, commit SHA, build·run·HTTP 결과는 [최종 검증 결과](docs/test-results.md)에 기록합니다.

GitHub Actions의 `Validate E1-1 Repository` workflow는 다음을 검사합니다.

- Ubuntu 24.04 runner
- checkout Action의 전체 commit SHA 고정
- 필수 파일과 Codex 지시 계층
- 셸·JSON과 Markdown 상대 링크
- ShellCheck
- PowerShell parser와 PSScriptAnalyzer
- Dockerfile 태그·digest 고정
- Docker build와 HTTP smoke test

자동 검증은 개인 장비의 화면 증거를 대신하지 않습니다.

---

# 10. 평가 전 체크리스트

## 환경

- [ ] Windows·WSL 또는 macOS·OrbStack 중 실제 수행 플랫폼 확정
- [ ] 사용하지 않은 플랫폼을 `해당 없음`으로 표시
- [ ] Ubuntu 24.04, bash, workspace와 Git root 확인
- [ ] Docker Client·Server 연결 포함 최종 검증 성공

## 미션

- [ ] 터미널 기본 명령 수행
- [ ] 파일·디렉터리 권한 변경 전후 기록
- [ ] Docker 이미지·컨테이너·로그·stats 확인
- [ ] hello-world 실행
- [ ] Ubuntu 컨테이너 내부 명령 수행
- [ ] `attach`와 `exec` 차이 관찰
- [ ] digest가 고정된 커스텀 Dockerfile build
- [ ] 베이스 이미지와 커스텀 항목 설명
- [ ] 포트 매핑과 브라우저 접속
- [ ] 바인드 마운트 변경 전후 확인
- [ ] 컨테이너 삭제 후 볼륨 데이터 확인

## 증거와 제출

- [ ] 단계별 로그 생성 및 자동 마스킹 결과 검토
- [ ] 필수 스크린샷 저장
- [ ] 실제 트러블슈팅 2건 이상
- [ ] Git·GitHub·VS Code 연동 증거
- [ ] clean clone build·run·HTTP 검증
- [ ] GitHub Actions 검증 결과 확인
- [ ] `docs/evidence-index.md` 상태가 실제 결과와 일치
- [ ] 민감정보 미포함

## Codex 운영

- [ ] 루트 `AGENTS.md`와 적용되는 하위 `AGENTS.md` 확인
- [ ] 작업별 명세를 `docs/codex/tasks/`에 작성
- [ ] 허용·금지 범위와 수용 기준 명시
- [ ] 실제 실행한 검증과 미실행 검증을 구분해 보고
- [ ] Codex 작업 완료와 개인 장비 미션 완료를 구분

현재 저장소는 **수행 구조, Codex 지시 계층과 검증 자동화가 준비된 상태**입니다. E1-1 최종 완료 여부는 실제 장비에서 생성한 로그, 스크린샷, 트러블슈팅과 clean clone 결과로 판단합니다.
