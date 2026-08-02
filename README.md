# E1-1 개발 워크스테이션 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 작업실 꾸미기  
> **저장소:** `gahyun1004/codyssey-training-e1-1`

## 지원 환경

- macOS + OrbStack + Ubuntu 24.04 LTS
- Windows 11 Pro + WSL2 + Ubuntu 24.04 LTS

이 README는 운영체제별 진입 절차와 공통 Docker·Git·증거 수집 절차를 연결하는 중앙 가이드입니다. 실제 로그와 스크린샷은 본인이 직접 수행한 결과만 저장합니다.

---

## 1. 환경 선택

| 환경 | Linux 연결 방식 | VS Code 확장 | 실행 명령 | 상세 문서 |
|---|---|---|---|---|
| macOS + OrbStack | Remote-SSH | `Remote - SSH` | `code --remote ...` | [macOS·OrbStack 가이드](docs/macos-orbstack-guide.md) |
| Windows 11 Pro + WSL2 | Remote-WSL | `WSL` | WSL Ubuntu에서 `code .` | [Windows·WSL 가이드](docs/windows-wsl.md) |

두 환경 모두 `.vscode/settings.json`을 사용해 새 통합 터미널을 Ubuntu의 `/bin/bash`와 `${workspaceFolder}`에서 시작합니다.

### 실행 위치 표시

| 표시 | 실행 위치 |
|---|---|
| **[macOS]** | Mac Terminal |
| **[PowerShell 관리자]** | 관리자 권한 Windows Terminal 또는 PowerShell |
| **[PowerShell]** | 일반 Windows Terminal 또는 PowerShell |
| **[WSL Ubuntu]** | WSL2 Ubuntu 24.04 |
| **[OrbStack Ubuntu]** | OrbStack Ubuntu 24.04 |
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

## 3.1 설치 이름과 경로

WSL 배포판 이름과 Windows 설치 디렉터리 이름을 구분합니다.

| 구분 | 값 |
|---|---|
| WSL 배포판 이름 | `Ubuntu-24.04` |
| 설치 루트 | `C:\WSL` |
| 설치 디렉터리 이름 | `codyssey-ubuntu24` |
| 최종 설치 위치 | `C:\WSL\codyssey-ubuntu24` |
| 프로젝트 작업 위치 | `/home/<사용자>/codyssey-training/codyssey-training-e1-1` |

`C:\WSL\codyssey-ubuntu24`에는 Ubuntu 가상 디스크와 시스템 데이터가 저장됩니다. 프로젝트 저장소는 이 폴더 안에 직접 만들지 않고 Ubuntu 내부의 `/home/...`에 clone합니다.

## 3.2 Windows Terminal 실행

```text
Windows 키
→ Windows Terminal 또는 PowerShell 검색
→ WSL 설치 단계에서는 관리자 권한으로 실행
```

## 3.3 WSL 기능 설치

```powershell
# [PowerShell 관리자]
wsl.exe --install --no-distribution
```

재시작이 요구되면 Windows를 재시작합니다. WSL이 이미 설치되어 있다면 이 단계는 건너뜁니다.

재시작 후:

```powershell
wsl.exe --update
wsl.exe --set-default-version 2
wsl.exe --version
wsl.exe --status
```

## 3.4 `--location` 지원 확인

```powershell
# [PowerShell 관리자]
wsl.exe --help | Select-String -SimpleMatch "--location"
```

`--location`이 표시되어야 지정 폴더 설치를 사용할 수 있습니다. 표시되지 않으면 WSL 업데이트, Windows Update, Microsoft Store WSL 업데이트를 확인합니다.

## 3.5 `C:\WSL` 폴더 생성

```powershell
# [PowerShell 관리자]
New-Item -ItemType Directory -Force -Path "C:\WSL"
Test-Path "C:\WSL"
wsl.exe --list --online
```

정상 기준:

