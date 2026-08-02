# VS Code workspace configuration

이 디렉터리는 OrbStack Ubuntu 24.04를 VS Code Remote-SSH로 열었을 때 프로젝트 터미널이 Ubuntu bash와 현재 workspace 폴더에서 시작되도록 설정합니다.

- `settings.json`: Ubuntu bash, workspace cwd, split terminal cwd, shell integration
- `extensions.json`: Remote - SSH 확장 추천
- `tasks.json`: Ubuntu 버전·bash·workspace 경로·Git root 검증

이 설정은 Remote-SSH 연결이 완료된 뒤 적용됩니다. SSH 연결 자체는 Mac의 `code --remote` 명령 또는 `scripts/open-vscode-remote.sh`가 담당합니다.
