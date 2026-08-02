# 실행 환경

> 실제 수행 결과로 이 문서를 채웁니다. 사용하지 않은 플랫폼 항목은 `해당 없음`으로 표시합니다.

## 공통 정보

- 수행 플랫폼:
- Ubuntu:
- Shell:
- Git:
- GitHub CLI:
- VS Code:
- Docker Client:
- Docker Server:
- 작업 브랜치:

## macOS + OrbStack

- macOS:
- Terminal:
- OrbStack:
- OrbStack machine:
- Remote-SSH host: `codyssey-training@orb`
- VS Code 상태 표시:

## Windows 11 Pro + WSL2

- Windows 제품명:
- Windows 버전:
- OS 빌드:
- WSL 버전:
- `--location` 옵션 지원:
- 배포판: `Ubuntu-24.04`
- WSL mode: `2`
- WSL 설치 루트: `C:\WSL`
- Ubuntu 배포판 설치 위치: `C:\WSL\Ubuntu-24.04`
- `Test-Path "C:\WSL\Ubuntu-24.04"` 결과:
- `WSL_DISTRO_NAME`:
- 프로젝트 저장소 경로: `/home/<사용자>/codyssey-training/codyssey-training-e1-1`
- VS Code 상태 표시: `WSL: Ubuntu-24.04`
- Docker Desktop:
- Docker Desktop WSL Integration:

## Git 설정 확인

- `user.name`:
- `user.email`: 공개 시 일부 마스킹
- `init.defaultBranch`: `main`
- `remote.origin.url`:

## Ubuntu 검증 명령

```bash
cat /etc/os-release
uname -a
echo "${WSL_DISTRO_NAME:-not-wsl}"
echo "$SHELL"
pwd
git rev-parse --show-toplevel
git --version
gh --version | head -n 1
docker --version
docker version
git config --list
```

## Windows 호스트 검증 명령

```powershell
Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber

wsl.exe --version
wsl.exe --status
wsl.exe --help | Select-String -SimpleMatch "--location"
wsl.exe --list --verbose
Test-Path "C:\WSL\Ubuntu-24.04"
Get-ChildItem -Force "C:\WSL\Ubuntu-24.04"
code --version
```

## 원본 로그

- 공통 Ubuntu: `docs/logs/environment.txt`
- Windows 호스트: `docs/logs/windows-wsl-host.txt`
- WSL Ubuntu: `docs/logs/windows-wsl-environment.txt`
