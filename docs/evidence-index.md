# E1-1 증거 인덱스

실제 수행이 끝난 뒤 상태를 변경합니다. 빈 템플릿, 안내 문서, 자동화 스크립트 또는 `.gitkeep`은 수행 증거가 아닙니다.

## 상태 규칙

| 상태 | 의미 |
|---|---|
| `미완료` | 실제 명령·출력·화면 증거가 아직 없음 |
| `진행 중` | 일부 증거만 생성됨 |
| `완료` | 문서, 로그, 스크린샷을 직접 확인함 |
| `해당 없음` | 선택하지 않은 플랫폼 또는 수행 범위가 아님 |

실제 수행 플랫폼이 Windows 11 Pro + WSL2라면 macOS·OrbStack 항목은 `해당 없음`으로 표시합니다. 반대로 macOS + OrbStack을 사용했다면 Windows·WSL 항목을 `해당 없음`으로 표시합니다.

## 수행 증거

| 수행 항목 | 플랫폼 | 문서 | 로그 | 스크린샷 | 상태 |
|---|---|---|---|---|---|
| 호스트 환경 | macOS | [environment.md](environment.md) | `logs/environment.txt` | `screenshots/environment/` | 미완료 |
| 호스트 환경 | Windows 11 Pro | [windows-wsl.md](windows-wsl.md) | `logs/windows-wsl-host.txt` | `screenshots/windows-wsl/` | 미완료 |
| Ubuntu 환경 | OrbStack | [macos-orbstack-guide.md](macos-orbstack-guide.md) | `logs/environment.txt` | `screenshots/environment/` | 미완료 |
| Ubuntu 환경 | WSL2 | [windows-wsl.md](windows-wsl.md) | `logs/windows-wsl-environment.txt` | `screenshots/windows-wsl/` | 미완료 |
| Docker backend | Windows·WSL | [windows-wsl.md](windows-wsl.md) | `logs/windows-wsl-docker.txt` | `screenshots/windows-wsl/` | 미완료 |
| VS Code 연결 | Remote-SSH | [environment.md](environment.md) | `logs/environment.txt` | `screenshots/vscode/` | 미완료 |
| VS Code 연결 | Remote-WSL | [windows-wsl.md](windows-wsl.md) | `logs/windows-wsl-environment.txt` | `screenshots/vscode/` | 미완료 |
| 터미널 | 공통 | [terminal-and-permissions.md](terminal-and-permissions.md) | `logs/terminal-basic.txt` | `screenshots/terminal/` | 미완료 |
| 권한 | 공통 | [terminal-and-permissions.md](terminal-and-permissions.md) | `logs/permissions.txt` | `screenshots/permissions/` | 미완료 |
| Docker 운영 | 공통 | [docker-operations.md](docker-operations.md) | `logs/docker-basic.txt`, `logs/hello-world.txt` | `screenshots/docker/` | 미완료 |
| attach·exec | 공통 | [docker-operations.md](docker-operations.md) | 관찰 결과를 문서에 기록 | `screenshots/docker/` | 미완료 |
| Dockerfile | 공통 | [image-design.md](image-design.md) | `logs/docker-build.txt` | `screenshots/docker/` | 미완료 |
| 포트 매핑 | 공통 | [port-and-bind.md](port-and-bind.md) | `logs/port-mapping.txt` | `screenshots/port-mapping/` | 미완료 |
| 바인드 마운트 | 공통 | [port-and-bind.md](port-and-bind.md) | `logs/bind-mount-after.txt` | `screenshots/bind-mount/` | 미완료 |
| 볼륨 영속성 | 공통 | [volume-persistence.md](volume-persistence.md) | `logs/volume-persistence.txt` | `screenshots/volume/` | 미완료 |
| GitHub·VS Code | 공통 | [environment.md](environment.md) | `logs/environment.txt` | `screenshots/github/`, `screenshots/vscode/` | 미완료 |
| Clean clone | 공통 | [test-results.md](test-results.md) | 실제 재검증 결과 | `screenshots/github/` | 미완료 |
| 최종 검증 | 공통 | [test-results.md](test-results.md) | 실제 검증 결과 | 관련 증거 폴더 | 미완료 |

## 자동 검증과 실제 증거의 차이

`.github/workflows/validate.yml`은 저장소 구조, 셸·JSON 문법, Docker 빌드와 HTTP smoke test를 자동 점검합니다. 이 결과는 재현성 보조 자료이며, 개인 장비에서 수행한 Windows·WSL 또는 macOS·OrbStack 화면 증거를 대신하지 않습니다.
