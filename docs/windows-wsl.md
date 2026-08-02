# Windows 11 Pro + WSL2 + Ubuntu 24.04 수행 가이드

이 문서는 Windows 11 Pro에서 WSL2 Ubuntu 24.04를 `C:\WSL\Ubuntu-24.04`에 설치하고, VS Code Remote-WSL과 Docker Desktop WSL Integration을 구성하는 절차입니다.

> 실제 설치·실행 결과는 사용자가 직접 확인해야 합니다. 이 문서와 스크립트는 실행 구조와 검증 기준을 제공하며 실제 로그나 성공 증거를 대신하지 않습니다.

---

## 1. 최종 구성

```text
Windows 11 Pro
├── C:\WSL\Ubuntu-24.04
│   └── WSL2 Ubuntu 배포판 데이터
├── Windows Terminal / PowerShell
├── Visual Studio Code
│   └── WSL 확장
├── WSL2 Ubuntu 24.04
│   └── /home/<사용자>/codyssey-training/codyssey-training-e1-1
└── Docker Desktop
    └── WSL 2 backend + Ubuntu-24.04 Integration
```

경로를 구분합니다.

| 구분 | 경로 | 용도 |
|---|---|---|
| WSL 배포판 설치 위치 | `C:\WSL\Ubuntu-24.04` | Ubuntu 가상 디스크와 시스템 데이터 |
| 프로젝트 작업 위치 | `/home/<사용자>/codyssey-training/codyssey-training-e1-1` | Git, Docker, VS Code 실습 |

`C:\WSL\Ubuntu-24.04`는 WSL이 관리하는 배포판 저장 위치입니다. 이 폴더 안에 프로젝트를 직접 만들거나 파일을 임의로 수정하지 않습니다.

---

## 2. Windows 버전 확인

```powershell
# [PowerShell]
Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber

$env:PROCESSOR_ARCHITECTURE
```

기록 항목:

- Windows 제품명: Windows 11 Pro
- Windows 버전:
- OS 빌드:
- CPU 아키텍처:

---

## 3. WSL 기능만 먼저 설치

PowerShell 또는 Windows Terminal을 관리자 권한으로 실행합니다.

```powershell
# [PowerShell 관리자]
wsl.exe --install --no-distribution
```

재시작이 요구되면 Windows를 재시작합니다. WSL이 이미 정상 설치되어 있다면 이 단계는 건너뜁니다.

재시작 후 다시 관리자 PowerShell을 실행합니다.

```powershell
wsl.exe --update
wsl.exe --set-default-version 2
wsl.exe --version
wsl.exe --status
```

---

## 4. `--location` 지원 확인

지정 폴더 설치에는 최신 WSL의 `--location` 옵션이 필요합니다.

```powershell
# [PowerShell 관리자]
wsl.exe --help | Select-String -SimpleMatch "--location"
```

정상 기준:

```text
--location
```

옵션이 표시되지 않으면 다음을 확인합니다.

1. `wsl.exe --update` 실행
2. Windows Update 완료
3. Microsoft Store 버전 WSL 업데이트
4. Windows 재시작 후 다시 확인

---

## 5. `C:\WSL` 폴더 생성

```powershell
# [PowerShell 관리자]
New-Item -ItemType Directory -Force -Path "C:\WSL"
Test-Path "C:\WSL"
```

정상 기준:

```text
True
```

온라인 설치 가능한 배포판 이름을 확인합니다.

```powershell
wsl.exe --list --online
```

목록에 `Ubuntu-24.04`가 있어야 합니다.

---

## 6. Ubuntu 24.04를 지정 폴더에 설치

```powershell
# [PowerShell 관리자]
wsl.exe --install `
  --distribution Ubuntu-24.04 `
  --location "C:\WSL\Ubuntu-24.04" `
  --no-launch
```

설치 후 기본 배포판으로 지정합니다.

```powershell
wsl.exe --set-default Ubuntu-24.04
```

처음 실행합니다.

```powershell
wsl.exe -d Ubuntu-24.04
```

첫 실행 시 다음을 완료합니다.

1. 배포판 초기화 대기
2. Linux 사용자 이름 입력
3. Linux 비밀번호 입력
4. bash 프롬프트 확인

> `Ubuntu-24.04`가 이미 다른 위치에 설치되어 있으면 위 명령으로 덮어쓰지 않습니다. 기존 배포판 이동에는 export·unregister·import 절차가 필요하고 데이터 손실 위험이 있으므로 별도로 처리합니다.

---

## 7. 설치 위치와 WSL2 검증

PowerShell에서 확인합니다.

```powershell
Test-Path "C:\WSL\Ubuntu-24.04"
Get-ChildItem -Force "C:\WSL\Ubuntu-24.04"
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
```

정상 예시:

```text
NAME              STATE           VERSION
* Ubuntu-24.04    Running         2
```

정상 기준:

- `Test-Path` 결과가 `True`
- `C:\WSL\Ubuntu-24.04` 폴더 존재
- 배포판 이름 `Ubuntu-24.04`
- `VERSION` 값 `2`

WSL 1이면 다음을 실행합니다.

```powershell
wsl.exe --set-default-version 2
wsl.exe --set-version Ubuntu-24.04 2
wsl.exe --set-default Ubuntu-24.04
```

---

## 8. 설치 보조 스크립트

저장소가 Windows에서 접근 가능한 경우 다음 스크립트를 실행할 수 있습니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

기본 매개변수:

```text
Distribution = Ubuntu-24.04
InstallRoot  = C:\WSL
InstallPath  = C:\WSL\Ubuntu-24.04
```

다른 드라이브를 지정하려면:

```powershell
.\scripts\windows\setup-wsl.ps1 `
  -Distribution "Ubuntu-24.04" `
  -InstallRoot "D:\WSL"
