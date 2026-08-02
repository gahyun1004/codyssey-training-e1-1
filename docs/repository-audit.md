# 저장소 보완 점검

점검 기준: E1-1 미션 수행 가이드, 실제 저장소 구조, Windows 11 Pro + WSL2와 macOS + OrbStack 지원, Docker·Git·증거 재현성.

## 1. 반영 완료

- README와 세부 문서의 역할 분리
- Windows 11 Pro + WSL2 + Ubuntu 24.04 수행 경로
- macOS + OrbStack + Ubuntu 24.04 수행 경로
- WSL 배포판 데이터 위치 `C:\WSL\codyssey-ubuntu24`와 프로젝트 `/home/...` 분리
- VS Code Remote-SSH·Remote-WSL 설정과 검증 Task
- WSL·Ubuntu·OrbStack·Docker 게시 포트를 확인하는 포트 선택 스크립트
- 일반 Ubuntu 검증에 Docker Client·Server 연결 확인 추가
- Windows 호스트와 Ubuntu 기본 로그 생성 도구
- Docker `attach`·`exec` 내부 명령과 관찰 양식
- 플랫폼 중립적인 커스텀 웹 페이지
- NGINX·Alpine 베이스 이미지 버전 명시
- clean clone 후 build·run·HTTP 검증 절차
- 증거 상태 `미완료`, `진행 중`, `완료`, `해당 없음` 구분
- GitHub Actions 저장소 검증과 Docker HTTP smoke test

## 2. 자동화로 대체할 수 없는 남은 작업

다음 항목은 실제 Windows·WSL 또는 macOS·OrbStack 장비에서 직접 수행해야 합니다.

1. 실제 수행 플랫폼 확정
2. OS, WSL 또는 OrbStack, VS Code, Git, Docker 버전 기록
3. 터미널 기본 명령과 권한 변경 전후 실행
4. Docker `attach`와 `exec` 직접 관찰
5. 커스텀 이미지 build와 브라우저 접속
6. 바인드 마운트 파일 변경 전후 확인
7. 컨테이너 삭제 후 볼륨 데이터 확인
8. GitHub·VS Code Source Control 화면 캡처
9. 실제 트러블슈팅 사례 최소 2건 기록
10. clean clone 최종 검증
11. `docs/evidence-index.md` 상태 변경

## 3. 수행 플랫폼 표기

하나의 플랫폼만 수행해도 됩니다.

### Windows에서 수행한 경우

```text
Windows 11 Pro
WSL2 Ubuntu 24.04
VS Code Remote-WSL
Docker Desktop WSL Integration
```

macOS·OrbStack 증거 항목은 `해당 없음`으로 표시합니다.

### macOS에서 수행한 경우

```text
macOS
OrbStack Ubuntu 24.04
VS Code Remote-SSH
OrbStack Docker
```

Windows·WSL 증거 항목은 `해당 없음`으로 표시합니다.

## 4. 기본 로그 생성

### Windows PowerShell

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\collect-wsl-host-evidence.ps1
```

### WSL 또는 OrbStack Ubuntu

```bash
bash scripts/ubuntu/collect-evidence.sh
```

자동 생성 로그는 민감정보를 확인하고 실제 결과와 일치하는지 검토한 뒤 커밋합니다.

## 5. 저장소 정적 검증

```bash
bash scripts/ubuntu/validate-repository.sh
```

GitHub Actions도 같은 구조 검증과 Docker build·HTTP smoke test를 실행합니다.

## 6. 최종 판정 기준

현재 구조와 자동화만으로 미션이 완료되는 것은 아닙니다. 다음 조건을 모두 충족했을 때 최종 완료로 판정합니다.

- 실제 로그가 존재하고 명령과 출력이 함께 있음
- 필수 스크린샷이 실제 수행 환경을 보여 줌
- 빈 결과 문서가 실제 값으로 채워짐
- 트러블슈팅 2건 이상이 실제 사례임
- clean clone에서 Docker build·run·HTTP 검증 성공
- 증거 인덱스 상태가 실제 결과와 일치함
- 민감정보가 저장소와 캡처에 없음
