# Scripts

운영체제와 실행 위치에 따라 스크립트를 구분합니다. 스크립트는 절차와 로그 생성을 보조하지만 실제 수행 화면과 관찰 결과를 대신하지 않습니다.

## 실행 정책

저장소의 셸 스크립트는 다음 형식으로 실행합니다.

```bash
bash scripts/ubuntu/<script-name>.sh
```

VS Code Task와 GitHub Actions도 동일하게 `bash <path>`를 사용합니다. 따라서 Git 실행 비트에 의존하지 않으며, `scripts/ubuntu/validate-repository.sh`가 모든 셸 스크립트의 문법과 호출 경로를 검사합니다.

## macOS

- `open-vscode-remote.sh`: 기존 README 명령과 호환되는 진입점
- `macos/open-vscode-remote.sh`: OrbStack Ubuntu 저장소를 VS Code Remote-SSH로 실행

```bash
bash scripts/open-vscode-remote.sh
```

## Windows

- `windows/setup-wsl.ps1`: WSL2와 Ubuntu 24.04를 지정 폴더에 설치하고 상태 점검
- `windows/open-vscode-wsl.ps1`: `Ubuntu-24.04` 저장소에서 `code .` 실행
- `windows/collect-wsl-host-evidence.ps1`: Windows·WSL 호스트 정보를 WSL 저장소 로그로 저장하고 사용자 경로를 마스킹

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

`setup-wsl.ps1`은 기존 배포판을 자동으로 unregister하거나 이동하지 않습니다. 이미 설치된 배포판의 위치 변경은 별도 백업·export·import 절차로 처리합니다.

## Ubuntu·WSL 환경 검증

- `ubuntu/verify-remote-workspace.sh`: 일반 Ubuntu·OrbStack의 Ubuntu 24.04, bash, workspace, Git root와 Docker 연결 검증
- `ubuntu/verify-wsl-workspace.sh`: WSL2, Ubuntu 24.04, bash, workspace, Git root와 Docker 연결 검증
- `ubuntu/select-port.sh`: `ss`, `lsof`, OrbStack 호스트와 Docker 게시 포트를 확인해 사용 가능한 포트 선택

기본 검증은 Docker Client·Server 연결 실패를 오류로 처리합니다.

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh
bash scripts/ubuntu/verify-remote-workspace.sh
```

Docker 설정 전 단계만 확인할 때:

```bash
bash scripts/ubuntu/verify-wsl-workspace.sh --skip-docker
bash scripts/ubuntu/verify-remote-workspace.sh --skip-docker
```

## 단계별 증거 수집

- `ubuntu/collect-environment.sh`: OS·Git·workspace 환경 로그
- `ubuntu/collect-terminal-permissions.sh`: 터미널과 파일·디렉터리 권한 로그
- `ubuntu/collect-docker-evidence.sh`: Docker Client·Server, 기본 운영과 hello-world 로그
- `ubuntu/collect-evidence.sh`: 위 세 단계를 순서대로 호출
- `ubuntu/lib/redact.sh`: URL 자격정보와 사용자 홈 경로 마스킹

전체 수집:

```bash
bash scripts/ubuntu/collect-evidence.sh
```

Docker 설정 전:

```bash
bash scripts/ubuntu/collect-evidence.sh --skip-docker
```

Docker만 다시 수집:

```bash
bash scripts/ubuntu/collect-evidence.sh --docker-only
```

자동 마스킹은 보조 장치입니다. 커밋 전에 로그 전체를 직접 검토합니다.

## 저장소·CI 검증

- `ubuntu/validate-repository.sh`: 필수 파일, 셸·JSON·PowerShell 문법, Markdown 상대 링크, Dockerfile 고정 상태와 기본 비밀 패턴 검증
- `ci/check-markdown-links.py`: Markdown 상대 링크 검사
- `ci/check-powershell-syntax.ps1`: PowerShell parser 기반 문법 검사
- `ci/check-dockerfile.sh`: NGINX 태그·digest와 필수 Dockerfile 항목 검사

```bash
bash scripts/ubuntu/validate-repository.sh
```

GitHub Actions는 Ubuntu 24.04 runner에서 ShellCheck, PowerShell parser, PSScriptAnalyzer, Docker build와 HTTP smoke test까지 수행합니다.

## 실행 전 확인

1. 현재 위치가 macOS, Windows PowerShell, WSL Ubuntu 또는 OrbStack Ubuntu 중 어디인지 확인합니다.
2. 저장소 루트에서 실행합니다.
3. 자동 생성 로그의 마스킹 결과와 실제 내용을 검토합니다.
4. 실제 검증 후에만 `docs/evidence-index.md` 상태를 `완료`로 변경합니다.
