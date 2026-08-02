# E1-1 개발 워크스테이션 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 작업실 꾸미기  
> **저장소:** `gahyun1004/codyssey-training-e1-1`  
> **지원 환경:**  
> - macOS + OrbStack + Ubuntu 24.04 LTS  
> - Windows 11 Pro + WSL2 + Ubuntu 24.04 LTS

이 README는 운영체제별 진입 절차와 공통 Docker·Git·증거 수집 절차를 연결하는 중앙 가이드입니다. 실제 로그와 스크린샷은 본인이 직접 수행한 결과만 저장합니다.

---

## 1. 환경 선택

| 환경 | Linux 연결 방식 | VS Code 확장 | 실행 명령 | 상세 문서 |
|---|---|---|---|---|
| macOS + OrbStack | Remote-SSH | `Remote - SSH` | `code --remote "ssh-remote+codyssey-training@orb" <원격경로>` | [macOS·OrbStack 가이드](docs/macos-orbstack-guide.md) |
| Windows 11 Pro + WSL2 | Remote-WSL | `WSL` | WSL Ubuntu에서 `code .` | [Windows·WSL 가이드](docs/windows-wsl.md) |

두 환경 모두 `.vscode/settings.json`을 사용해 새 통합 터미널을 Ubuntu의 `/bin/bash`와 현재 `${workspaceFolder}`에서 시작합니다.

### 실행 위치

| 표시 | 실행 위치 |
|---|---|
| **[macOS]** | Mac Terminal |
| **[PowerShell 관리자]** | Windows Terminal 또는 PowerShell 관리자 권한 |
| **[PowerShell]** | 일반 Windows Terminal 또는 PowerShell |
| **[WSL Ubuntu]** | WSL2의 Ubuntu 24.04 |
| **[OrbStack Ubuntu]** | OrbStack의 Ubuntu 24.04 |
| **[VS Code Ubuntu]** | Remote-SSH 또는 Remote-WSL 통합 터미널 |
| **[컨테이너]** | Docker 컨테이너 내부 |

---

## 2. 수행 문서

- [Windows 11 Pro + WSL2 + Ubuntu 24.04](docs/windows-wsl.md)
- [macOS + OrbStack + Ubuntu 24.04](docs/macos-orbstack-guide.md)
- [저장소 구조](docs/repository-structure.md)
- [증거 인덱스](docs/evidence-index.md)
- [실행 환경 기록](docs/environment.md)
- [터미널 및 권한 실습](docs/terminal-and-permissions.md)
- [Docker 운영](docs/docker-operations.md)
- [커스텀 이미지 설계](docs/image-design.md)
- [포트 매핑 및 바인드 마운트](docs/port-and-bind.md)
- [볼륨 영속성](docs/volume-persistence.md)
- [최종 검증 결과](docs/test-results.md)
- [트러블슈팅](docs/troubleshooting.md)
- [로그 작성 규칙](docs/logs/README.md)
- [스크린샷 규칙](docs/screenshots/README.md)

---

# 3. Windows 11 Pro + WSL2 빠른 시작

## 3.1 Windows Terminal 실행

```text
Windows 키
→ Windows Terminal 또는 PowerShell 검색
→ WSL 설치 단계에서는 관리자 권한으로 실행
```

## 3.2 C 드라이브에 WSL 폴더 만들기

이 가이드의 Windows 기본 설치 위치는 다음과 같습니다.

```text
C:\WSL\Ubuntu-24.04
```

이 경로는 **Ubuntu 배포판의 가상 디스크와 시스템 파일을 저장하는 위치**입니다. 프로젝트 저장소는 Ubuntu 내부의 `/home/<사용자>/...`에 clone합니다. `C:\WSL\Ubuntu-24.04` 안에 프로젝트 파일을 직접 넣지 않습니다.

먼저 WSL 기능만 설치합니다. WSL이 이미 정상 설치되어 있다면 이 명령은 건너뜁니다.

```powershell
# [PowerShell 관리자]
wsl.exe --install --no-distribution
```

재시작이 요구되면 Windows를 재시작한 후 다시 관리자 PowerShell을 엽니다.

## 3.3 WSL 업데이트와 `--location` 지원 확인