```

스크립트는 다음을 확인합니다.

- 관리자 권한
- WSL 설치와 업데이트 상태
- WSL2 기본 버전
- `--location` 옵션 지원
- 동일 이름 배포판 존재 여부
- 설치 루트와 대상 폴더 상태
- 최종 배포판 목록

스크립트는 기존 배포판을 자동으로 unregister하거나 이동하지 않습니다.

---

## 9. Ubuntu 24.04 초기 확인

```powershell
wsl.exe -d Ubuntu-24.04
```

Ubuntu에서:

```bash
cat /etc/os-release
uname -a
whoami
printf 'HOME=%s\n' "$HOME"
printf 'SHELL=%s\n' "$SHELL"
printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-}"
```

정상 기준:

- `VERSION_ID="24.04"`
- 커널 정보에 `microsoft` 또는 `WSL2`
- `WSL_DISTRO_NAME=Ubuntu-24.04`
- `SHELL=/bin/bash`

패키지 설치:

```bash
sudo apt update
sudo apt install -y \
  ca-certificates curl wget git gnupg nano vim tree jq tar unzip zip
```

Git 설정:

```bash
git config --global init.defaultBranch main
git config --global user.name "본인의 Git 이름"
git config --global user.email "본인의 GitHub 이메일"
git config --list
```

이메일이 포함된 화면을 공개할 때는 일부를 마스킹합니다.

---

## 10. 저장소 clone

프로젝트는 WSL Linux 홈에 clone합니다.

```bash
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

경로 확인:

```bash
case "$PWD" in
  /mnt/*)
    echo "[WARN] 현재 저장소가 Windows 마운트 경로에 있습니다: $PWD"
    ;;
  "$HOME"/*)
    echo "[PASS] 저장소가 WSL Linux 홈에 있습니다: $PWD"
    ;;
esac
```

이미 clone되어 있다면:

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git pull --ff-only origin main
```

---

## 11. VS Code와 WSL 확장

Windows PowerShell에서:

```powershell
code --version
code --install-extension ms-vscode-remote.remote-wsl
code --list-extensions |
  Select-String -SimpleMatch "ms-vscode-remote.remote-wsl"
```

WSL Ubuntu에서:

```bash
cd ~/codyssey-training/codyssey-training-e1-1
code .
```

Windows 보조 스크립트:

```powershell
.\scripts\windows\open-vscode-wsl.ps1
```

성공 기준:

- 왼쪽 아래 `WSL: Ubuntu-24.04`
- Explorer 폴더 `codyssey-training-e1-1`
- 새 통합 터미널 bash
- 터미널 경로가 Git 저장소 루트
- `/etc/os-release`가 Ubuntu 24.04

---

## 12. VS Code 새 터미널 검증

```text
Terminal
→ New Terminal
```

```bash
cat /etc/os-release
printf 'SHELL=%s\n' "$SHELL"
ps -p $$ -o comm=
printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-}"
pwd
git rev-parse --show-toplevel
git branch --show-current
```

Task 실행:

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

## 13. Docker Desktop WSL Integration

권장 방식은 Windows용 Docker Desktop의 WSL 2 backend입니다.

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

주의:

- Docker Desktop을 사용하는 경우 WSL Ubuntu에 독립 Docker Engine을 중복 설치하지 않습니다.
- WSL Integration 대상 배포판을 정확히 선택합니다.
- Docker Desktop이 Windows containers mode이면 Linux containers로 전환합니다.

Ubuntu에서 확인:

```bash
docker --version
docker context show
docker version
docker info
docker run --rm hello-world
```

---

## 14. Dockerfile 웹 서버

```bash
cd ~/codyssey-training/codyssey-training-e1-1

docker build -t codyssey-e1-1-web:1.0 . \
  2>&1 | tee docs/logs/docker-build.txt
```

실행:

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

Windows 브라우저:

```text
http://localhost:8080
```

주소창과 응답을 함께 캡처합니다.

---

## 15. 바인드 마운트와 볼륨

바인드 마운트:

```bash
docker rm -f e1-1-bind 2>/dev/null || true

docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:8080:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine

