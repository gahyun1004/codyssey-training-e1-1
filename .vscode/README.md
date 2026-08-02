# VS Code workspace configuration

이 디렉터리는 두 Linux 원격 환경에서 동일한 프로젝트 터미널 동작을 제공합니다.

- macOS + OrbStack Ubuntu 24.04: VS Code Remote-SSH
- Windows 11 Pro + WSL2 Ubuntu 24.04: VS Code Remote-WSL

## 파일

- `settings.json`: Ubuntu bash, workspace cwd, split terminal cwd, shell integration
- `extensions.json`: Remote - SSH와 WSL 확장 추천
- `tasks.json`: OrbStack·일반 Ubuntu 검증 Task와 WSL 전용 검증 Task

## Task

```text
E1-1: Verify Ubuntu Remote Workspace
```

`scripts/ubuntu/verify-remote-workspace.sh`를 실행합니다.

```text
E1-1: Verify WSL Ubuntu Workspace
```

`scripts/ubuntu/verify-wsl-workspace.sh`를 실행합니다.

`.vscode/settings.json`은 원격 연결이 완료된 뒤 적용됩니다. 원격 연결 자체는 Mac의 `code --remote` 또는 WSL Ubuntu의 `code .`이 담당합니다.