```powershell
# [PowerShell 관리자]
wsl.exe --update
wsl.exe --set-default-version 2
wsl.exe --version
wsl.exe --help | Select-String -SimpleMatch "--location"
```

`--location`이 표시되어야 지정 폴더 설치를 사용할 수 있습니다. 표시되지 않으면 Windows Update와 Microsoft Store 버전 WSL 업데이트를 먼저 완료합니다.

## 3.4 Ubuntu 24.04를 `C:\WSL` 아래에 설치

온라인 배포판 이름을 확인하고 설치 폴더를 만듭니다.

```powershell
# [PowerShell 관리자]
wsl.exe --list --online
New-Item -ItemType Directory -Force -Path "C:\WSL"
```

Ubuntu 24.04를 정확한 위치에 설치합니다.

```powershell
# [PowerShell 관리자]
wsl.exe --install `
  --distribution Ubuntu-24.04 `
  --location "C:\WSL\Ubuntu-24.04" `
  --no-launch
```

설치가 완료되면 기본 배포판으로 지정하고 처음 실행합니다.

```powershell
wsl.exe --set-default Ubuntu-24.04
wsl.exe -d Ubuntu-24.04
```

첫 실행 시 Linux 사용자 이름과 비밀번호를 설정합니다.

> `Ubuntu-24.04`가 이미 다른 위치에 설치되어 있다면 위 명령으로 덮어쓰거나 이동하지 않습니다. 기존 배포판 이동은 export·unregister·import 절차가 필요하며 데이터 손실 위험이 있으므로 별도 작업으로 진행해야 합니다.

## 3.5 설치 위치와 WSL2 확인

```powershell
# [PowerShell 관리자 또는 일반 PowerShell]
Test-Path "C:\WSL\Ubuntu-24.04"
Get-ChildItem -Force "C:\WSL\Ubuntu-24.04"
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
```

정상 기준:

- `Test-Path` 결과가 `True`
- `C:\WSL\Ubuntu-24.04` 폴더가 존재
- 배포판 이름이 `Ubuntu-24.04`
- `VERSION`이 `2`

WSL 1이면 다음을 실행합니다.

```powershell
wsl.exe --set-default-version 2
wsl.exe --set-version Ubuntu-24.04 2
wsl.exe --set-default Ubuntu-24.04
```

## 3.6 설치 보조 스크립트

Windows에 이 저장소가 clone되어 있을 때 다음 스크립트를 사용할 수 있습니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

기본값:

```text
배포판: Ubuntu-24.04
설치 루트: C:\WSL
최종 위치: C:\WSL\Ubuntu-24.04
```

다른 설치 루트를 지정하려면:

```powershell
.\scripts\windows\setup-wsl.ps1 `
  -Distribution "Ubuntu-24.04" `
  -InstallRoot "D:\WSL"
```

스크립트는 관리자 권한, WSL 업데이트, `--location` 지원, 기존 배포판, 대상 폴더 상태를 확인합니다. Windows 재부팅과 Ubuntu 최초 사용자 생성은 사용자가 직접 완료합니다.

## 3.7 Ubuntu 24.04 확인

```powershell
# [PowerShell]
wsl.exe -d Ubuntu-24.04
```

```bash
# [WSL Ubuntu]
cat /etc/os-release
uname -a
printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-}"
printf 'SHELL=%s\n' "$SHELL"
pwd
```

정상 기준:

- `VERSION_ID="24.04"`
- 커널 정보에 `microsoft` 또는 `WSL2`
- `WSL_DISTRO_NAME=Ubuntu-24.04`
- `SHELL=/bin/bash`

## 3.8 저장소를 WSL Linux 홈에 clone

```bash
# [WSL Ubuntu]
sudo apt update
sudo apt install -y git curl ca-certificates jq tree

mkdir -p ~/codyssey-training
cd ~/codyssey-training
git clone https://github.com/gahyun1004/codyssey-training-e1-1.git
cd codyssey-training-e1-1

