# VS Code workspace configuration

이 디렉터리는 두 Linux 원격 환경에서 동일한 프로젝트 터미널 동작을 제공합니다.

- macOS + OrbStack Ubuntu 24.04: VS Code Remote-SSH
- Windows 11 Pro + WSL2 Ubuntu 24.04: VS Code Remote-WSL

## 파일

- `settings.json`: Ubuntu bash, workspace cwd, split terminal cwd, shell integration
- `extensions.json`: Remote - SSH와 WSL 확장 추천
- `tasks.json`: 환경 검증, 기본 로그 수집, 저장소 정적 검증 Task

## Task

| Task | 역할 |
|---|---|
| `E1-1: Verify Ubuntu Remote Workspace` | OrbStack·일반 Ubuntu, Git root와 Docker 연결 검증 |
| `E1-1: Verify WSL Ubuntu Workspace` | WSL2, Ubuntu 24.04, workspace와 Docker 상태 검증 |
| `E1-1: Collect Basic Evidence Logs` | 환경·터미널·권한·Docker 기본 로그 생성 |
| `E1-1: Validate Repository` | 필수 파일, 셸·JSON 문법과 Dockerfile 구조 검증 |

실행 방법:

```text
Ctrl/Command + Shift + P
→ Tasks: Run Task
→ 현재 목적에 맞는 E1-1 Task 선택
```

Task는 `bash`를 통해 스크립트를 실행하므로 새로 clone한 환경에서 실행 권한 비트가 예상과 다를 때도 동작합니다. 제출 전에는 다음 명령으로 실행 권한도 확인합니다.

```bash
chmod +x scripts/open-vscode-remote.sh
chmod +x scripts/macos/open-vscode-remote.sh
chmod +x scripts/ubuntu/*.sh
```

`.vscode/settings.json`은 원격 연결이 완료된 뒤 적용됩니다. 원격 연결 자체는 Mac의 `code --remote` 또는 WSL Ubuntu의 `code .`이 담당합니다.

기본 로그 수집 Task가 생성한 파일도 실제 내용을 확인하고 민감정보를 마스킹한 뒤 사용합니다. 자동 생성만으로 증거 상태를 `완료`로 변경하지 않습니다.