- `Test-Path` 결과가 `True`
- 온라인 목록에 `Ubuntu-24.04`가 표시됨

## 3.6 Ubuntu 24.04를 `codyssey-ubuntu24`에 설치

```powershell
# [PowerShell 관리자]
wsl.exe --install `
  --distribution Ubuntu-24.04 `
  --location "C:\WSL\codyssey-ubuntu24" `
  --no-launch
```

설치 후 기본 배포판으로 지정하고 처음 실행합니다.

```powershell
wsl.exe --set-default Ubuntu-24.04
wsl.exe -d Ubuntu-24.04
```

첫 실행 시 Linux 사용자 이름과 비밀번호를 설정합니다.

> `Ubuntu-24.04`가 이미 설치되어 있다면 덮어쓰지 않습니다. 기존 배포판 이동은 별도 백업·export·unregister·import 절차가 필요합니다.

## 3.7 설치 위치와 WSL2 확인

```powershell
Test-Path "C:\WSL\codyssey-ubuntu24"
Get-ChildItem -Force "C:\WSL\codyssey-ubuntu24"
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
```

정상 기준:

- `Test-Path "C:\WSL\codyssey-ubuntu24"` 결과가 `True`
- 배포판 이름이 `Ubuntu-24.04`
- `VERSION`이 `2`

WSL 1이면:

```powershell
wsl.exe --set-default-version 2
wsl.exe --set-version Ubuntu-24.04 2
wsl.exe --set-default Ubuntu-24.04
```

## 3.8 설치 보조 스크립트

Windows에서 저장소를 접근할 수 있는 경우:

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

다른 값 지정:

```powershell
.\scripts\windows\setup-wsl.ps1 `
  -Distribution "Ubuntu-24.04" `
  -InstallRoot "D:\WSL" `
  -InstallDirectoryName "codyssey-ubuntu24"
```

## 3.9 Ubuntu 24.04 확인

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

## 3.10 저장소를 WSL Linux 홈에 clone

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

권장 프로젝트 경로:

```text
/home/<WSL사용자>/codyssey-training/codyssey-training-e1-1
```

경로를 혼동하지 않습니다.

```text
Ubuntu 배포판 데이터: C:\WSL\codyssey-ubuntu24
프로젝트 작업 폴더:   /home/<사용자>/codyssey-training/codyssey-training-e1-1
```

## 3.11 VS Code Remote-WSL 실행

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

성공 기준:

- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- Explorer 폴더가 `codyssey-training-e1-1`
- 새 터미널이 bash
- `pwd`가 Git 저장소 루트

## 3.12 WSL 검증 Task

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

Ubuntu에서 확인:

```bash
# [WSL Ubuntu]
docker --version
docker version
docker info
docker run --rm hello-world
```

Docker Desktop을 사용하는 경우 WSL Ubuntu에 별도 Docker Engine을 중복 설치하지 않습니다.

---

# 5. macOS + OrbStack 빠른 시작

전체 내용은 [docs/macos-orbstack-guide.md](docs/macos-orbstack-guide.md)에 있습니다.

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

성공 기준:

- VS Code 왼쪽 아래 `SSH: codyssey-training@orb`
- Ubuntu 24.04
- bash
- 현재 저장소 폴더에서 새 터미널 시작

---

# 6. 공통 VS Code 설정

`.vscode/settings.json`은 다음을 설정합니다.

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

터미널 검증:

```bash
cat /etc/os-release
printf 'SHELL=%s\n' "$SHELL"
ps -p $$ -o comm=
pwd
git rev-parse --show-toplevel
git branch --show-current
```

---

# 7. 저장소 구조