pwd
git status -sb
```

권장 경로:

```text
/home/<WSL사용자>/codyssey-training/codyssey-training-e1-1
```

경로 구분:

```text
Ubuntu 배포판 저장 위치: C:\WSL\Ubuntu-24.04
프로젝트 작업 위치:     /home/<WSL사용자>/codyssey-training/codyssey-training-e1-1
```

Git·Docker·권한 실습은 `/mnt/c/...`가 아니라 WSL Linux 홈에서 수행합니다.

## 3.9 VS Code Remote-WSL 실행

Windows에서 WSL 확장을 설치합니다.

```powershell
# [PowerShell]
code --install-extension ms-vscode-remote.remote-wsl
```

WSL Ubuntu에서 저장소를 엽니다.

```bash
# [WSL Ubuntu]
cd ~/codyssey-training/codyssey-training-e1-1
code .
```

Windows 보조 스크립트:

```powershell
.\scripts\windows\open-vscode-wsl.ps1
```

성공 기준:

- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- Explorer 폴더가 `codyssey-training-e1-1`
- 새 터미널이 bash
- `pwd`가 WSL Linux 홈의 저장소 경로

## 3.10 WSL 검증 Task

```text
Ctrl + Shift + P
→ Tasks: Run Task
→ E1-1: Verify WSL Ubuntu Workspace
```

직접 실행:

```bash
scripts/ubuntu/verify-wsl-workspace.sh
```

---

# 4. Windows Docker Desktop + WSL2

권장 구성:

```text
Windows 11 Pro
└── Docker Desktop
    └── WSL 2 backend
        └── Ubuntu-24.04 WSL Integration
```

Docker Desktop 설정:

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

Docker Desktop을 사용하는 경우 WSL Ubuntu에 별도의 Docker Engine을 중복 설치하지 않습니다.

검증:

```bash
# [WSL Ubuntu]
docker --version
docker version
docker info
docker run --rm hello-world
```

정상 기준:

- Client와 Server가 모두 표시
- `docker info` 성공
- `Hello from Docker!` 출력

---

# 5. macOS + OrbStack 빠른 시작

기존 전체 수행 내용은 [docs/macos-orbstack-guide.md](docs/macos-orbstack-guide.md)에 보존했습니다.

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

Mac에도 저장소가 clone되어 있으면:

```bash
bash scripts/open-vscode-remote.sh
```

성공 기준:

- VS Code 왼쪽 아래 `SSH: codyssey-training@orb`
- Ubuntu 24.04
- bash
- 현재 저장소 폴더에서 새 터미널 시작

---

# 6. 공통 VS Code 설정

`.vscode/settings.json`은 두 Ubuntu 환경에서 다음 동작을 설정합니다.

- 기본 셸: `/bin/bash -l`
- 시작 폴더: `${workspaceFolder}`
- 분할 터미널 시작 폴더: workspace root
- shell integration 활성화

확장 추천:

```json
{
  "recommendations": [
    "ms-vscode-remote.remote-ssh",
    "ms-vscode-remote.remote-wsl"
  ]
}
```

새 터미널 검증:

```bash
cat /etc/os-release
printf 'SHELL=%s\n' "$SHELL"
ps -p $$ -o comm=
pwd
git rev-parse --show-toplevel
git branch --show-current
```

---

# 7. 실제 저장소 구조

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
```

| 경로 | 역할 |
|---|---|
| `docs/macos-orbstack-guide.md` | macOS·OrbStack 전체 가이드 |
| `docs/windows-wsl.md` | Windows·WSL 전체 가이드 |
| `scripts/windows/setup-wsl.ps1` | `C:\WSL\Ubuntu-24.04` 기본 설치와 상태 점검 |
| `scripts/windows/open-vscode-wsl.ps1` | WSL 저장소에서 `code .` 실행 |
| `scripts/ubuntu/verify-wsl-workspace.sh` | WSL·Ubuntu·bash·workspace·Docker 검증 |
| `.gitattributes` | Windows와 Linux 줄바꿈 정책 고정 |

---

# 8. 공통 Docker 실습

## 8.1 이미지 빌드

```bash
docker build -t codyssey-e1-1-web:1.0 . \
  2>&1 | tee docs/logs/docker-build.txt
```

## 8.2 포트 매핑

```bash
docker rm -f e1-1-web 2>/dev/null || true
docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:8080:80" \
  codyssey-e1-1-web:1.0

docker ps
docker logs e1-1-web
curl http://localhost:8080
```

