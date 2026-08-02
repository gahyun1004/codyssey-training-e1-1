# 트러블슈팅

실제 문제 해결 사례를 최소 2건 작성합니다. 오류 메시지는 수정하지 말고 원문을 보존합니다. 아래 예시는 주제 후보일 뿐 실제 사례가 아니므로, 발생하지 않은 문제를 작성하지 않습니다.

## 작성 원칙

1. 오류가 발생한 플랫폼과 실행 위치를 구분합니다.
2. 실행 명령과 오류 메시지 원문을 함께 남깁니다.
3. 처음 세운 가설과 실제 원인을 구분합니다.
4. 해결 후 같은 검증 명령을 다시 실행합니다.
5. 비밀번호, 토큰, 인증 코드, 개인키와 내부 경로는 마스킹합니다.

## TS-01

- 문제:
- 발생 환경:
- 실행 위치:
- 작업 브랜치:
- 실행 명령:
- 오류 메시지 원문:
- 원인 가설:
- 확인 과정:
- 실제 원인:
- 해결 방법 또는 대안:
- 해결 확인 명령:
- 해결 확인 결과:
- 재발 방지:
- 관련 로그·스크린샷:

## TS-02

- 문제:
- 발생 환경:
- 실행 위치:
- 작업 브랜치:
- 실행 명령:
- 오류 메시지 원문:
- 원인 가설:
- 확인 과정:
- 실제 원인:
- 해결 방법 또는 대안:
- 해결 확인 명령:
- 해결 확인 결과:
- 재발 방지:
- 관련 로그·스크린샷:

## 작성 가능한 실제 사례 후보

### 공통 Ubuntu·Docker

- 포트 충돌과 `scripts/ubuntu/select-port.sh`를 이용한 대체 포트 선택
- Docker Server 연결 실패
- `attach` 후 잘못 종료한 컨테이너의 재실행
- 바인드 마운트의 호스트 경로 오류
- 서로 다른 볼륨 이름을 사용해 데이터가 보이지 않은 문제
- 셸 스크립트 실행 권한 누락

### Windows 11 Pro + WSL2

- `wsl.exe --help`에 `--location`이 표시되지 않은 문제
- `C:\WSL\codyssey-ubuntu24`가 비어 있지 않아 설치가 중단된 문제
- 배포판이 `VERSION 1`로 표시된 문제
- VS Code가 WSL 창이 아니라 Windows 로컬 창으로 열린 문제
- 저장소가 `/mnt/c/...`에 있어 권한 또는 성능 문제가 발생한 사례
- Docker Desktop의 `Ubuntu-24.04` WSL Integration이 비활성화된 문제

### macOS + OrbStack

- OrbStack 머신이 정지되어 SSH 접속에 실패한 문제
- `code --remote` 실행 시 Mac의 VS Code CLI를 찾지 못한 문제
- 잘못된 Remote-SSH 폴더를 열어 `pwd`와 Git root가 달랐던 문제

## 해결 확인 기준

문제를 해결한 뒤 다음 중 관련된 명령을 다시 실행합니다.

```bash
bash scripts/ubuntu/verify-remote-workspace.sh
bash scripts/ubuntu/verify-wsl-workspace.sh
docker version
docker info
docker ps
curl -fsS "http://localhost:${HOST_PORT}"
git status -sb
```
