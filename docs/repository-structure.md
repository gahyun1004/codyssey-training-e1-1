# 저장소 구조

README의 운영체제별 수행 경로와 실제 저장소 구조를 정리합니다.

```text
codyssey-training-e1-1/
├── README.md
├── Dockerfile
├── .dockerignore
├── .gitignore
├── .gitattributes
├── .vscode/
│   ├── README.md
│   ├── settings.json
│   ├── extensions.json
│   └── tasks.json
├── scripts/
│   ├── README.md
│   ├── open-vscode-remote.sh
│   ├── macos/
│   │   └── open-vscode-remote.sh
│   ├── windows/
│   │   ├── setup-wsl.ps1
│   │   └── open-vscode-wsl.ps1
│   └── ubuntu/
│       ├── verify-remote-workspace.sh
│       ├── verify-wsl-workspace.sh
│       └── select-port.sh
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

## 공통 Ubuntu 스크립트

- `verify-remote-workspace.sh`: 일반 Ubuntu 원격 작업공간 검증
- `verify-wsl-workspace.sh`: WSL 전용 검증
- `select-port.sh`: Docker 포트 선택

## 구분 원칙

- `site/`: Docker 이미지에 포함되는 정적 웹 콘텐츠
- `bind-test/`: 바인드 마운트 변경 전후 확인용 콘텐츠
- `practice/`: CLI와 권한 실습용 파일
- `docs/logs/`: 실제 명령과 출력 결과
- `docs/screenshots/`: 화면 증거
- `.gitkeep`: 빈 폴더 구조 유지용이며 실습 증거가 아님
- `.gitattributes`: Windows와 Linux 간 줄바꿈 차이 제어

## 문서 역할

- `README.md`: 운영체제 선택과 공통 수행 절차를 제공하는 중앙 가이드
- `macos-orbstack-guide.md`: 기존 macOS·OrbStack 상세 가이드
- `windows-wsl.md`: Windows·WSL 상세 가이드
- `evidence-index.md`: 수행 항목별 완료 상태와 증거 링크
