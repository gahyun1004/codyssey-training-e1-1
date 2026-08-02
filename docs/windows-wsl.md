# Windows 11 Pro + WSL2 + Ubuntu 24.04 수행 가이드

이 문서는 Windows 11 Pro에서 WSL2 Ubuntu 24.04를 다음 위치에 설치하는 절차입니다.

```text
C:\WSL\codyssey-ubuntu24
```

WSL 배포판 이름과 설치 디렉터리 이름은 서로 다릅니다.

| 구분 | 값 |
|---|---|
| WSL 배포판 이름 | `Ubuntu-24.04` |
| 설치 루트 | `C:\WSL` |
| 설치 디렉터리 이름 | `codyssey-ubuntu24` |
| 최종 설치 위치 | `C:\WSL\codyssey-ubuntu24` |
| 프로젝트 작업 위치 | `/home/<사용자>/codyssey-training/codyssey-training-e1-1` |

`C:\WSL\codyssey-ubuntu24`에는 Ubuntu 가상 디스크와 시스템 데이터가 저장됩니다. 프로젝트 저장소는 해당 폴더에 직접 만들지 않고 Ubuntu 내부의 `/home/...`에 clone합니다.

---

## 1. Windows 11 Pro 확인

```powershell
# [PowerShell]
Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber

$env:PROCESSOR_ARCHITECTURE
```

---

## 2. WSL 기능 설치

Windows Terminal 또는 PowerShell을 관리자 권한으로 실행합니다.

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

---

## 3. 지정 폴더 설치 지원 확인

```powershell
# [PowerShell 관리자]
wsl.exe --help | Select-String -SimpleMatch "--location"
```

`--location`이 표시되어야 합니다. 표시되지 않으면 다음을 확인합니다.

1. `wsl.exe --update`
2. Windows Update
3. Microsoft Store 버전 WSL 업데이트
4. Windows 재시작

---

## 4. C 드라이브에 WSL 폴더 생성

```powershell
# [PowerShell 관리자]
New-Item -ItemType Directory -Force -Path "C:\WSL"
Test-Path "C:\WSL"
wsl.exe --list --online
```

정상 기준:

- `Test-Path` 결과가 `True`
- 온라인 목록에 `Ubuntu-24.04`가 표시됨

---

## 5. Ubuntu 24.04 설치

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

> `Ubuntu-24.04`가 이미 설치되어 있다면 위 명령으로 덮어쓰지 않습니다. 기존 배포판 이동은 백업·export·unregister·import 절차가 필요하므로 별도 작업으로 처리합니다.

---

## 6. 설치 위치와 WSL2 확인

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
- `VERSION` 값이 `2`

WSL 1이면:

```powershell
wsl.exe --set-default-version 2
wsl.exe --set-version Ubuntu-24.04 2
wsl.exe --set-default Ubuntu-24.04
```

---

## 7. 설치 보조 스크립트

저장소가 Windows에서 접근 가능한 경우:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

기본값:

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

스크립트는 다음을 확인합니다.

- 관리자 권한
- WSL 설치·업데이트 상태
- WSL2 기본 버전
- `--location` 지원
- 동일 이름 배포판 존재 여부
- 설치 폴더가 비어 있는지 여부
- 최종 배포판 상태

기존 배포판을 자동 삭제하거나 이동하지 않습니다.

---

## 8. Ubuntu 24.04 초기 확인

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

---

## 9. 프로젝트 저장소 clone

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

설치 위치와 프로젝트 위치를 혼동하지 않습니다.

```text
Ubuntu 배포판 데이터: C:\WSL\codyssey-ubuntu24
프로젝트 작업 폴더:   /home/<사용자>/codyssey-training/codyssey-training-e1-1
```

---

## 10. VS Code Remote-WSL

Windows PowerShell에서 확장을 설치합니다.

```powershell
code --version
code --install-extension ms-vscode-remote.remote-wsl
```

WSL Ubuntu에서 저장소를 엽니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
code .
```

성공 기준:

- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- Explorer 폴더가 `codyssey-training-e1-1`
- 새 터미널이 bash
- `pwd`가 Git 저장소 루트

검증 Task:

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

## 11. Docker Desktop WSL Integration

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
docker --version
docker context show
docker version
docker info
docker run --rm hello-world
```

Docker Desktop을 사용하는 경우 WSL Ubuntu에 별도 Docker Engine을 중복 설치하지 않습니다.

---

## 12. 환경 증거 저장

PowerShell:

```powershell
$log = @(
  "`$ Test-Path C:\WSL\codyssey-ubuntu24"
  (Test-Path "C:\WSL\codyssey-ubuntu24")
  "`$ wsl.exe --version"
  (wsl.exe --version)
  "`$ wsl.exe --status"
  (wsl.exe --status)
  "`$ wsl.exe --list --verbose"
  (wsl.exe --list --verbose)
)

$log | Set-Content -Encoding utf8 docs\logs\windows-wsl-host.txt
```

WSL Ubuntu:

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

---

## 13. 트러블슈팅

### `--location`이 없음

```powershell
wsl.exe --update
wsl.exe --help | Select-String -SimpleMatch "--location"
```

### 설치 폴더가 비어 있지 않음

```powershell
Get-ChildItem -Force "C:\WSL\codyssey-ubuntu24"
```

기존 데이터를 확인하고 다른 빈 폴더를 사용합니다.

### 동일 배포판이 이미 설치됨

```powershell
wsl.exe --list --verbose
```

자동 unregister하지 않습니다.

### Docker Server 연결 실패

- Docker Desktop 실행 여부
- WSL 2 based engine
- Ubuntu-24.04 WSL Integration
- Linux containers mode

확인 후:

```powershell
wsl.exe --shutdown
```

---

## 14. 최종 체크리스트

- [ ] Windows 11 Pro 확인
- [ ] WSL 기능 설치
- [ ] WSL 업데이트 완료
- [ ] `--location` 지원 확인
- [ ] `C:\WSL` 폴더 생성
- [ ] 설치 디렉터리 이름을 `codyssey-ubuntu24`로 사용
- [ ] Ubuntu 24.04를 `C:\WSL\codyssey-ubuntu24`에 설치
- [ ] `Test-Path "C:\WSL\codyssey-ubuntu24"` 결과 `True`
- [ ] `wsl.exe --list --verbose`에서 `Ubuntu-24.04`, VERSION 2
- [ ] 프로젝트를 `/home/...`에 clone
- [ ] VS Code WSL 연결
- [ ] Docker Desktop WSL Integration 활성화
- [ ] 실제 로그와 스크린샷 저장
- [ ] 민감정보 확인

---

## 공식 참고자료

- Microsoft WSL 설치: <https://learn.microsoft.com/windows/wsl/install>
- Microsoft WSL 기본 명령: <https://learn.microsoft.com/windows/wsl/basic-commands>
- VS Code WSL: <https://code.visualstudio.com/docs/remote/wsl>
- Docker Desktop WSL 2 backend: <https://docs.docker.com/desktop/features/wsl/>
