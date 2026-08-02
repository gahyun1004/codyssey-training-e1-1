# 스크린샷 증거 안내

다음 폴더 구조에 본인이 직접 수행한 실제 캡처를 저장합니다. 자동화 스크립트나 GitHub Actions 결과만으로 개인 장비의 화면 증거를 대체할 수 없습니다.

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
windows-wsl/02-wsl-location-option.png
windows-wsl/03-c-wsl-codyssey-ubuntu24-folder.png
windows-wsl/04-wsl-list-verbose.png
windows-wsl/05-docker-desktop-wsl-integration.png
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

## 플랫폼 선택 원칙

- Windows 11 Pro + WSL2로 수행했다면 Windows·WSL, Remote-WSL 증거를 저장하고 macOS·Remote-SSH 항목은 `해당 없음`으로 표시합니다.
- macOS + OrbStack으로 수행했다면 macOS·Remote-SSH 증거를 저장하고 Windows·WSL 항목은 `해당 없음`으로 표시합니다.
- 두 플랫폼을 모두 수행할 필요는 없습니다.

## Windows·WSL 필수 캡처

- Windows 11 Pro 버전과 빌드
- `wsl.exe --version`
- `wsl.exe --help`에서 `--location` 옵션 확인
- `C:\WSL\codyssey-ubuntu24` 폴더와 `Test-Path` 결과
- `wsl.exe --list --verbose`의 `Ubuntu-24.04`, `VERSION 2`
- Docker Desktop의 `Ubuntu-24.04` WSL Integration
- VS Code 왼쪽 아래 `WSL: Ubuntu-24.04`
- WSL 터미널의 Ubuntu 24.04, bash, `pwd`, Git root와 branch

## 공통 필수 캡처

- 터미널 기본 명령과 출력
- 파일·디렉터리 권한 변경 전후
- Docker Client·Server와 hello-world
- Ubuntu 컨테이너의 `attach`와 `exec`
- 커스텀 이미지 build 결과
- 브라우저 주소창과 선택한 포트, 실제 페이지
- 바인드 마운트 변경 전후
- 컨테이너 삭제 후에도 남은 볼륨 데이터
- VS Code Source Control과 GitHub 저장소·최신 commit

## 경로 캡처 시 주의

- 배포판 설치 위치는 `C:\WSL\codyssey-ubuntu24`입니다.
- WSL 배포판 이름은 `Ubuntu-24.04`입니다.
- 프로젝트 workspace는 WSL Linux 홈의 `/home/<사용자>/...`입니다.
- Windows 사용자 이름과 개인 경로는 필요하면 마스킹합니다.
- `C:\WSL\codyssey-ubuntu24` 내부 파일을 임의로 수정하지 않습니다.

## 공통 캡처 기준

- 명령어 입력과 출력 결과가 함께 보이게 합니다.
- 브라우저 캡처에는 주소창과 포트를 포함합니다.
- 화면을 과도하게 잘라 실행 환경을 판단할 수 없게 만들지 않습니다.
- 토큰, 비밀번호, 이메일, 개인키, 인증 코드, 학교·기관 내부정보를 제거하거나 마스킹합니다.
- `.gitkeep`은 증거가 아닙니다.
