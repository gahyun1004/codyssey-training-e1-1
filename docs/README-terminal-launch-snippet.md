# macOS Terminal 실행 후 VS Code Remote-SSH 열기

README 8.2에 반영할 실행 순서입니다.

```text
Command(⌘) + Space
→ Spotlight 검색창에 Terminal 입력
→ Return 또는 Terminal 앱 선택
```

열린 Mac Terminal에서 다음 명령으로 OrbStack Ubuntu 저장소를 VS Code Remote-SSH 창으로 엽니다.

```bash
code --new-window \
  --remote "ssh-remote+codyssey-training@orb" \
  "$(ssh codyssey-training@orb 'cd ~/codyssey-training/codyssey-training-e1-1 && pwd -P')"
```

VS Code가 열리면 기존 통합 터미널을 닫고 `Terminal → New Terminal`을 선택한 뒤 Ubuntu 24.04, bash, 현재 workspace 경로를 검증합니다.
