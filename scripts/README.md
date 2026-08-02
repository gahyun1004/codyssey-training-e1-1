# Scripts

운영체제와 실행 위치에 따라 스크립트를 구분합니다.

- `open-vscode-remote.sh`: 기존 README 명령과 호환되는 진입점
- `macos/open-vscode-remote.sh`: Mac Terminal에서 OrbStack Ubuntu 저장소를 VS Code Remote-SSH로 여는 스크립트
- `ubuntu/verify-remote-workspace.sh`: Ubuntu 24.04, bash, workspace 경로, Git root를 검증하는 스크립트
- `ubuntu/select-port.sh`: Docker 실습에 사용할 수 있는 호스트 포트를 선택하는 스크립트

스크립트를 실행하기 전에 실행 위치가 Mac인지 Ubuntu인지 확인합니다.
