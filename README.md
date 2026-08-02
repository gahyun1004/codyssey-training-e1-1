# E1-1 개발 워크스테이션 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 작업실 꾸미기  
> **저장소:** `gahyun1004/codyssey-training-e1-1`  
> **기본 브랜치:** `main`

## 지원 환경

- macOS + OrbStack + Ubuntu 24.04 LTS
- Windows 11 Pro + WSL2 + Ubuntu 24.04 LTS

이 README는 현재 저장소의 폴더, 스크립트, VS Code 설정, Docker 실습 및 증거 문서를 연결하는 중앙 가이드입니다.

> 저장소에 준비된 문서, 스크립트, `.gitkeep`은 수행 환경을 위한 구조입니다. 실제 로그와 스크린샷은 본인이 명령을 실행한 뒤 생성해야 하며, 실행하지 않은 항목을 완료로 표시하지 않습니다.

---

## 목차

1. [미션 완료 기준](#1-미션-완료-기준)
2. [환경 선택](#2-환경-선택)
3. [문서 안내](#3-문서-안내)
4. [현재 저장소 구조](#4-현재-저장소-구조)
5. [Windows 11 Pro + WSL2 빠른 시작](#5-windows-11-pro--wsl2-빠른-시작)
6. [macOS + OrbStack 빠른 시작](#6-macos--orbstack-빠른-시작)
7. [공통 VS Code·Ubuntu 검증](#7-공통-vs-codeubuntu-검증)
8. [공통 미션 수행](#8-공통-미션-수행)
9. [로그·스크린샷·트러블슈팅](#9-로그스크린샷트러블슈팅)
10. [Git·GitHub 제출 절차](#10-gitgithub-제출-절차)
11. [대표 오류 해결표](#11-대표-오류-해결표)
12. [평가 전 최종 체크리스트](#12-평가-전-최종-체크리스트)

---

# 1. 미션 완료 기준

평가자는 기본 브랜치 `main`에서 다음 결과를 확인할 수 있어야 합니다.

- [ ] Ubuntu 24.04 작업 환경을 사용했다.
- [ ] VS Code 원격 창에서 Ubuntu bash와 저장소 workspace가 확인된다.
- [ ] 터미널 기본 명령과 파일·디렉터리 권한 변경 전후가 기록되어 있다.
- [ ] Docker Client와 Server 연결, 이미지·컨테이너 운영 결과가 있다.
- [ ] `attach`와 `exec`의 차이를 실제로 관찰했다.
- [ ] 직접 작성한 `Dockerfile`과 `site/index.html`이 있다.
- [ ] 베이스 이미지 선택 이유와 커스텀 항목을 설명했다.
- [ ] 포트 매핑, 바인드 마운트, Docker 볼륨 영속성을 검증했다.
- [ ] Git 설정, branch, remote, commit, push 및 GitHub 연동 증거가 있다.
- [ ] 실제 오류 또는 시행착오를 트러블슈팅 문서에 2건 이상 기록했다.
- [ ] clean clone에서 Docker 빌드와 문서 링크를 다시 검증했다.
- [ ] 토큰, 비밀번호, 인증 코드, 개인키 등 민감정보가 없다.

---

# 2. 환경 선택

| 호스트 환경 | Linux 환경 | VS Code 연결 | 기본 실행 방식 | 상세 문서 |
|---|---|---|---|---|
| macOS | OrbStack Ubuntu 24.04 | Remote-SSH | Mac에서 `code --remote ...` | [macOS·OrbStack 가이드](docs/macos-orbstack-guide.md) |
| Windows 11 Pro | WSL2 Ubuntu 24.04 | Remote-WSL | WSL Ubuntu에서 `code .` | [Windows·WSL 가이드](docs/windows-wsl.md) |

두 환경 모두 `.vscode/settings.json`을 통해 새 통합 터미널을 `/bin/bash -l`과 `${workspaceFolder}`에서 시작합니다.

## 실행 위치 표시

| 표시 | 실행 위치 |
|---|---|
| **[macOS]** | Mac Terminal |
| **[PowerShell 관리자]** | 관리자 권한 Windows Terminal 또는 PowerShell |
| **[PowerShell]** | 일반 Windows Terminal 또는 PowerShell |
| **[WSL Ubuntu]** | WSL2 Ubuntu 24.04 |
| **[OrbStack Ubuntu]** | OrbStack Ubuntu 24.04 |
| **[VS Code Ubuntu]** | Remote-SSH 또는 Remote-WSL로 연결된 통합 터미널 |
| **[컨테이너]** | Docker 컨테이너 내부 |

---

# 3. 문서 안내

## 플랫폼별 가이드

- [Windows 11 Pro + WSL2 + Ubuntu 24.04](docs/windows-wsl.md)
- [macOS + OrbStack + Ubuntu 24.04](docs/macos-orbstack-guide.md)

## 미션 수행 문서

- [저장소 구조](docs/repository-structure.md)
- [증거 인덱스](docs/evidence-index.md)
- [실행 환경 기록](docs/environment.md)
- [터미널 및 권한 실습](docs/terminal-and-permissions.md)
- [Docker 기본 운영](docs/docker-operations.md)
- [커스텀 이미지 설계](docs/image-design.md)
- [포트 매핑 및 바인드 마운트](docs/port-and-bind.md)
- [볼륨 영속성](docs/volume-persistence.md)
- [최종 검증 결과](docs/test-results.md)
- [트러블슈팅](docs/troubleshooting.md)
- [로그 작성 규칙](docs/logs/README.md)
- [스크린샷 규칙](docs/screenshots/README.md)

## 설정·스크립트 안내

- [VS Code workspace 설정](.vscode/README.md)
- [운영체제별 스크립트](scripts/README.md)
- [터미널·권한 실습 폴더](practice/README.md)

---

# 4. 현재 저장소 구조

```text
codyssey-training-e1-1/
├── README.md
├── Dockerfile
├── .dockerignore
├── .gitignore
├── .gitattributes
├── .vscode/
│   ├── README.md
│   ├── settings.json
│   ├── extensions.json
│   └── tasks.json
├── scripts/
│   ├── README.md
│   ├── open-vscode-remote.sh
│   ├── macos/
│   │   └── open-vscode-remote.sh
│   ├── windows/
│   │   ├── setup-wsl.ps1
│   │   └── open-vscode-wsl.ps1
│   └── ubuntu/
│       ├── verify-remote-workspace.sh
│       ├── verify-wsl-workspace.sh
│       └── select-port.sh
├── site/
│   └── index.html
├── bind-test/
│   └── index.html
├── practice/
│   ├── README.md
│   ├── terminal/.gitkeep
│   └── permissions/
│       ├── .gitkeep
│       └── permission-dir/.gitkeep
└── docs/
    ├── macos-orbstack-guide.md
    ├── windows-wsl.md
    ├── evidence-index.md
    ├── repository-structure.md
    ├── environment.md
    ├── terminal-and-permissions.md
    ├── docker-operations.md
    ├── image-design.md
    ├── port-and-bind.md
    ├── volume-persistence.md
    ├── test-results.md
    ├── troubleshooting.md
    ├── logs/README.md
    └── screenshots/
        ├── README.md
        ├── environment/.gitkeep
        ├── windows-wsl/.gitkeep
        ├── terminal/.gitkeep
        ├── permissions/.gitkeep
        ├── docker/.gitkeep
        ├── port-mapping/.gitkeep
        ├── bind-mount/.gitkeep
        ├── volume/.gitkeep
        ├── github/.gitkeep
        └── vscode/.gitkeep
```

## 주요 경로 역할

| 경로 | 역할 |
|---|---|
| `Dockerfile` | `site/` 콘텐츠를 포함하는 NGINX 이미지 정의 |
| `site/` | 커스텀 이미지에 포함되는 정적 웹 콘텐츠 |
| `bind-test/` | 바인드 마운트 변경 전후 확인용 콘텐츠 |
| `practice/` | 터미널 기본 조작과 권한 실습 |
| `.vscode/` | Ubuntu bash, workspace cwd, Remote 확장 및 검증 Task |
| `scripts/macos/` | OrbStack Remote-SSH 실행 |
| `scripts/windows/` | WSL 설치와 Remote-WSL 실행 보조 |
| `scripts/ubuntu/` | Ubuntu·WSL workspace 검증과 포트 선택 |
| `docs/logs/` | 실제 명령과 출력 결과 저장 |
| `docs/screenshots/` | 환경·Docker·GitHub·VS Code 화면 증거 저장 |
| `.gitattributes` | Windows와 Linux 사이의 줄바꿈 차이 제어 |

`.gitkeep`은 빈 디렉터리를 Git에 유지하기 위한 파일이며 수행 증거가 아닙니다.

---

# 5. Windows 11 Pro + WSL2 빠른 시작

## 5.1 설치 이름과 경로

WSL 배포판 이름과 Windows 설치 디렉터리 이름은 서로 다릅니다.

| 구분 | 값 |
|---|---|
| WSL 배포판 이름 | `Ubuntu-24.04` |
| 설치 루트 | `C:\WSL` |
| 설치 디렉터리 이름 | `codyssey-ubuntu24` |
| Ubuntu 데이터 위치 | `C:\WSL\codyssey-ubuntu24` |
| 프로젝트 작업 위치 | `/home/<사용자>/codyssey-training/codyssey-training-e1-1` |

`C:\WSL\codyssey-ubuntu24`에는 Ubuntu 가상 디스크와 시스템 데이터가 저장됩니다. Git·Docker·권한 실습용 프로젝트는 WSL Linux 홈의 `/home/...`에 clone합니다.

## 5.2 WSL 기능과 Ubuntu 24.04 설치

Windows Terminal 또는 PowerShell을 관리자 권한으로 실행합니다.

```powershell
# [PowerShell 관리자]
wsl.exe --install --no-distribution
```

재시작이 요구되면 Windows를 재시작합니다. WSL이 이미 설치되어 있다면 위 단계는 건너뜁니다.

```powershell
# [PowerShell 관리자]
wsl.exe --update
wsl.exe --set-default-version 2
wsl.exe --version
wsl.exe --status
wsl.exe --help | Select-String -SimpleMatch "--location"
```

`--location`이 표시되는지 확인한 뒤 설치 루트를 만듭니다.

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

첫 실행 시 Linux 사용자 이름과 비밀번호를 설정합니다.

> `Ubuntu-24.04`가 이미 설치되어 있다면 덮어쓰거나 자동으로 unregister하지 않습니다. 기존 배포판 이동은 백업·export·unregister·import가 필요한 별도 작업입니다.

## 5.3 설치 보조 스크립트

Windows에서 저장소의 스크립트에 접근할 수 있는 경우 다음 명령을 사용할 수 있습니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

스크립트 기본값:

```text
Distribution          = Ubuntu-24.04
InstallRoot           = C:\WSL
InstallDirectoryName  = codyssey-ubuntu24
InstallPath           = C:\WSL\codyssey-ubuntu24
```

다른 설치 루트를 지정하는 예시:

```powershell
.\scripts\windows\setup-wsl.ps1 `
  -Distribution "Ubuntu-24.04" `
  -InstallRoot "D:\WSL" `
  -InstallDirectoryName "codyssey-ubuntu24"
```

## 5.4 설치 상태 검증

```powershell
# [PowerShell]
Test-Path "C:\WSL\codyssey-ubuntu24"
Get-ChildItem -Force "C:\WSL\codyssey-ubuntu24"
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
```

정상 기준:

- `Test-Path "C:\WSL\codyssey-ubuntu24"` 결과가 `True`
- 배포판 이름이 `Ubuntu-24.04`
- `VERSION` 값이 `2`

WSL 1이면 다음을 실행합니다.

```powershell
wsl.exe --set-default-version 2
wsl.exe --set-version Ubuntu-24.04 2
wsl.exe --set-default Ubuntu-24.04
```

## 5.5 Ubuntu 확인과 저장소 clone

```powershell
# [PowerShell]
wsl.exe -d Ubuntu-24.04
```

```bash
# [WSL Ubuntu]
cat /etc/os-release
uname -a
whoami
printf 'HOME=%s\n' "$HOME"
printf 'SHELL=%s\n' "$SHELL"
printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-}"
```

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

권장 경로:

```text
/home/<WSL사용자>/codyssey-training/codyssey-training-e1-1
```

## 5.6 VS Code Remote-WSL

Windows에서 WSL 확장을 설치합니다.

```powershell
# [PowerShell]
code --version
code --install-extension ms-vscode-remote.remote-wsl
```

기본 방식은 WSL Ubuntu의 저장소 폴더에서 실행하는 것입니다.

```bash
# [WSL Ubuntu]
cd ~/codyssey-training/codyssey-training-e1-1
code .
```

Windows에서 저장소의 PowerShell 스크립트에 접근할 수 있는 경우 다음 명령도 사용할 수 있습니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\open-vscode-wsl.ps1
```

다른 WSL 배포판 또는 저장소 경로:

```powershell
.\scripts\windows\open-vscode-wsl.ps1 `
  -Distribution "Ubuntu-24.04" `
  -RepositoryPath "codyssey-training/codyssey-training-e1-1"
```

성공 기준:

- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- Explorer 최상단 폴더가 `codyssey-training-e1-1`
- 새 터미널 프로세스가 `bash`
- `pwd`와 Git root가 현재 저장소 폴더

## 5.7 Docker Desktop WSL Integration

Docker Desktop에서 다음 항목을 설정합니다.

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
# [WSL Ubuntu]
docker --version
docker context show
docker version
docker info
docker run --rm hello-world
```

Docker Desktop을 사용하는 경우 WSL Ubuntu에 별도 Docker Engine을 중복 설치하지 않습니다.

## 5.8 WSL workspace 검증

```text
Ctrl + Shift + P
→ Tasks: Run Task
→ E1-1: Verify WSL Ubuntu Workspace
```

직접 실행:

```bash
scripts/ubuntu/verify-wsl-workspace.sh
```

이 스크립트는 WSL2, Ubuntu 24.04, bash, workspace, Git root 및 Docker 연결 상태를 확인합니다. 저장소가 `/mnt/...`에 있으면 WSL Linux 홈 사용을 권장하는 경고를 출력합니다.

---

# 6. macOS + OrbStack 빠른 시작

전체 설치·검증 절차는 [docs/macos-orbstack-guide.md](docs/macos-orbstack-guide.md)를 기준으로 수행합니다.

## 6.1 OrbStack Ubuntu와 SSH 확인

```bash
# [macOS]
orb version
orb status
orb list
orb info codyssey-training
ssh codyssey-training@orb
```

Ubuntu에서 확인합니다.

```bash
# [OrbStack Ubuntu]
cat /etc/os-release
uname -a
whoami
pwd
printf 'SHELL=%s\n' "$SHELL"
docker version
docker info
```

## 6.2 VS Code Remote-SSH 실행

```text
Command(⌘) + Space
→ Spotlight에 Terminal 입력
→ Return
```

```bash
# [macOS]
code --new-window \
  --remote "ssh-remote+codyssey-training@orb" \
  "$(ssh codyssey-training@orb \
  'cd ~/codyssey-training/codyssey-training-e1-1 && pwd -P')"
```

Mac에서 이 저장소의 스크립트에 접근할 수 있는 경우:

```bash
bash scripts/open-vscode-remote.sh
```

`open-vscode-remote.sh`는 실제 Mac 스크립트인 `scripts/macos/open-vscode-remote.sh`를 호출합니다.

성공 기준:

- VS Code 왼쪽 아래 `SSH: codyssey-training@orb`
- Explorer 최상단 폴더가 `codyssey-training-e1-1`
- Ubuntu 24.04
- 새 터미널 프로세스가 `bash`
- `pwd`와 Git root가 현재 저장소 폴더

---

# 7. 공통 VS Code·Ubuntu 검증

## 7.1 workspace 설정

`.vscode/settings.json`은 다음 항목을 설정합니다.

- Linux 기본 프로필: `/bin/bash -l`
- 자동화 작업 셸: `/bin/bash -l`
- 터미널 시작 폴더: `${workspaceFolder}`
- 분할 터미널 시작 폴더: workspace root
- shell integration: 활성화

`.vscode/extensions.json`은 다음 확장을 추천합니다.

```json
{
  "recommendations": [
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-wsl"
  ]
}
```

## 7.2 검증 Task

| Task | 실행 스크립트 | 대상 환경 |
|---|---|---|
| `E1-1: Verify Ubuntu Remote Workspace` | `scripts/ubuntu/verify-remote-workspace.sh` | OrbStack·일반 Ubuntu 원격 환경 |
| `E1-1: Verify WSL Ubuntu Workspace` | `scripts/ubuntu/verify-wsl-workspace.sh` | WSL2 Ubuntu 24.04 |

Task 실행:

```text
Ctrl/Command + Shift + P
→ Tasks: Run Task
→ 현재 환경에 맞는 E1-1 검증 Task 선택
```

## 7.3 수동 검증

```bash
# [VS Code Ubuntu]
cat /etc/os-release
printf 'SHELL=%s\n' "$SHELL"
ps -p $$ -o comm=
pwd
git rev-parse --show-toplevel
git branch --show-current
docker version
```

정상 기준:

- Ubuntu 24.04
- `SHELL=/bin/bash`
- 프로세스가 `bash`
- `pwd`와 Git root가 동일
- Docker Client와 Server 정보가 모두 표시됨

---

# 8. 공통 미션 수행

## 8.1 터미널 기본 조작

```bash
cd ~/codyssey-training/codyssey-training-e1-1
mkdir -p practice/terminal
cd practice/terminal

pwd
ls
ls -la
touch sample.txt
echo "Codyssey E1-1" > sample.txt
cat sample.txt
cp sample.txt sample-copy.txt
mv sample-copy.txt renamed.txt
mkdir archive
mv renamed.txt archive/
ls -la archive
rm archive/renamed.txt
rmdir archive
realpath sample.txt
```

기록 문서: [docs/terminal-and-permissions.md](docs/terminal-and-permissions.md)

## 8.2 파일과 디렉터리 권한

```bash
cd ~/codyssey-training/codyssey-training-e1-1/practice/permissions

touch permission-file.txt
ls -l permission-file.txt
chmod 644 permission-file.txt
ls -l permission-file.txt
chmod 600 permission-file.txt
ls -l permission-file.txt

mkdir -p permission-dir
ls -ld permission-dir
chmod 755 permission-dir
ls -ld permission-dir
chmod 700 permission-dir
ls -ld permission-dir
```

- `755`: 소유자 `rwx`, 그룹 `r-x`, 기타 `r-x`
- `644`: 소유자 `rw-`, 그룹 `r--`, 기타 `r--`

## 8.3 Docker 기본 운영

```bash
cd ~/codyssey-training/codyssey-training-e1-1

docker --version
docker version
docker info
docker images
docker ps
docker ps -a
docker stats --no-stream
docker run --rm hello-world
```

기록 문서: [docs/docker-operations.md](docs/docker-operations.md)

## 8.4 attach와 exec

```bash
docker rm -f e1-1-attach 2>/dev/null || true
docker run -dit --name e1-1-attach ubuntu:24.04 bash
docker attach e1-1-attach
```

컨테이너를 종료하지 않고 분리합니다.

```text
Ctrl + P
Ctrl + Q
```

```bash
docker exec e1-1-attach \
  bash -lc 'echo "exec creates another process"'
```

- `attach`: 컨테이너의 기존 기본 프로세스에 연결
- `exec`: 실행 중인 컨테이너에 새 프로세스를 생성

## 8.5 커스텀 Docker 이미지 빌드

현재 `Dockerfile`은 `nginx:alpine`을 베이스로 `site/`를 `/usr/share/nginx/html/`에 복사합니다.

```bash
docker build -t codyssey-e1-1-web:1.0 . \
  2>&1 | tee docs/logs/docker-build.txt

docker images | grep codyssey-e1-1-web
```

베이스 이미지 선택 이유, `LABEL`, `COPY`, `EXPOSE`의 목적은 [docs/image-design.md](docs/image-design.md)에 기록합니다.

## 8.6 사용 가능한 포트 선택

```bash
HOST_PORT="$(scripts/ubuntu/select-port.sh)"
printf 'HOST_PORT=%s\n' "$HOST_PORT"
printf 'HOST_PORT=%s\n' "$HOST_PORT" > .env.local
```

기본 후보는 `8080`, `8081`, `18080`, `18081`입니다. 다른 후보를 지정할 수도 있습니다.

```bash
HOST_PORT="$(scripts/ubuntu/select-port.sh 8088 18088 28088)"
```

## 8.7 포트 매핑 검증

```bash
source .env.local

docker rm -f e1-1-web 2>/dev/null || true
docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0

docker ps
docker logs e1-1-web
docker port e1-1-web
curl "http://localhost:${HOST_PORT}"
```

브라우저 주소:

```text
http://localhost:선택한포트
```

## 8.8 바인드 마운트 검증

```bash
source .env.local
docker rm -f e1-1-web e1-1-bind 2>/dev/null || true

docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:${HOST_PORT}:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine

curl "http://localhost:${HOST_PORT}"
```

`bind-test/index.html`을 수정한 후 컨테이너를 재실행하지 않고 다시 `curl` 또는 브라우저로 확인합니다.

기록 문서: [docs/port-and-bind.md](docs/port-and-bind.md)

## 8.9 Docker 볼륨 영속성

```bash
docker volume create e1-1-data

docker rm -f e1-1-volume-1 2>/dev/null || true
docker run -d \
  --name e1-1-volume-1 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-1 \
  bash -lc 'echo "persistent data" > /data/result.txt && cat /data/result.txt'

docker rm -f e1-1-volume-1

docker rm -f e1-1-volume-2 2>/dev/null || true
docker run -d \
  --name e1-1-volume-2 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-2 cat /data/result.txt
```

마지막 명령에서 `persistent data`가 출력되어야 합니다.

기록 문서: [docs/volume-persistence.md](docs/volume-persistence.md)

---

# 9. 로그·스크린샷·트러블슈팅

## 9.1 증거 상태

[docs/evidence-index.md](docs/evidence-index.md)에서 플랫폼별 수행 항목, 문서, 로그, 스크린샷 및 상태를 관리합니다.

- 실제 수행 전: `미완료`
- 실제 명령·출력·화면 증거 확인 후: `완료`
- `.gitkeep`: 폴더 구조 유지용이며 완료 증거가 아님

## 9.2 로그 파일

공통 로그:

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

Windows·WSL 로그:

```text
docs/logs/windows-wsl-host.txt
docs/logs/windows-wsl-environment.txt
docs/logs/windows-wsl-docker.txt
```

## 9.3 스크린샷 폴더

```text
docs/screenshots/environment/
docs/screenshots/windows-wsl/
docs/screenshots/terminal/
docs/screenshots/permissions/
docs/screenshots/docker/
docs/screenshots/port-mapping/
docs/screenshots/bind-mount/
docs/screenshots/volume/
docs/screenshots/github/
docs/screenshots/vscode/
```

Windows·WSL 필수 화면 예시:

- Windows 11 Pro 버전과 빌드
- `wsl.exe --version`
- `wsl.exe --list --verbose`의 `Ubuntu-24.04`, `VERSION 2`
- `C:\WSL\codyssey-ubuntu24` 설치 폴더
- Docker Desktop의 Ubuntu 24.04 WSL Integration
- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- Ubuntu 24.04, bash, `pwd`, Git root와 branch

## 9.4 트러블슈팅 기록

[docs/troubleshooting.md](docs/troubleshooting.md)에 실제 오류 또는 시행착오를 최소 2건 기록합니다.

```markdown
## TS-01

- 문제:
- 발생 환경:
- 실행 위치:
- 실행 명령:
- 오류 메시지 원문:
- 원인 가설:
- 확인 과정:
- 실제 원인:
- 해결 방법 또는 대안:
- 해결 확인:
- 재발 방지:
```

## 9.5 보안 확인

```bash
git status -sb
git diff
git diff --cached
git grep -n -i -E 'token|password|secret|private.?key' || true
```

토큰, 비밀번호, 인증 코드, 개인키, `.env.local`은 커밋하지 않습니다. 사용자 이름, 이메일 및 내부 경로가 화면이나 로그에 포함되면 필요한 부분을 마스킹합니다.

---

# 10. Git·GitHub 제출 절차

## 10.1 작업 브랜치

```bash
git switch main
git pull --ff-only origin main
git switch -c feat/e1-1-workstation
```

이미 같은 브랜치가 있다면 새로 만들지 말고 해당 브랜치로 전환합니다.

## 10.2 변경 확인과 커밋

```bash
git status -sb
git diff

git add \
  README.md \
  Dockerfile \
  .dockerignore \
  .gitignore \
  .gitattributes \
  .vscode/ \
  scripts/ \
  site/ \
  bind-test/ \
  practice/ \
  docs/

git diff --cached
git commit -m "Feat: complete E1-1 workstation mission"
```

실제 로그와 스크린샷은 생성·검토 후 별도 커밋으로 구분할 수 있습니다.

## 10.3 push와 Pull Request

```bash
git push -u origin feat/e1-1-workstation
```

```bash
gh pr create \
  --base main \
  --head feat/e1-1-workstation \
  --title "Feat: complete E1-1 workstation mission" \
  --body "Ubuntu 24.04, VS Code 원격 환경, Docker, Git/GitHub 및 증거 검증을 완료했습니다."
```

실제 검증이 완료된 경우에만 완료 문구를 사용합니다.

## 10.4 clean clone과 main 최종 검증

```bash
RETEST_DIR="$HOME/codyssey-retest/e1-1-$(date +%Y%m%d-%H%M%S)"

gh repo clone gahyun1004/codyssey-training-e1-1 "$RETEST_DIR"
cd "$RETEST_DIR"

git status -sb
test -f README.md
test -f Dockerfile
test -f .vscode/tasks.json
test -x scripts/ubuntu/verify-remote-workspace.sh
test -x scripts/ubuntu/verify-wsl-workspace.sh
test -f site/index.html
test -f bind-test/index.html
test -f docs/evidence-index.md

docker build -t codyssey-e1-1-web:retest .
```

최종 결과는 [docs/test-results.md](docs/test-results.md)에 기록합니다.

---

# 11. 대표 오류 해결표

| 증상 | 확인 | 조치 |
|---|---|---|
| `--location`이 표시되지 않음 | `wsl.exe --version`, `wsl.exe --help` | WSL·Windows·Store 업데이트 후 재시작 |
| `C:\WSL\codyssey-ubuntu24`가 비어 있지 않음 | `Get-ChildItem -Force` | 기존 데이터를 확인하고 다른 빈 폴더 사용 |
| `Ubuntu-24.04`가 이미 설치됨 | `wsl.exe --list --verbose` | 덮어쓰기·자동 unregister 금지, 별도 백업·이관 |
| WSL 배포판이 VERSION 1 | `wsl.exe --list --verbose` | `wsl.exe --set-version Ubuntu-24.04 2` |
| VS Code가 Windows 로컬 창으로 열림 | 왼쪽 아래 상태, `pwd` | WSL Ubuntu 저장소에서 `code .` 실행 |
| WSL 저장소가 `/mnt/c/...`에 있음 | `pwd` | `/home/<사용자>/...`에 clone하여 실습 |
| `ssh ...@orb` 실패 | `orb status`, `orb info` | OrbStack과 Ubuntu 머신 실행 확인 |
| Mac의 `code` 명령이 없음 | `command -v code` | VS Code CLI PATH 설치 또는 앱 내부 CLI 사용 |
| 터미널이 bash가 아님 | `ps -p $$ -o comm=` | Workspace Trust 후 기존 터미널을 닫고 재생성 |
| 검증 Task 실행 실패 | 스크립트 권한 | `chmod +x scripts/ubuntu/*.sh` |
| Docker Server 연결 실패 | `docker version`, `docker info` | OrbStack Docker 또는 Docker Desktop WSL Integration 확인 |
| 포트 충돌 | `docker ps`, 포트 선택 스크립트 | `scripts/ubuntu/select-port.sh`로 다른 포트 선택 |
| 바인드 변경이 반영되지 않음 | `pwd`, `docker inspect` | 저장소 루트와 마운트 경로 확인 |
| 볼륨 데이터가 없음 | `docker volume ls` | 두 컨테이너가 동일한 볼륨 이름을 사용하는지 확인 |
| push 거절 | `git fetch`, `git status -sb` | 강제 push하지 말고 원격 변경 확인 |

---

# 12. 평가 전 최종 체크리스트

## Windows 11 Pro + WSL2

- [ ] Windows 11 Pro 정보 기록
- [ ] WSL 설치·업데이트 및 기본 버전 2 설정
- [ ] `--location` 지원 확인
- [ ] 설치 디렉터리 이름 `codyssey-ubuntu24` 사용
- [ ] Ubuntu 데이터 위치 `C:\WSL\codyssey-ubuntu24` 확인
- [ ] `wsl.exe --list --verbose`에서 `Ubuntu-24.04`, VERSION 2 확인
- [ ] 프로젝트를 WSL Linux 홈 `/home/...`에 clone
- [ ] VS Code 왼쪽 아래 `WSL: Ubuntu-24.04` 확인
- [ ] Docker Desktop WSL Integration 활성화
- [ ] WSL 검증 Task 실행

## macOS + OrbStack

- [ ] OrbStack Ubuntu 24.04 머신 확인
- [ ] `ssh codyssey-training@orb` 접속 성공
- [ ] Mac에서 `code --remote`로 Ubuntu 저장소 열기
- [ ] VS Code 왼쪽 아래 `SSH: codyssey-training@orb` 확인
- [ ] Ubuntu 원격 workspace 검증 Task 실행

## 저장소 구조

- [ ] `Dockerfile`, `.dockerignore`, `.gitignore`, `.gitattributes` 존재
- [ ] `.vscode/settings.json`, `extensions.json`, `tasks.json` 존재
- [ ] macOS·Windows·Ubuntu 스크립트가 역할별로 구분됨
- [ ] `site/index.html`, `bind-test/index.html` 존재
- [ ] `practice/` 실습 구조 존재
- [ ] `docs/logs/`와 `docs/screenshots/` 구조 존재
- [ ] `docs/evidence-index.md`에서 실제 증거 상태 관리

## 공통 미션

- [ ] Ubuntu 24.04, bash, workspace와 Git root 확인
- [ ] 터미널 기본 명령 수행
- [ ] 파일·디렉터리 권한 변경 전후 기록
- [ ] Docker Client·Server 및 `hello-world` 확인
- [ ] 이미지·컨테이너·로그·stats 확인
- [ ] `attach`와 `exec` 실제 관찰
- [ ] 커스텀 Dockerfile 빌드
- [ ] 베이스 이미지와 커스텀 목적 설명
- [ ] 포트 매핑 접속 성공
- [ ] 바인드 마운트 변경 전후 확인
- [ ] Docker 볼륨 영속성 확인
- [ ] Git 설정·branch·remote·commit·push 증거
- [ ] 실제 로그와 스크린샷 저장
- [ ] 트러블슈팅 2건 이상 기록
- [ ] clean clone과 `main` 최종 검증
- [ ] 민감정보 미포함

---

## 완료 문장 예시

### Windows

> Windows 11 Pro의 `C:\WSL\codyssey-ubuntu24` 디렉터리에 WSL2 Ubuntu 24.04를 설치하고, WSL Linux 홈의 저장소를 VS Code Remote-WSL로 열었다. Ubuntu bash와 workspace 경로, Docker Desktop WSL Integration, Docker·Git/GitHub 및 증거 문서를 검증했다.

### macOS

> macOS의 OrbStack Ubuntu 24.04에 SSH로 접속하고 `code --remote`로 저장소를 열었다. Ubuntu bash와 workspace 경로, Docker, Git/GitHub 및 증거 문서를 검증했다.