```text
codyssey-training-e1-1/
├── README.md
├── Dockerfile
├── .dockerignore
├── .gitignore
├── .gitattributes
├── .vscode/
├── scripts/
│   ├── macos/
│   ├── windows/
│   │   ├── setup-wsl.ps1
│   │   └── open-vscode-wsl.ps1
│   └── ubuntu/
│       ├── verify-remote-workspace.sh
│       ├── verify-wsl-workspace.sh
│       └── select-port.sh
├── site/
├── bind-test/
├── practice/
└── docs/
    ├── macos-orbstack-guide.md
    ├── windows-wsl.md
    ├── evidence-index.md
    ├── environment.md
    ├── test-results.md
    ├── logs/
    └── screenshots/
```

상세 구조는 [docs/repository-structure.md](docs/repository-structure.md)를 확인합니다.

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

# 9. Windows 환경 증거

```powershell
Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber

wsl.exe --help | Select-String -SimpleMatch "--location"
Test-Path "C:\WSL\codyssey-ubuntu24"
Get-ChildItem -Force "C:\WSL\codyssey-ubuntu24"
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
```

필수 증거:

- Windows 11 Pro 정보
- 설치 디렉터리 이름 `codyssey-ubuntu24`
- `C:\WSL\codyssey-ubuntu24` 폴더 존재
- `Ubuntu-24.04`, VERSION 2
- VS Code `WSL: Ubuntu-24.04`
- Docker Desktop WSL Integration
- Ubuntu bash, `pwd`, Git root와 branch

---

# 10. 대표 오류

| 증상 | 조치 |
|---|---|
| `--location`이 없음 | `wsl.exe --update`, Windows Update, Store WSL 업데이트 |
| `C:\WSL\codyssey-ubuntu24`가 비어 있지 않음 | 기존 데이터를 확인하고 다른 빈 폴더 사용 |
| `Ubuntu-24.04`가 이미 설치됨 | 덮어쓰기 금지, 별도 백업·이관 절차 사용 |
| 배포판이 WSL 1 | `wsl.exe --set-version Ubuntu-24.04 2` |
| VS Code가 Windows 로컬 창으로 열림 | WSL Ubuntu 저장소에서 `code .` |
| Docker Server 연결 실패 | Docker Desktop 실행 및 WSL Integration 확인 |
| 검증 Task 실패 | `chmod +x scripts/ubuntu/*.sh` |

---

# 11. 최종 체크리스트

## Windows 11 Pro + WSL2

- [ ] Windows 11 Pro 정보 기록
- [ ] WSL 기능과 업데이트 완료
- [ ] `--location` 지원 확인
- [ ] `C:\WSL` 폴더 생성
- [ ] 설치 디렉터리 이름을 `codyssey-ubuntu24`로 사용
- [ ] Ubuntu 24.04를 `C:\WSL\codyssey-ubuntu24`에 설치
- [ ] `Test-Path "C:\WSL\codyssey-ubuntu24"` 결과 `True`
- [ ] `wsl.exe --list --verbose`에서 `Ubuntu-24.04`, VERSION 2
- [ ] 프로젝트를 `/home/...`에 clone
- [ ] VS Code WSL 연결
- [ ] Docker Desktop WSL Integration 활성화

## macOS + OrbStack

- [ ] OrbStack Ubuntu 24.04 확인
- [ ] `ssh codyssey-training@orb`
- [ ] `code --remote`로 저장소 열기
- [ ] VS Code 왼쪽 아래 SSH 표시

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

## 완료 문장 예시

### Windows

> Windows 11 Pro의 `C:\WSL\codyssey-ubuntu24` 디렉터리에 WSL2 Ubuntu 24.04를 설치하고, Ubuntu Linux 홈의 저장소에서 VS Code Remote-WSL 작업공간을 열었다. Docker Desktop WSL Integration과 Docker·Git·증거 검증을 완료했다.

### macOS

> macOS의 OrbStack Ubuntu 24.04에 SSH로 접속하고 `code --remote`로 저장소를 열었다. Ubuntu bash와 workspace 경로, Docker, Git/GitHub 및 증거 문서를 검증했다.