curl http://localhost:8080
```

`bind-test/index.html` 수정 후 컨테이너 재시작 없이 응답 변경을 확인합니다.

볼륨 영속성:

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

`persistent data`가 출력되어야 합니다.

---

## 16. Windows·Linux 경로 구분

| Windows | WSL |
|---|---|
| `C:\WSL\Ubuntu-24.04` | Ubuntu 배포판 데이터 위치 |
| `C:\Users\name\project` | `/mnt/c/Users/name/project` |
| `\\wsl$\Ubuntu-24.04\home\name` | `/home/name` |
| PowerShell | bash |
| `Get-ChildItem` | `ls -la` |
| `Get-Location` | `pwd` |

권장 원칙:

- 배포판 시스템 데이터는 `C:\WSL\Ubuntu-24.04`
- Git·Docker 빌드·권한 실습은 `/home/...`
- Windows Explorer에서 WSL 파일을 볼 때 `\\wsl$\Ubuntu-24.04\home\<사용자>` 사용
- WSL 파일은 VS Code WSL 창에서 편집
- PowerShell 경로를 bash 명령에 그대로 전달하지 않음

---

## 17. 환경 증거 저장

PowerShell에서:

```powershell
$log = @(
  "`$ Test-Path C:\WSL\Ubuntu-24.04"
  (Test-Path "C:\WSL\Ubuntu-24.04")
  "`$ wsl.exe --version"
  (wsl.exe --version)
  "`$ wsl.exe --status"
  (wsl.exe --status)
  "`$ wsl.exe --list --verbose"
  (wsl.exe --list --verbose)
)

$log | Set-Content -Encoding utf8 docs\logs\windows-wsl-host.txt
```

WSL Ubuntu에서:

```bash
{
  echo '$ cat /etc/os-release'
  cat /etc/os-release
  echo '$ uname -a'
  uname -a
  echo '$ echo $WSL_DISTRO_NAME'
  echo "${WSL_DISTRO_NAME:-}"
  echo '$ pwd'
  pwd
  echo '$ git rev-parse --show-toplevel'
  git rev-parse --show-toplevel
  echo '$ docker version'
  docker version
} 2>&1 | tee docs/logs/windows-wsl-environment.txt
```

민감정보와 개인 경로를 검토한 후 커밋합니다.

---

## 18. 트러블슈팅

### `--location` 옵션이 표시되지 않음

```powershell
wsl.exe --update
wsl.exe --help | Select-String -SimpleMatch "--location"
```

Windows Update와 Microsoft Store WSL 업데이트를 확인합니다.

### 대상 폴더가 비어 있지 않음

```powershell
Get-ChildItem -Force "C:\WSL\Ubuntu-24.04"
```

기존 데이터를 확인하고 다른 빈 폴더를 사용합니다. 자동 삭제하지 않습니다.

### 동일한 배포판이 이미 설치됨

```powershell
wsl.exe --list --verbose
```

기존 배포판을 자동 unregister하지 않습니다. 이동이 필요하면 별도 백업·이관 절차를 사용합니다.

### Ubuntu가 WSL 1

```powershell
wsl.exe --set-version Ubuntu-24.04 2
```

### VS Code가 Windows 로컬 창으로 열림

WSL Ubuntu 저장소에서:

```bash
code .
```

### Docker Client만 있고 Server 없음

- Docker Desktop 실행 여부
- WSL 2 based engine
- Ubuntu-24.04 WSL Integration
- Linux containers mode

확인 후:

```powershell
wsl.exe --shutdown
```

Docker Desktop을 재시작하고 Ubuntu를 다시 엽니다.

---

## 19. 최종 체크리스트

- [ ] Windows 11 Pro 버전 기록
- [ ] WSL 기능 설치
- [ ] WSL 업데이트 완료
- [ ] `--location` 옵션 지원 확인
- [ ] `C:\WSL` 폴더 생성
- [ ] Ubuntu 24.04를 `C:\WSL\Ubuntu-24.04`에 설치
- [ ] `Test-Path "C:\WSL\Ubuntu-24.04"` 결과 `True`
- [ ] `wsl.exe --list --verbose`에서 VERSION 2
- [ ] Ubuntu Linux 사용자 생성
- [ ] 저장소를 `/home/...`에 clone
- [ ] VS Code WSL 확장 설치
- [ ] Ubuntu에서 `code .`
- [ ] VS Code 왼쪽 아래 WSL 표시
- [ ] bash와 workspace 경로 확인
- [ ] Docker Desktop WSL Integration 활성화
- [ ] Docker Client·Server 확인
- [ ] Dockerfile 빌드
- [ ] 포트 매핑
- [ ] 바인드 마운트
- [ ] 볼륨 영속성
- [ ] 실제 로그·스크린샷 저장
- [ ] 민감정보 검토
- [ ] clean clone 재검증

---

## 공식 참고자료

- Microsoft WSL 설치: <https://learn.microsoft.com/windows/wsl/install>
- Microsoft WSL 기본 명령: <https://learn.microsoft.com/windows/wsl/basic-commands>
- VS Code WSL: <https://code.visualstudio.com/docs/remote/wsl>
- Docker Desktop WSL 2 backend: <https://docs.docker.com/desktop/features/wsl/>
