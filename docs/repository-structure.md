# 저장소 구조

README의 운영체제별 수행 경로와 실제 저장소 구조를 정리합니다.

```text
codyssey-training-e1-1/
├── README.md
├── Dockerfile
├── .dockerignore
├── .gitignore
├── .gitattributes
├── .github/
│   └── workflows/
│       └── validate.yml
├── .vscode/
│   ├── README.md
│   ├── settings.json
│   ├── extensions.json
│   └── tasks.json
├── scripts/
│   ├── README.md
│   ├── open-vscode-remote.sh
│   ├── ci/
│   │   ├── check-dockerfile.sh
│   │   ├── check-markdown-links.py
│   │   └── check-powershell-syntax.ps1
│   ├── macos/
│   │   └── open-vscode-remote.sh
│   ├── windows/
│   │   ├── setup-wsl.ps1
│   │   ├── open-vscode-wsl.ps1
│   │   └── collect-wsl-host-evidence.ps1
│   └── ubuntu/
│       ├── lib/
│       │   └── redact.sh
│       ├── verify-remote-workspace.sh
│       ├── verify-wsl-workspace.sh
│       ├── select-port.sh
│       ├── collect-environment.sh
│       ├── collect-terminal-permissions.sh
│       ├── collect-docker-evidence.sh
│       ├── collect-evidence.sh
│       └── validate-repository.sh
├── site/
│   └── index.html
├── bind-test/
│   └── index.html
├── practice/
│   ├── README.md
│   ├── terminal/.gitkeep
│   └── permissions/
│       ├── .gitkeep
│       └── permission-dir/.gitkeep
└── docs/
    ├── macos-orbstack-guide.md
    ├── windows-wsl.md
    ├── repository-audit.md
    ├── evidence-index.md
    ├── repository-structure.md
    ├── environment.md
    ├── terminal-and-permissions.md
    ├── docker-operations.md
    ├── image-design.md
    ├── port-and-bind.md
    ├── volume-persistence.md
    ├── test-results.md
    ├── troubleshooting.md
    ├── logs/README.md
    └── screenshots/
        ├── README.md
        ├── environment/.gitkeep
        ├── windows-wsl/.gitkeep
        ├── terminal/.gitkeep
        ├── permissions/.gitkeep
        ├── docker/.gitkeep
        ├── port-mapping/.gitkeep
        ├── bind-mount/.gitkeep
        ├── volume/.gitkeep
        ├── github/.gitkeep
        └── vscode/.gitkeep
```

## 플랫폼별 진입점

| 플랫폼 | 진입점 | Linux 환경 | VS Code 방식 |
|---|---|---|---|
| macOS | `scripts/macos/open-vscode-remote.sh` | OrbStack Ubuntu 24.04 | Remote-SSH |
| Windows 11 Pro | `scripts/windows/open-vscode-wsl.ps1` | WSL2 Ubuntu 24.04 | Remote-WSL |

## 검증과 증거 도구

| 스크립트 | 역할 |
|---|---|
| `scripts/ubuntu/verify-remote-workspace.sh` | 일반 Ubuntu 원격 workspace와 Docker 연결 검증 |
| `scripts/ubuntu/verify-wsl-workspace.sh` | WSL workspace와 Docker 연결 검증 |
| `scripts/ubuntu/select-port.sh` | Linux·WSL·OrbStack·Docker 포트 충돌 검사 |
| `scripts/ubuntu/collect-environment.sh` | 환경·Git 로그 생성과 기본 마스킹 |
| `scripts/ubuntu/collect-terminal-permissions.sh` | 터미널·권한 로그 생성과 기본 마스킹 |
| `scripts/ubuntu/collect-docker-evidence.sh` | Docker 기본 운영과 hello-world 로그 생성 |
| `scripts/ubuntu/collect-evidence.sh` | 단계별 수집 스크립트 통합 실행 |
| `scripts/ubuntu/lib/redact.sh` | URL 자격정보와 사용자 홈 경로 마스킹 |
| `scripts/ubuntu/validate-repository.sh` | 저장소 구조·문법·링크·Dockerfile 정적 검증 |
| `scripts/windows/collect-wsl-host-evidence.ps1` | Windows·WSL 호스트 로그 생성과 경로 마스킹 |

## CI 도구

| 파일 | 검사 항목 |
|---|---|
| `scripts/ci/check-dockerfile.sh` | NGINX 태그·digest와 필수 Dockerfile 항목 |
| `scripts/ci/check-markdown-links.py` | 저장소 내부 Markdown 상대 링크 |
| `scripts/ci/check-powershell-syntax.ps1` | PowerShell parser 기반 문법 |
| `.github/workflows/validate.yml` | ShellCheck, PowerShell, Docker build와 HTTP smoke test |

## 자동 검증

GitHub Actions는 Ubuntu 24.04 runner에서 다음 항목을 확인합니다.

1. 필수 파일과 JSON·셸 문법
2. Markdown 상대 링크
3. Dockerfile 베이스 태그와 multi-platform index digest 고정
4. ShellCheck
5. PowerShell parser와 PSScriptAnalyzer
6. Docker 이미지 빌드
7. 컨테이너 실행과 HTTP smoke test

자동 검증은 저장소 재현성을 보조하지만 개인 장비에서 생성해야 하는 로그와 스크린샷을 대신하지 않습니다.

## 구분 원칙

- `site/`: Docker 이미지에 포함되는 정적 웹 콘텐츠
- `bind-test/`: 바인드 마운트 변경 전후 확인용 콘텐츠
- `practice/`: CLI와 권한 실습용 파일
- `docs/logs/`: 실제 명령과 출력 결과
- `docs/screenshots/`: 실제 수행 화면 증거
- `.gitkeep`: 빈 폴더 구조 유지용이며 실습 증거가 아님
- `.gitattributes`: Windows와 Linux 간 줄바꿈 차이 제어

## 문서 역할

- `README.md`: 환경 선택, 공통 수행 순서와 최종 체크리스트
- `macos-orbstack-guide.md`: macOS·OrbStack 상세 가이드
- `windows-wsl.md`: Windows·WSL 상세 가이드
- `repository-audit.md`: 저장소 보완 사항과 남은 수동 작업
- `evidence-index.md`: 수행 항목별 완료 상태와 증거 링크
