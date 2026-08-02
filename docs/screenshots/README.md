# 스크린샷 증거 안내

다음 폴더 구조에 실제 캡처를 저장합니다.

```text
docs/screenshots/
├── environment/
├── windows-wsl/
├── terminal/
├── permissions/
├── docker/
├── port-mapping/
├── bind-mount/
├── volume/
├── github/
└── vscode/
```

## 파일명 예시

```text
environment/01-orbstack-ubuntu.png
windows-wsl/01-windows-11-pro-version.png
windows-wsl/02-wsl-list-verbose.png
windows-wsl/03-docker-desktop-wsl-integration.png
terminal/01-basic-commands.png
permissions/01-file-permission.png
permissions/02-directory-permission.png
docker/01-docker-version-info.png
docker/02-attach-exec.png
port-mapping/01-browser-response.png
bind-mount/01-before.png
bind-mount/02-after.png
volume/01-volume-persistence.png
github/01-vscode-github-login.png
github/02-source-control-repository.png
vscode/01-remote-ssh-path-branch.png
vscode/02-remote-wsl-path-branch.png
```

## Windows·WSL 필수 캡처

- Windows 11 Pro 버전과 빌드
- `wsl.exe --version`
- `wsl.exe --list --verbose`의 `Ubuntu-24.04`, `VERSION 2`
- Docker Desktop의 `Ubuntu-24.04` WSL Integration
- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- WSL 터미널의 Ubuntu 24.04, bash, `pwd`, Git branch

## 공통 캡처 기준

- 명령어 입력과 출력 결과가 함께 보이게 합니다.
- 브라우저 캡처에는 주소창과 포트를 포함합니다.
- 토큰, 비밀번호, 이메일, 개인키, 인증 코드, 학교·기관 내부정보를 제거하거나 마스킹합니다.
- `.gitkeep`은 증거가 아닙니다.
