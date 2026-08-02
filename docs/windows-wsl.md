# Windows 11 Pro + WSL2 + Ubuntu 24.04 수행 가이드

이 문서는 Windows 11 Pro에서 WSL2 Ubuntu 24.04를 지정 위치에 설치하고, WSL Linux 홈의 Git 저장소를 VS Code Remote-WSL과 Docker Desktop으로 사용하는 절차입니다.

## 경로 구분

| 구분 | 값 |
|---|---|
| WSL 배포판 이름 | `Ubuntu-24.04` |
| 설치 루트 | `C:\WSL` |
| 설치 디렉터리 이름 | `codyssey-ubuntu24` |
| Ubuntu 데이터 위치 | `C:\WSL\codyssey-ubuntu24` |
| 프로젝트 작업 위치 | `/home/<사용자>/codyssey-training/codyssey-training-e1-1` |

`C:\WSL\codyssey-ubuntu24`는 Ubuntu 가상 디스크와 시스템 데이터 위치입니다. 프로젝트 소스는 이 폴더 안에 직접 만들지 않고 WSL 내부의 `/home/...`에 clone합니다.

---

## 1. Windows 11 Pro 확인

일반 PowerShell에서:

```powershell
Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber

$env:PROCESSOR_ARCHITECTURE
```

결과는 `docs/logs/windows-wsl-host.txt`에 기록하고 Windows 11 Pro 화면을 캡처합니다.

---

## 2. WSL 기능 설치

관리자 권한 Windows Terminal 또는 PowerShell에서:

```powershell
wsl.exe --install --no-distribution
```

재시작이 요구되면 Windows를 재시작합니다. WSL이 이미 설치되어 있다면 위 명령은 건너뜁니다.

```powershell
wsl.exe --update
wsl.exe --set-default-version 2
wsl.exe --version
wsl.exe --status
wsl.exe --help | Select-String -SimpleMatch "--location"
```

`--location`이 표시되지 않으면 WSL, Windows Update와 Microsoft Store WSL을 업데이트한 뒤 재시작합니다.

---

## 3. Ubuntu 24.04 지정 위치 설치

```powershell
New-Item -ItemType Directory -Force -Path "C:\WSL"
Test-Path "C:\WSL"
wsl.exe --list --online
```

정상 기준:

- `Test-Path` 결과가 `True`
- 온라인 목록에 `Ubuntu-24.04`가 있음

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

설치 보조 스크립트:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

---

## 4. 설치 상태 확인

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

## 5. Ubuntu 초기 설정

```powershell
wsl.exe -d Ubuntu-24.04
```

WSL Ubuntu에서:

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

```bash
sudo apt update
sudo apt install -y \
  ca-certificates curl wget git gnupg nano vim tree jq tar unzip zip

git config --global init.defaultBranch main
git config --global user.name "본인의 Git 이름"
git config --global user.email "본인의 GitHub 이메일"
git config --list
```

GitHub CLI는 선택 사항입니다. clone과 push는 `git`만으로 수행할 수 있습니다.

---

## 6. 프로젝트 clone

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

`pwd`가 `/mnt/c/...`로 시작한다면 Git·Docker·권한 실습 전에 Linux 홈으로 다시 clone합니다.

---

## 7. VS Code Remote-WSL

Windows PowerShell에서:

```powershell
code --version
code --install-extension ms-vscode-remote.remote-wsl
```

WSL Ubuntu 저장소 루트에서:

```bash
code .
```

Windows 보조 스크립트:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\open-vscode-wsl.ps1
```

성공 기준:

- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- Explorer 최상단 폴더가 `codyssey-training-e1-1`
- 새 터미널 프로세스가 `bash`
- `pwd`와 Git root가 저장소 루트

Docker Desktop 설정 전 사전 검증:

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh --skip-docker
```

이 결과는 Docker 포함 최종 환경 완료 증거가 아닙니다.

---

## 8. Docker Desktop WSL Integration

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

WSL Ubuntu에서:

```bash
docker --version
docker context show
docker version
docker info
docker run --rm hello-world
```

Docker Desktop을 사용하는 경우 WSL Ubuntu에 Docker Engine을 중복 설치하지 않습니다.

Docker 포함 최종 검증:

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh
```

Docker CLI가 없거나 Server 연결이 실패하면 이 검증도 실패합니다.

---

## 9. Windows 호스트 로그

PowerShell 상대 경로 혼동을 방지하기 위해 전용 스크립트를 사용합니다. 스크립트가 WSL 저장소의 Windows 경로를 계산해 로그를 저장합니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\collect-wsl-host-evidence.ps1
```

생성 파일:

```text
docs/logs/windows-wsl-host.txt
```

스크립트는 URL 자격정보와 Windows·WSL 사용자 홈 경로를 기본적으로 마스킹합니다. 자동 마스킹 후에도 로그 전체를 직접 검토합니다.

---

## 10. 단계별 Ubuntu 로그

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

전체 순차 실행:

```bash
bash scripts/ubuntu/collect-evidence.sh
```

Docker 설정 전에는:

```bash
bash scripts/ubuntu/collect-evidence.sh --skip-docker
```

Docker만 다시 수집할 때는:

```bash
bash scripts/ubuntu/collect-evidence.sh --docker-only
```

생성되는 주요 로그:

```text
docs/logs/environment.txt
docs/logs/windows-wsl-environment.txt
docs/logs/windows-wsl-docker.txt
docs/logs/terminal-basic.txt
docs/logs/permissions.txt
docs/logs/docker-basic.txt
docs/logs/hello-world.txt
```

`attach`·`exec`, 커스텀 이미지 build, 포트, 바인드 마운트, 볼륨과 화면 캡처는 README 절차에 따라 직접 수행합니다.

---

## 11. 필수 화면 증거

- Windows 11 Pro 제품명·버전·빌드
- `wsl.exe --version`
- `--location` 옵션
- `C:\WSL\codyssey-ubuntu24`와 `Test-Path` 결과
- `wsl.exe --list --verbose`의 `Ubuntu-24.04`, `VERSION 2`
- Docker Desktop의 Ubuntu 24.04 WSL Integration
- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- WSL 터미널의 Ubuntu 24.04, bash, `pwd`, Git root·branch

파일명은 [스크린샷 안내](screenshots/README.md)를 따릅니다.

---

## 12. 대표 오류

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

### VS Code가 Windows 로컬 창으로 열림

```bash
code .
```

WSL Ubuntu 저장소에서 다시 실행합니다.

### Docker Server 연결 실패

- Docker Desktop 실행 여부
- WSL 2 based engine
- `Ubuntu-24.04` WSL Integration
- Linux containers mode

확인 후:

```powershell
wsl.exe --shutdown
```

---

## 13. 최종 체크리스트

- [ ] Windows 11 Pro 확인
- [ ] WSL 설치·업데이트
- [ ] 기본 WSL 버전 2 설정
- [ ] `--location` 지원 확인
- [ ] `C:\WSL\codyssey-ubuntu24` 설치
- [ ] `Ubuntu-24.04`, VERSION 2 확인
- [ ] 프로젝트를 `/home/...`에 clone
- [ ] VS Code Remote-WSL 연결
- [ ] Docker Desktop WSL Integration 활성화
- [ ] Docker 포함 WSL 검증 성공
- [ ] Windows 호스트 로그 생성·검토
- [ ] 단계별 Ubuntu 로그 생성·검토
- [ ] 필수 화면 캡처
- [ ] 자동 마스킹 후 민감정보 재확인

---

## 공식 참고자료

- Microsoft WSL 설치: <https://learn.microsoft.com/windows/wsl/install>
- Microsoft WSL 기본 명령: <https://learn.microsoft.com/windows/wsl/basic-commands>
- VS Code WSL: <https://code.visualstudio.com/docs/remote/wsl>
- Docker Desktop WSL 2 backend: <https://docs.docker.com/desktop/features/wsl/>