브라우저:

```text
http://localhost:8080
```

포트 충돌 시:

```bash
source <(scripts/ubuntu/select-port.sh)
printf 'HOST_PORT=%s\n' "$HOST_PORT"
```

## 8.3 attach와 exec

```bash
docker rm -f e1-1-attach 2>/dev/null || true
docker run -dit --name e1-1-attach ubuntu:24.04 bash
docker attach e1-1-attach
```

분리:

```text
Ctrl + P
Ctrl + Q
```

```bash
docker exec e1-1-attach \
  bash -lc 'echo "exec creates another process"'
```

## 8.4 바인드 마운트

```bash
docker rm -f e1-1-bind 2>/dev/null || true
docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:8080:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine
```

`bind-test/index.html`을 수정한 뒤 재시작 없이 응답 변경을 확인합니다.

## 8.5 볼륨 영속성

```bash
docker volume create e1-1-data

docker run -d \
  --name e1-1-volume-1 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-1 \
  bash -lc 'echo "persistent data" > /data/result.txt'

docker rm -f e1-1-volume-1

docker run -d \
  --name e1-1-volume-2 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-2 cat /data/result.txt
```

---

# 9. 환경과 증거 기록

Windows 호스트:

```powershell
Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber

Test-Path "C:\WSL\Ubuntu-24.04"
Get-ChildItem -Force "C:\WSL\Ubuntu-24.04"
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
```

Ubuntu 로그:

```bash
mkdir -p docs/logs

{
  echo '$ cat /etc/os-release'
  cat /etc/os-release
  echo '$ uname -a'
  uname -a
  echo '$ echo $WSL_DISTRO_NAME'
  echo "${WSL_DISTRO_NAME:-not-wsl}"
  echo '$ echo $SHELL'
  echo "$SHELL"
  echo '$ pwd'
  pwd
  echo '$ git rev-parse --show-toplevel'
  git rev-parse --show-toplevel
  echo '$ docker version'
  docker version
  echo '$ git config --list'
  git config --list
} 2>&1 | tee docs/logs/environment.txt
```

필수 증거:

- Windows 11 Pro 정보
- `C:\WSL\Ubuntu-24.04` 폴더 존재
- `wsl.exe --list --verbose`의 `Ubuntu-24.04`, `VERSION 2`
- VS Code의 `WSL: Ubuntu-24.04` 또는 `SSH: codyssey-training@orb`
- bash, `pwd`, Git root, branch
- Docker version, info, images, ps, logs, stats
- 브라우저 주소창과 포트
- 바인드 마운트 변경 전후
- 볼륨 영속성
- GitHub 로그인과 저장소 연결

[증거 인덱스](docs/evidence-index.md)의 상태는 실제 수행 후에만 `완료`로 변경합니다.

---

# 10. 운영체제별 주의사항

## Windows·WSL

- Ubuntu 배포판 저장 위치는 `C:\WSL\Ubuntu-24.04`입니다.
- 프로젝트 저장소는 WSL 내부 `/home/...`에 둡니다.
- `C:\WSL\Ubuntu-24.04`를 일반 프로젝트 폴더처럼 직접 수정하지 않습니다.
- PowerShell 명령과 bash 명령을 구분합니다.
- Docker Desktop WSL Integration 대상이 `Ubuntu-24.04`인지 확인합니다.
- Docker Desktop과 WSL 내부 독립 Docker Engine을 동시에 운영하지 않습니다.
- `.sh`는 LF, `.ps1`은 CRLF를 사용합니다.

## macOS·OrbStack

- Mac에서 `code .`을 실행하면 Mac 로컬 폴더가 열립니다.
- OrbStack 저장소는 `code --remote`로 엽니다.
- Mac에 저장소가 없으면 Mac용 스크립트 대신 `code --remote` 명령을 사용합니다.

---

# 11. 대표 오류

