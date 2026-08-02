# Scripts

운영체제와 실행 위치에 따라 스크립트를 구분합니다.

## macOS

- `open-vscode-remote.sh`: 기존 README 명령과 호환되는 진입점
- `macos/open-vscode-remote.sh`: OrbStack Ubuntu 저장소를 VS Code Remote-SSH로 실행

## Windows

- `windows/setup-wsl.ps1`: WSL2와 Ubuntu 24.04를 지정 폴더에 설치하고 상태를 점검
- `windows/open-vscode-wsl.ps1`: Ubuntu-24.04 저장소에서 `code .` 실행

기본 설치 값:

```text
Distribution = Ubuntu-24.04
InstallRoot  = C:\WSL
InstallPath  = C:\WSL\Ubuntu-24.04
```

PowerShell 스크립트 실행 예시:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
.\scripts\windows\open-vscode-wsl.ps1
```

다른 설치 루트 지정:

```powershell
.\scripts\windows\setup-wsl.ps1 `
  -Distribution "Ubuntu-24.04" `
  -InstallRoot "D:\WSL"
```

`setup-wsl.ps1`은 기존 배포판을 자동으로 unregister하거나 이동하지 않습니다. 이미 설치된 배포판의 위치를 변경해야 하는 경우에는 별도 백업·export·import 절차를 사용합니다.

## Ubuntu

- `ubuntu/verify-remote-workspace.sh`: Ubuntu 24.04, bash, workspace, Git root 검증
- `ubuntu/verify-wsl-workspace.sh`: WSL2, Ubuntu 24.04, bash, workspace, Docker 검증
- `ubuntu/select-port.sh`: Docker 실습에 사용할 수 있는 포트 선택

스크립트를 실행하기 전에 현재 위치가 macOS, Windows PowerShell, WSL Ubuntu 또는 OrbStack Ubuntu 중 어디인지 확인합니다.
