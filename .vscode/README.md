# VS Code workspace configuration

이 디렉터리는 두 Linux 원격 환경에서 동일한 프로젝트 터미널 동작을 제공합니다.

- macOS + OrbStack Ubuntu 24.04: VS Code Remote-SSH
- Windows 11 Pro + WSL2 Ubuntu 24.04: VS Code Remote-WSL

## 파일

- `settings.json`: Ubuntu bash, workspace cwd, split terminal cwd, shell integration
- `extensions.json`: Remote - SSH와 WSL 확장 추천
- `tasks.json`: 단계별 환경 검증, 증거 수집과 저장소 정적 검증 Task

## Task

| Task | 역할 |
|---|---|
| `E1-1: Verify Ubuntu Remote Workspace` | OrbStack·일반 Ubuntu, Git root와 Docker 연결 검증 |
| `E1-1: Verify WSL Ubuntu Workspace` | WSL2, Ubuntu 24.04, workspace와 Docker 연결 검증 |
| `E1-1: Verify WSL Before Docker` | Docker 설정 전 WSL·Ubuntu·workspace만 검증 |
| `E1-1: Collect Environment Evidence` | OS·Git·workspace 로그 생성과 기본 마스킹 |
| `E1-1: Collect Terminal and Permission Evidence` | 터미널·권한 변경 로그 생성과 기본 마스킹 |
| `E1-1: Collect Docker Evidence` | Docker Client·Server, 기본 운영과 hello-world 로그 생성 |
| `E1-1: Collect All Basic Evidence` | 세 단계의 기본 증거를 순서대로 수집 |
| `E1-1: Collect Evidence Without Docker` | Docker를 제외한 기본 증거 수집 |
| `E1-1: Validate Repository` | 필수 파일, 셸·JSON·링크·Dockerfile·PowerShell 검사 |

실행 방법:

```text
Ctrl/Command + Shift + P
→ Tasks: Run Task
→ 현재 목적에 맞는 E1-1 Task 선택
```

Task와 GitHub Actions는 셸 스크립트를 모두 `bash <path>` 방식으로 실행합니다. 따라서 Git 실행 비트에 의존하지 않고 동일한 호출 방식을 사용합니다.

`.vscode/settings.json`은 원격 연결이 완료된 뒤 적용됩니다. 원격 연결 자체는 Mac의 `code --remote` 또는 WSL Ubuntu의 `code .`이 담당합니다.

증거 수집 Task는 URL 자격정보와 사용자 홈 경로를 자동 마스킹하지만, 자동 처리는 보조 장치입니다. 생성된 로그를 직접 검토하고 실제 수행 결과와 일치할 때만 `docs/evidence-index.md`의 상태를 변경합니다.
