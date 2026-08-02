# 실행 환경

> 실제 수행 결과로 이 문서를 채웁니다. 사용하지 않은 플랫폼은 `해당 없음`으로 표시합니다. 안내 문구만 채운 상태는 완료가 아닙니다.

## 1. 수행 플랫폼 선택

- 선택한 호스트 OS:
- 선택한 Linux 환경:
- VS Code 연결 방식:
- Docker backend:
- 수행 날짜:
- 검증한 Git commit SHA:

## 2. 공통 정보

- Ubuntu:
- Shell:
- Git:
- GitHub CLI: 설치 / 미설치 / 해당 없음
- VS Code:
- Docker Client:
- Docker Server:
- 작업 브랜치:
- Git root:

## 3. macOS + OrbStack

사용하지 않았다면 첫 줄에 `해당 없음 — Windows 11 Pro + WSL2에서 수행`이라고 기록합니다.

- 상태:
- macOS:
- Terminal:
- OrbStack:
- OrbStack machine:
- Remote-SSH host: `codyssey-training@orb`
- VS Code 상태 표시:

## 4. Windows 11 Pro + WSL2

사용하지 않았다면 첫 줄에 `해당 없음 — macOS + OrbStack에서 수행`이라고 기록합니다.

- 상태:
- Windows 제품명:
- Windows 버전:
- OS 빌드:
- WSL 버전:
- `--location` 옵션 지원:
- 배포판: `Ubuntu-24.04`
- WSL mode: `2`
- WSL 설치 루트: `C:\WSL`
- 설치 디렉터리 이름: `codyssey-ubuntu24`
- Ubuntu 배포판 설치 위치: `C:\WSL\codyssey-ubuntu24`
- `Test-Path "C:\WSL\codyssey-ubuntu24"` 결과:
- `WSL_DISTRO_NAME`:
- 프로젝트 저장소 경로: `/home/<사용자>/codyssey-training/codyssey-training-e1-1`
- VS Code 상태 표시: `WSL: Ubuntu-24.04`
- Docker Desktop:
- Docker Desktop WSL Integration:

## 5. Git 설정 확인

- `user.name`:
- `user.email`: 공개 저장소에서는 일부 마스킹
- `init.defaultBranch`: `main`
- `remote.origin.url`:
- 현재 branch:
- 최신 commit:

## 6. Ubuntu 검증 명령

```bash
cat /etc/os-release
uname -a
echo "${WSL_DISTRO_NAME:-not-wsl}"
echo "$SHELL"
ps -p $$ -o comm=
pwd
git rev-parse --show-toplevel
git branch --show-current
git --version
docker --version
docker version
git config --list
```

GitHub CLI는 선택 사항입니다. 설치한 경우에만 다음을 확인합니다.

```bash
gh --version | head -n 1
gh auth status
```

## 7. Windows 호스트 검증 명령

```powershell
Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber

wsl.exe --version
wsl.exe --status
wsl.exe --help | Select-String -SimpleMatch "--location"
wsl.exe --list --verbose
Test-Path "C:\WSL\codyssey-ubuntu24"
Get-ChildItem -Force "C:\WSL\codyssey-ubuntu24"
code --version
```

## 8. 로그 생성 도구

Windows PowerShell에서 WSL 저장소의 호스트 로그를 생성합니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\collect-wsl-host-evidence.ps1
```

WSL·Ubuntu 저장소 루트에서 기본 환경·터미널·권한·Docker 로그를 생성합니다.

```bash
bash scripts/ubuntu/collect-evidence.sh
```

자동 생성 로그는 반드시 내용을 검토하고 민감정보를 마스킹한 뒤 커밋합니다.

## 9. 원본 로그

- 공통 Ubuntu: `docs/logs/environment.txt`
- Windows 호스트: `docs/logs/windows-wsl-host.txt`
- WSL Ubuntu: `docs/logs/windows-wsl-environment.txt`
- WSL Docker: `docs/logs/windows-wsl-docker.txt`
