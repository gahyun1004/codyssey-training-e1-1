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
→ WSL 최초 설치 단계에서는 관리자 권한으로 실행
```

## 3.2 WSL과 Ubuntu 24.04 설치

```powershell
# [PowerShell 관리자]
wsl.exe --list --online
wsl.exe --install -d Ubuntu-24.04
```

재시작이 요구되면 Windows를 재시작합니다. Ubuntu 최초 실행 시 Linux 사용자 이름과 비밀번호를 설정합니다.

```powershell
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
```

정상 기준:

- 배포판: `Ubuntu-24.04`
- `VERSION`: `2`

WSL 1이면:

```powershell
wsl.exe --set-default-version 2
wsl.exe --set-version Ubuntu-24.04 2
wsl.exe --set-default Ubuntu-24.04
```

Windows에 이 저장소가 clone되어 있을 때 보조 스크립트를 사용할 수 있습니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

> 스크립트는 설치 상태를 점검하고 명령을 실행합니다. Windows 재부팅과 Ubuntu 최초 사용자 생성은 사용자가 직접 완료합니다.

## 3.3 Ubuntu 24.04 확인

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

## 3.4 저장소를 WSL Linux 홈에 clone

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

`/mnt/c/...`보다 WSL Linux 홈을 권장합니다.

## 3.5 VS Code Remote-WSL 실행

Windows에서:

```powershell
# [PowerShell]
code --install-extension ms-vscode-remote.remote-wsl
```

WSL Ubuntu에서:

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

## 3.6 WSL 검증 Task

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

`.vscode/settings.json`:

```json
{
  "terminal.integrated.profiles.linux": {
    "Ubuntu Bash (login)": {
      "path": "/bin/bash",
      "args": ["-l"],
      "icon": "terminal-bash",
      "overrideName": true
    }
  },
  "terminal.integrated.defaultProfile.linux": "Ubuntu Bash (login)",
  "terminal.integrated.automationProfile.linux": {
    "path": "/bin/bash",
    "args": ["-l"]
  },
  "terminal.integrated.cwd": "${workspaceFolder}",
  "terminal.integrated.splitCwd": "workspaceRoot",
  "terminal.integrated.shellIntegration.enabled": true
}
```

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
```

| 경로 | 역할 |
|---|---|
| `docs/macos-orbstack-guide.md` | 기존 macOS·OrbStack 전체 가이드 |
| `docs/windows-wsl.md` | Windows·WSL 전체 가이드 |
| `scripts/windows/setup-wsl.ps1` | WSL2·Ubuntu 24.04 상태 점검 |
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

Windows 호스트:

```powershell
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
code --version
```

필수 증거:

- 선택한 호스트 OS와 Ubuntu 24.04
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

- 저장소는 `/home/...`에 둡니다.
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
| `wsl --install`이 도움말만 표시 | Windows | `wsl --list --online` 후 `wsl --install -d Ubuntu-24.04` |
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
- [ ] WSL 버전 확인
- [ ] `Ubuntu-24.04`, VERSION 2
- [ ] WSL Linux 홈에 저장소 clone
- [ ] VS Code WSL 확장 설치
- [ ] WSL Ubuntu에서 `code .`
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
- VS Code WSL: <https://code.visualstudio.com/docs/remote/wsl>
- Docker Desktop WSL 2 backend: <https://docs.docker.com/desktop/features/wsl/>
- Docker Desktop + WSL 개발: <https://docs.docker.com/desktop/features/wsl/use-wsl/>

---

## 완료 문장 예시

### Windows

> Windows 11 Pro에서 WSL2와 Ubuntu 24.04를 구성하고, WSL Linux 홈의 저장소에서 `code .`을 실행해 VS Code Remote-WSL 작업공간을 열었다. Docker Desktop WSL Integration을 활성화한 뒤 Ubuntu bash, workspace 경로, Docker Client·Server, 포트 매핑, 바인드 마운트, 볼륨 영속성 및 Git/GitHub 검증을 완료했다.

### macOS

> macOS의 OrbStack Ubuntu 24.04에 SSH로 접속하고, `code --remote`로 저장소를 열었다. Ubuntu bash와 현재 workspace 경로, Docker, Git/GitHub 및 증거 문서를 검증했다.