| 증상 | 환경 | 조치 |
|---|---|---|
| `--location`이 도움말에 없음 | Windows | `wsl.exe --update`와 Windows Update 후 다시 확인 |
| `C:\WSL\Ubuntu-24.04`가 이미 비어 있지 않음 | Windows | 기존 폴더를 확인하고 다른 빈 위치 사용 |
| 같은 이름의 Ubuntu가 이미 설치됨 | Windows | 덮어쓰기 금지, 기존 배포판 이동은 별도 export/import 절차 사용 |
| `wsl --install`이 도움말만 표시 | Windows | `wsl --list --online` 후 전체 `--distribution`, `--location` 명령 사용 |
| 배포판이 WSL 1 | Windows | `wsl --set-version Ubuntu-24.04 2` |
| VS Code가 Windows 로컬 창으로 열림 | WSL | WSL Ubuntu 저장소에서 `code .` |
| `code: command not found` | WSL | Windows VS Code와 WSL 확장 설치 확인 |
| 저장소가 `/mnt/c/...` | WSL | `~/codyssey-training/`에 다시 clone |
| Docker Server 연결 실패 | WSL | Docker Desktop 실행 및 WSL Integration 확인 |
| 검증 Task 실패 | 공통 | `chmod +x scripts/ubuntu/*.sh` |
| 포트 충돌 | 공통 | `scripts/ubuntu/select-port.sh` 사용 |
| SSH 접속 실패 | macOS | `orb status`, `orb info` 확인 |

---

# 12. 최종 체크리스트

## Windows 11 Pro + WSL2

- [ ] Windows 11 Pro 정보 기록
- [ ] `C:\WSL` 폴더 생성
- [ ] `--location` 옵션 지원 확인
- [ ] Ubuntu 24.04를 `C:\WSL\Ubuntu-24.04`에 설치
- [ ] `Test-Path "C:\WSL\Ubuntu-24.04"` 결과 `True`
- [ ] `wsl.exe --list --verbose`에서 `Ubuntu-24.04`, VERSION 2
- [ ] Ubuntu Linux 사용자 생성
- [ ] 저장소를 `/home/...`에 clone
- [ ] VS Code WSL 확장 설치
- [ ] Ubuntu에서 `code .`
- [ ] VS Code 왼쪽 아래 WSL 표시
- [ ] Docker Desktop WSL Integration 활성화
- [ ] WSL에서 Docker Client·Server 확인
- [ ] WSL 검증 Task 실행

## macOS + OrbStack

- [ ] OrbStack Ubuntu 24.04 확인
- [ ] `ssh codyssey-training@orb`
- [ ] `code --remote`로 저장소 열기
- [ ] VS Code 왼쪽 아래 SSH 표시
- [ ] Ubuntu 검증 Task 실행

## 공통 미션

- [ ] Dockerfile 빌드
- [ ] 이미지·컨테이너 운영
- [ ] attach와 exec 관찰
- [ ] 포트 매핑
- [ ] 바인드 마운트
- [ ] 볼륨 영속성
- [ ] Git 설정·브랜치·remote 확인
- [ ] 실제 로그·스크린샷 저장
- [ ] 트러블슈팅 2건 이상
- [ ] clean clone 검증
- [ ] 민감정보 미포함

---

# 13. 공식 참고자료

- Microsoft WSL 설치: <https://learn.microsoft.com/windows/wsl/install>
- Microsoft WSL 기본 명령: <https://learn.microsoft.com/windows/wsl/basic-commands>
- VS Code WSL: <https://code.visualstudio.com/docs/remote/wsl>
- Docker Desktop WSL 2 backend: <https://docs.docker.com/desktop/features/wsl/>

---

## 완료 문장 예시

### Windows

> Windows 11 Pro의 `C:\WSL\Ubuntu-24.04` 경로에 WSL2 Ubuntu 24.04를 설치하고, Ubuntu Linux 홈의 저장소에서 `code .`을 실행해 VS Code Remote-WSL 작업공간을 열었다. Docker Desktop WSL Integration을 활성화한 뒤 Ubuntu bash, workspace 경로, Docker Client·Server, 포트 매핑, 바인드 마운트, 볼륨 영속성 및 Git/GitHub 검증을 완료했다.

### macOS

> macOS의 OrbStack Ubuntu 24.04에 SSH로 접속하고, `code --remote`로 저장소를 열었다. Ubuntu bash와 현재 workspace 경로, Docker, Git/GitHub 및 증거 문서를 검증했다.
