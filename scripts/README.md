# Scripts

운영체제와 실행 위치에 따라 스크립트를 구분합니다. 스크립트는 절차와 로그 생성을 보조하지만 실제 수행 화면과 관찰 결과를 대신하지 않습니다.

## macOS

- `open-vscode-remote.sh`: 기존 README 명령과 호환되는 진입점
- `macos/open-vscode-remote.sh`: OrbStack Ubuntu 저장소를 VS Code Remote-SSH로 실행

```bash
bash scripts/open-vscode-remote.sh
```

## Windows

- `windows/setup-wsl.ps1`: WSL2와 Ubuntu 24.04를 지정 폴더에 설치하고 상태를 점검
- `windows/open-vscode-wsl.ps1`: `Ubuntu-24.04` 저장소에서 `code .` 실행
- `windows/collect-wsl-host-evidence.ps1`: Windows·WSL 호스트 정보를 WSL 저장소 로그로 저장

기본 설치 값:

```text
Distribution          = Ubuntu-24.04
InstallRoot           = C:\WSL
InstallDirectoryName  = codyssey-ubuntu24
InstallPath           = C:\WSL\codyssey-ubuntu24
```

PowerShell 실행 예시:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
.\scripts\windows\open-vscode-wsl.ps1
.\scripts\windows\collect-wsl-host-evidence.ps1
```

다른 설치 루트 또는 디렉터리 이름:

```powershell
.\scripts\windows\setup-wsl.ps1 `
  -Distribution "Ubuntu-24.04" `
  -InstallRoot "D:\WSL" `
  -InstallDirectoryName "codyssey-ubuntu24"
```

`setup-wsl.ps1`은 기존 배포판을 자동으로 unregister하거나 이동하지 않습니다. 이미 설치된 배포판의 위치 변경은 별도 백업·export·import 절차로 처리합니다.

## Ubuntu·WSL

- `ubuntu/verify-remote-workspace.sh`: Ubuntu 24.04, bash, workspace, Git root와 Docker 연결 검증
- `ubuntu/verify-wsl-workspace.sh`: WSL2, Ubuntu 24.04, bash, workspace와 Docker 상태 검증
- `ubuntu/select-port.sh`: `ss`, `lsof`, OrbStack 호스트와 Docker 게시 포트를 확인해 사용 가능한 포트 선택
- `ubuntu/collect-evidence.sh`: 환경·터미널·권한·Docker 기본 로그 생성
- `ubuntu/validate-repository.sh`: 필수 파일, 셸 문법, JSON과 Dockerfile 구조 검증

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh
bash scripts/ubuntu/collect-evidence.sh
bash scripts/ubuntu/validate-repository.sh
```

## 실행 전 확인

1. 현재 위치가 macOS, Windows PowerShell, WSL Ubuntu 또는 OrbStack Ubuntu 중 어디인지 확인합니다.
2. 저장소 루트에서 실행합니다.
3. 자동 생성 로그를 검토하고 민감정보를 마스킹합니다.
4. 실제 검증 후에만 `docs/evidence-index.md` 상태를 `완료`로 변경합니다.
