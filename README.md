# E1-1 개발 워크스테이션 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 작업실 꾸미기  
> **저장소:** `gahyun1004/codyssey-training-e1-1`  
> **기본 브랜치:** `main`

## 현재 상태

| 구분 | 상태 |
|---|---|
| 저장소 구조·가이드 | 준비 완료 |
| Windows 11 Pro + WSL2 절차 | 준비 완료 |
| macOS + OrbStack 절차 | 준비 완료 |
| Dockerfile·웹 소스 | 준비 완료 |
| 자동 구조·Docker smoke test | 준비 완료 |
| 실제 개인 장비 로그·스크린샷 | 미완료 |
| 실제 트러블슈팅 2건 | 미완료 |
| clean clone 최종 결과 기록 | 미완료 |

저장소에 있는 문서, 스크립트, 자동화와 `.gitkeep`은 수행을 돕는 구조입니다. **실제 명령을 실행하지 않은 결과를 완료로 표시하지 않습니다.**

---

## 목차

1. [수행 환경 선택](#1-수행-환경-선택)
2. [문서와 저장소 구조](#2-문서와-저장소-구조)
3. [Windows 11 Pro + WSL2 시작](#3-windows-11-pro--wsl2-시작)
4. [macOS + OrbStack 시작](#4-macos--orbstack-시작)
5. [VS Code 검증과 로그 수집](#5-vs-code-검증과-로그-수집)
6. [공통 미션 수행](#6-공통-미션-수행)
7. [증거와 결과 문서](#7-증거와-결과-문서)
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

자세한 판정 기준은 [저장소 보완 점검](docs/repository-audit.md)과 [증거 인덱스](docs/evidence-index.md)를 확인합니다.

---

# 2. 문서와 저장소 구조

## 주요 문서

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

## 핵심 구조

```text
codyssey-training-e1-1/
├── README.md
├── Dockerfile
├── .github/workflows/validate.yml
├── .vscode/
├── scripts/
│   ├── macos/
│   ├── windows/
│   │   ├── setup-wsl.ps1
│   │   ├── open-vscode-wsl.ps1
│   │   └── collect-wsl-host-evidence.ps1
│   └── ubuntu/
│       ├── verify-remote-workspace.sh
│       ├── verify-wsl-workspace.sh
│       ├── select-port.sh
│       ├── collect-evidence.sh
│       └── validate-repository.sh
├── site/index.html
├── bind-test/index.html
├── practice/
└── docs/
    ├── logs/
    └── screenshots/
```

전체 트리는 [docs/repository-structure.md](docs/repository-structure.md)에 있습니다.

---

# 3. Windows 11 Pro + WSL2 시작

## 3.1 설치 위치

| 구분 | 값 |
|---|---|
| WSL 배포판 이름 | `Ubuntu-24.04` |
| Windows 설치 루트 | `C:\WSL` |
| 설치 디렉터리 이름 | `codyssey-ubuntu24` |
| Ubuntu 데이터 위치 | `C:\WSL\codyssey-ubuntu24` |
| 프로젝트 위치 | `/home/<사용자>/codyssey-training/codyssey-training-e1-1` |

Ubuntu 배포판 데이터와 프로젝트 작업 폴더를 혼동하지 않습니다. Git·Docker·권한 실습은 `/mnt/c/...`가 아니라 WSL Linux 홈의 `/home/...`에서 수행합니다.

## 3.2 WSL 설치

관리자 권한 Windows Terminal 또는 PowerShell에서 실행합니다.

```powershell
wsl.exe --install --no-distribution
```

재시작이 요구되면 Windows를 재시작합니다. 이후:

```powershell
wsl.exe --update
wsl.exe --set-default-version 2
wsl.exe --version
wsl.exe --status
wsl.exe --help | Select-String -SimpleMatch "--location"
```

설치 루트를 만들고 온라인 배포판을 확인합니다.

```powershell
New-Item -ItemType Directory -Force -Path "C:\WSL"
Test-Path "C:\WSL"
wsl.exe --list --online
```

Ubuntu 24.04를 지정 위치에 설치합니다.

```powershell
wsl.exe --install `
  --distribution Ubuntu-24.04 `
  --location "C:\WSL\codyssey-ubuntu24" `
  --no-launch

wsl.exe --set-default Ubuntu-24.04
wsl.exe -d Ubuntu-24.04
```

`Ubuntu-24.04`가 이미 설치되어 있다면 덮어쓰거나 자동으로 unregister하지 않습니다.

## 3.3 설치 스크립트

저장소의 PowerShell 스크립트에 접근할 수 있는 경우:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

## 3.4 WSL 저장소 clone

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

## 3.5 VS Code Remote-WSL

Windows에서 WSL 확장을 설치합니다.

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

WSL Ubuntu의 저장소 루트에서:

```bash
code .
```

성공 기준:

- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- Explorer 최상단이 `codyssey-training-e1-1`
- 새 터미널이 bash
- `pwd`와 Git root가 저장소 루트

## 3.6 Docker Desktop

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

WSL Ubuntu에서 확인합니다.

```bash
docker --version
docker context show
docker version
docker info
docker run --rm hello-world
```

Docker Desktop을 사용하는 경우 WSL 안에 Docker Engine을 중복 설치하지 않습니다.

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

Mac에서 저장소 스크립트에 접근할 수 있는 경우:

```bash
bash scripts/open-vscode-remote.sh
```

성공 기준:

- VS Code 왼쪽 아래 `SSH: codyssey-training@orb`
- Ubuntu 24.04
- bash
- `pwd`와 Git root가 저장소 루트
- Docker Client·Server 연결 성공

---

# 5. VS Code 검증과 로그 수집

## 5.1 Task

```text
Ctrl/Command + Shift + P
→ Tasks: Run Task
```

| Task | 용도 |
|---|---|
| `E1-1: Verify Ubuntu Remote Workspace` | OrbStack·일반 Ubuntu 검증 |
| `E1-1: Verify WSL Ubuntu Workspace` | WSL2 Ubuntu 검증 |
| `E1-1: Collect Basic Evidence Logs` | 환경·터미널·권한·Docker 기본 로그 생성 |
| `E1-1: Validate Repository` | 구조·셸·JSON 정적 검증 |

## 5.2 Windows 호스트 로그

Windows PowerShell에서:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\collect-wsl-host-evidence.ps1
```

생성 파일:

```text
docs/logs/windows-wsl-host.txt
```

## 5.3 Ubuntu 기본 로그

WSL 또는 OrbStack Ubuntu 저장소 루트에서:

```bash
bash scripts/ubuntu/collect-evidence.sh
```

생성 범위:

- 환경
- 터미널 기본 명령
- 파일·디렉터리 권한
- Docker 기본 운영
- hello-world
- WSL 환경일 경우 WSL·Docker 로그

`attach`, 커스텀 build, 포트, 바인드 마운트, 볼륨과 화면 캡처는 직접 수행합니다.

---

# 6. 공통 미션 수행

## 6.1 터미널과 권한

기본 로그는 수집 스크립트로 만들 수 있습니다. 세부 명령과 결과 기록은 [터미널 및 권한 실습](docs/terminal-and-permissions.md)에 정리합니다.

권한 해석:

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

컨테이너 내부에서:

```bash
pwd
ls -la
echo "inside ubuntu container"
cat /etc/os-release
```

종료하지 않고 분리:

```text
Ctrl + P
Ctrl + Q
```

호스트 Ubuntu 터미널에서:

```bash
docker exec e1-1-attach \
  bash -lc 'echo "exec creates another process"; ps -ef'
```

관찰 결과는 [Docker 운영](docs/docker-operations.md)에 기록합니다.

## 6.3 커스텀 이미지 build

현재 Dockerfile은 버전을 명시한 공식 이미지 `nginx:1.30.4-alpine3.24`를 사용합니다.

```bash
{
  echo '$ docker build -t codyssey-e1-1-web:1.0 .'
  docker build -t codyssey-e1-1-web:1.0 .
  docker image inspect codyssey-e1-1-web:1.0 \
    --format 'ID={{.Id}} CREATED={{.Created}} SIZE={{.Size}}'
} 2>&1 | tee docs/logs/docker-build.txt
```

설계 이유는 [커스텀 이미지 설계](docs/image-design.md)에 기록합니다.

## 6.4 포트 선택과 접속

```bash
HOST_PORT="$(scripts/ubuntu/select-port.sh)"
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
  nginx:1.30.4-alpine3.24

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
  echo '$ docker volume create e1-1-data'
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

---

# 7. 증거와 결과 문서

## 필수 로그

```text
docs/logs/environment.txt
docs/logs/terminal-basic.txt
docs/logs/permissions.txt
docs/logs/docker-basic.txt
docs/logs/hello-world.txt
docs/logs/docker-build.txt
docs/logs/port-mapping.txt
docs/logs/bind-mount-after.txt
docs/logs/volume-persistence.txt
```

Windows·WSL 추가 로그:

```text
docs/logs/windows-wsl-host.txt
docs/logs/windows-wsl-environment.txt
docs/logs/windows-wsl-docker.txt
```

## 필수 화면

- OS·WSL 또는 OrbStack 환경
- VS Code Remote 상태와 Git root·branch
- 터미널과 권한 변경 전후
- Docker Client·Server와 hello-world
- `attach`와 `exec`
- 이미지 build
- 브라우저 주소창과 포트
- 바인드 마운트 변경 전후
- 볼륨 영속성
- GitHub·VS Code Source Control

파일명과 마스킹 규칙은 [스크린샷 안내](docs/screenshots/README.md)를 따릅니다.

## 트러블슈팅

실제로 발생한 오류 또는 시행착오를 [docs/troubleshooting.md](docs/troubleshooting.md)에 최소 2건 작성합니다. 예시 문구를 실제 사례처럼 작성하지 않습니다.

---

# 8. Git·GitHub 제출

## 8.1 GitHub CLI

GitHub CLI는 선택 사항입니다. `gh`가 없더라도 `git clone`, `git push`와 GitHub 웹에서 Pull Request 생성으로 수행할 수 있습니다.

## 8.2 브랜치와 커밋

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
  README.md Dockerfile .dockerignore .gitignore .gitattributes \
  .github/ .vscode/ scripts/ site/ bind-test/ practice/ docs/

git diff --cached
git commit -m "Feat: complete E1-1 workstation mission"
git push -u origin feat/e1-1-workstation
```

토큰, 비밀번호, 인증 코드, 개인키, `.env.local`은 커밋하지 않습니다.

---

# 9. Clean clone 최종 검증

새 폴더에서 기본 브랜치를 다시 clone합니다.

```bash
RETEST_DIR="$HOME/codyssey-retest/e1-1-$(date +%Y%m%d-%H%M%S)"

git clone \
  https://github.com/gahyun1004/codyssey-training-e1-1.git \
  "$RETEST_DIR"
cd "$RETEST_DIR"

git status -sb
git rev-parse HEAD
bash scripts/ubuntu/validate-repository.sh

docker build -t codyssey-e1-1-web:retest .
HOST_PORT="$(scripts/ubuntu/select-port.sh 18080 18081 28080)"

docker run -d \
  --name e1-1-retest \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:retest

curl -fsS "http://localhost:${HOST_PORT}"
docker rm -f e1-1-retest
```

실제 경로, commit SHA, build·run·HTTP 결과는 [최종 검증 결과](docs/test-results.md)에 기록합니다.

GitHub Actions의 `Validate E1-1 Repository` workflow도 구조, 셸·JSON, Docker build와 HTTP smoke test를 검증합니다. 자동 검증은 개인 장비의 화면 증거를 대신하지 않습니다.

---

# 10. 평가 전 체크리스트

## 환경

- [ ] Windows·WSL 또는 macOS·OrbStack 중 실제 수행 플랫폼 확정
- [ ] 사용하지 않은 플랫폼을 `해당 없음`으로 표시
- [ ] Ubuntu 24.04, bash, workspace와 Git root 확인
- [ ] Docker Client·Server 연결 확인

## 미션

- [ ] 터미널 기본 명령 수행
- [ ] 파일·디렉터리 권한 변경 전후 기록
- [ ] Docker 이미지·컨테이너·로그·stats 확인
- [ ] hello-world 실행
- [ ] Ubuntu 컨테이너 내부 명령 수행
- [ ] `attach`와 `exec` 차이 관찰
- [ ] 커스텀 Dockerfile build
- [ ] 베이스 이미지와 커스텀 항목 설명
- [ ] 포트 매핑과 브라우저 접속
- [ ] 바인드 마운트 변경 전후 확인
- [ ] 컨테이너 삭제 후 볼륨 데이터 확인

## 증거와 제출

- [ ] 필수 로그 생성 및 검토
- [ ] 필수 스크린샷 저장
- [ ] 실제 트러블슈팅 2건 이상
- [ ] Git·GitHub·VS Code 연동 증거
- [ ] clean clone build·run·HTTP 검증
- [ ] `docs/evidence-index.md` 상태가 실제 결과와 일치
- [ ] 민감정보 미포함

현재 저장소는 **수행 구조와 검증 자동화가 준비된 상태**입니다. 최종 완료 여부는 실제 장비에서 생성한 로그, 스크린샷, 트러블슈팅과 clean clone 결과로 판단합니다.
