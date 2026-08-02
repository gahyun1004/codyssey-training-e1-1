# 저장소 구조

README 9장의 권장 구조를 보완한 실제 구조입니다.

```text
codyssey-training-e1-1/
├── README.md
├── Dockerfile
├── .dockerignore
├── .gitignore
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
│   └── ubuntu/
│       ├── verify-remote-workspace.sh
│       └── select-port.sh
├── site/
│   └── index.html
├── bind-test/
│   └── index.html
├── practice/
│   ├── README.md
│   ├── terminal/
│   │   └── .gitkeep
│   └── permissions/
│       ├── .gitkeep
│       └── permission-dir/
│           └── .gitkeep
└── docs/
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
    ├── logs/
    │   └── README.md
    └── screenshots/
        ├── README.md
        ├── environment/
        ├── terminal/
        ├── permissions/
        ├── docker/
        ├── port-mapping/
        ├── bind-mount/
        ├── volume/
        ├── github/
        └── vscode/
```

## 구분 원칙

- `site/`: Docker 이미지에 포함되는 정적 웹 콘텐츠
- `bind-test/`: 바인드 마운트 변경 전후 확인용 콘텐츠
- `practice/`: CLI와 권한 실습용 파일
- `scripts/macos/`: Mac Terminal에서 실행
- `scripts/ubuntu/`: OrbStack Ubuntu 또는 VS Code Ubuntu 터미널에서 실행
- `docs/logs/`: 실제 명령과 출력 결과
- `docs/screenshots/`: 화면 증거
- `.gitkeep`: 빈 폴더 구조를 Git에 유지하기 위한 파일이며 실습 증거는 아님
