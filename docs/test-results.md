# 최종 검증 결과

> 실제 수행 결과만 기록합니다. 실행하지 않은 항목은 `미수행`, 사용하지 않은 플랫폼은 `해당 없음`으로 표시합니다.

## 1. 수행 플랫폼

- 호스트 OS:
- Linux 환경:
- VS Code 연결 방식:
- Docker backend:
- 수행 날짜:
- 검증 commit SHA:

## 2. macOS + OrbStack 검증

- 상태: 미수행 / 완료 / 해당 없음
- OrbStack machine:
- Remote-SSH:
- Ubuntu 24.04:
- bash:
- workspace 경로:
- Docker Client·Server:

## 3. Windows 11 Pro + WSL2 검증

- 상태: 미수행 / 완료 / 해당 없음
- Windows 11 Pro:
- WSL 버전:
- 배포판: `Ubuntu-24.04`
- WSL 설치 루트: `C:\WSL`
- 설치 디렉터리 이름: `codyssey-ubuntu24`
- 배포판 최종 설치 위치: `C:\WSL\codyssey-ubuntu24`
- `Test-Path "C:\WSL\codyssey-ubuntu24"` 결과:
- `--location` 지원 확인:
- WSL mode: `2`
- Remote-WSL:
- bash:
- 프로젝트 workspace 경로: `/home/<사용자>/codyssey-training/codyssey-training-e1-1`
- Docker Desktop WSL Integration:

## 4. 작업 브랜치 검증

- 브랜치:
- Docker build:
- 이미지 ID:
- 컨테이너 실행:
- 선택 포트:
- HTTP 응답:
- attach·exec 관찰:
- 바인드 마운트 변경 반영:
- 볼륨 영속성:

## 5. Clean clone 검증

새 폴더에서 기본 브랜치를 다시 clone합니다. GitHub CLI가 없어도 수행할 수 있도록 `git clone`을 기본으로 사용합니다.

```bash
RETEST_DIR="$HOME/codyssey-retest/e1-1-$(date +%Y%m%d-%H%M%S)"

git clone \
  https://github.com/gahyun1004/codyssey-training-e1-1.git \
  "$RETEST_DIR"
cd "$RETEST_DIR"

git status -sb
git rev-parse HEAD
bash scripts/ubuntu/validate-repository.sh

docker build -t codyssey-e1-1-web:retest .
HOST_PORT="$(scripts/ubuntu/select-port.sh 18080 18081 28080)"

docker run -d \
  --name e1-1-retest \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:retest

curl -fsS "http://localhost:${HOST_PORT}"
docker rm -f e1-1-retest
```

실제 결과:

- 재시험 폴더:
- 재시험 commit SHA:
- clone 직후 변경사항:
- 저장소 검증 스크립트:
- Docker build:
- 재시험 포트:
- 컨테이너 실행:
- HTTP 응답:
- 최종 판정:

## 6. main 최종 검증

- `main` 최신화:
- 최종 commit SHA:
- GitHub Actions 상태:
- 로컬 Docker build:
- 컨테이너 실행:
- HTTP 응답:
- 최종 판정:

GitHub Actions는 저장소 구조와 재현성을 보조 검증하지만, 개인 장비의 WSL·OrbStack 화면 증거를 대신하지 않습니다.

## 7. 보안 점검

```bash
git status -sb
git diff
git diff --cached
git grep -n -i -E 'token|password|secret|private.?key' || true
```

- 민감정보 검색:
- `.env`·`.env.local`·개인키 포함 여부:
- 이메일과 사용자 경로 마스킹:
- 스크린샷 마스킹 확인:
