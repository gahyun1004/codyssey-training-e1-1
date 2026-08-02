# macOS + OrbStack + Ubuntu 24.04 수행 가이드

이 문서는 macOS에서 OrbStack Ubuntu 24.04를 사용하고 VS Code Remote-SSH, OrbStack Docker와 GitHub 저장소를 연결하는 절차입니다.

> 실제 로그와 스크린샷은 본인이 직접 실행한 결과만 저장합니다. Windows·WSL로 수행했다면 이 문서의 플랫폼 증거 항목은 `해당 없음`으로 표시합니다.

---

## 1. 실행 위치

| 표시 | 실행 위치 |
|---|---|
| **[macOS]** | Mac Terminal |
| **[OrbStack Ubuntu]** | `ssh codyssey-training@orb`로 접속한 Ubuntu |
| **[VS Code Ubuntu]** | Remote-SSH로 연결된 VS Code 통합 터미널 |
| **[컨테이너]** | Docker 컨테이너 내부 |

---

## 2. OrbStack 상태 확인

Mac Terminal에서:

```bash
orb version
orb status
orb list
```

정상 기준:

- OrbStack 버전이 표시됨
- OrbStack이 실행 중임
- Linux machine 목록이 표시됨

`codyssey-training` 머신이 있으면:

```bash
orb info codyssey-training
```

없을 때만 생성합니다.

```bash
orb create ubuntu:noble codyssey-training
```

자원 제한 예시:

```bash
orb create \
  --memory 4G \
  --cpus 2 \
  --disk 32G \
  ubuntu:noble \
  codyssey-training
```

---

## 3. SSH와 Ubuntu 24.04 확인

```bash
ssh codyssey-training@orb
```

OrbStack Ubuntu에서:

```bash
cat /etc/os-release
uname -a
whoami
pwd
printf 'SHELL=%s\n' "$SHELL"
```

정상 기준:

- `VERSION_ID="24.04"` 또는 `VERSION_CODENAME=noble`
- 홈 경로가 `/home/...`
- 셸이 `/bin/bash`

Mac으로 돌아갈 때:

```bash
exit
```

---

## 4. 기본 패키지와 Docker

다시 Ubuntu에 접속합니다.

```bash
ssh codyssey-training@orb
```

패키지 설치:

```bash
sudo apt update
sudo apt install -y \
  ca-certificates curl wget git gnupg nano vim tree jq tar unzip zip
```

Docker 확인:

```bash
command -v docker || true
docker context show || true
docker --version
docker version
docker info
docker run --rm hello-world
```

`docker` 명령이 없을 때만 OrbStack의 Docker CLI 연결을 확인합니다.

```bash
mac link docker
hash -r
command -v docker
docker version
```

정상 기준:

- Docker Client와 Server 정보가 모두 표시됨
- `docker info` 성공
- `Hello from Docker!` 출력

---

## 5. Git 설정과 저장소 clone

Git 설정:

```bash
git config --global init.defaultBranch main
git config --global user.name "본인의 Git 이름"
git config --global user.email "본인의 GitHub 이메일"
git config --list
```

GitHub CLI는 선택 사항입니다. 기본 clone은 `git`을 사용합니다.

```bash
mkdir -p ~/codyssey-training
cd ~/codyssey-training

git clone https://github.com/gahyun1004/codyssey-training-e1-1.git
cd codyssey-training-e1-1

git status -sb
git remote -v
pwd
```

이미 clone되어 있다면 다시 clone하지 않고 기존 저장소에서 다음을 확인합니다.

```bash
git switch main
git pull --ff-only origin main
git status -sb
```

---

## 6. Mac에서 VS Code Remote-SSH 실행

Mac Terminal에서 VS Code CLI를 확인합니다.

```bash
command -v code
code --version
code --install-extension ms-vscode-remote.remote-ssh
```

원격 저장소를 직접 엽니다.

```bash
code --new-window \
  --remote "ssh-remote+codyssey-training@orb" \
  "$(ssh codyssey-training@orb \
  'cd ~/codyssey-training/codyssey-training-e1-1 && pwd -P')"
```

저장소 스크립트를 사용할 수도 있습니다.

```bash
bash scripts/open-vscode-remote.sh
```

성공 기준:

- VS Code 왼쪽 아래 `SSH: codyssey-training@orb`
- Explorer 최상단이 `codyssey-training-e1-1`
- 새 통합 터미널이 Ubuntu bash
- `pwd`와 Git root가 저장소 루트

---

## 7. VS Code Task와 수동 검증

```text
Command + Shift + P
→ Tasks: Run Task
→ E1-1: Verify Ubuntu Remote Workspace
```

직접 실행:

```bash
bash scripts/ubuntu/verify-remote-workspace.sh
```

수동 확인:

```bash
cat /etc/os-release
printf 'SHELL=%s\n' "$SHELL"
ps -p $$ -o comm=
pwd
git rev-parse --show-toplevel
git branch --show-current
docker version
```

---

## 8. 기본 로그 생성

VS Code Ubuntu 터미널 또는 OrbStack Ubuntu 저장소 루트에서:

```bash
bash scripts/ubuntu/collect-evidence.sh
```

생성 범위:

```text
docs/logs/environment.txt
docs/logs/terminal-basic.txt
docs/logs/permissions.txt
docs/logs/docker-basic.txt
docs/logs/hello-world.txt
```

자동 생성 로그의 민감정보를 검토한 뒤 사용합니다. `attach`, 커스텀 build, 포트, 바인드 마운트, 볼륨과 화면 캡처는 직접 수행합니다.

---

## 9. 공통 Docker 미션

공통 수행 절차는 README와 다음 문서를 사용합니다.

- [Docker 운영](docker-operations.md)
- [커스텀 이미지 설계](image-design.md)
- [포트 매핑 및 바인드 마운트](port-and-bind.md)
- [Docker 볼륨 영속성](volume-persistence.md)

현재 커스텀 이미지 베이스:

```text
nginx:1.30.4-alpine3.24
```

이미지 build:

```bash
docker build -t codyssey-e1-1-web:1.0 . \
  2>&1 | tee docs/logs/docker-build.txt
```

사용 가능한 포트 선택:

```bash
HOST_PORT="$(scripts/ubuntu/select-port.sh)"
printf 'HOST_PORT=%s\n' "$HOST_PORT" > .env.local
```

`select-port.sh`는 OrbStack Ubuntu의 Linux 포트, `mac lsof`가 제공하는 Mac 호스트 포트와 Docker 게시 포트를 확인합니다.

컨테이너 실행:

```bash
source .env.local

docker rm -f e1-1-web 2>/dev/null || true
docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0

curl -fsS "http://localhost:${HOST_PORT}"
```

Mac 브라우저에서:

```text
http://localhost:<HOST_PORT>
```

주소창과 페이지가 함께 보이도록 캡처합니다.

---

## 10. 증거

### macOS·OrbStack 환경

- macOS와 Terminal
- `orb version`, `orb status`, `orb list`
- OrbStack Ubuntu 24.04
- `ssh codyssey-training@orb`
- VS Code `SSH: codyssey-training@orb`
- Ubuntu bash, `pwd`, Git root·branch
- Docker Client·Server

### 공통 미션

- 터미널 기본 명령
- 권한 변경 전후
- hello-world
- `attach`와 `exec`
- 커스텀 image build
- 포트 매핑과 브라우저
- 바인드 마운트 전후
- 볼륨 영속성
- GitHub·VS Code Source Control

파일명과 마스킹 기준은 [스크린샷 안내](screenshots/README.md)를 따릅니다.

---

## 11. 대표 오류

### SSH 실패

```bash
orb status
orb list
orb info codyssey-training
ssh codyssey-training@orb
```

### Mac의 `code` 명령 없음

VS Code에서 다음을 실행합니다.

```text
Command + Shift + P
→ Shell Command: Install 'code' command in PATH
```

### VS Code 터미널이 Mac 로컬 경로

왼쪽 아래의 Remote-SSH 상태를 확인하고 `code --remote` 또는 `scripts/open-vscode-remote.sh`로 다시 엽니다.

### Docker Server 연결 실패

```bash
orb status
docker context show
docker version
docker info
```

### 포트 충돌

```bash
HOST_PORT="$(scripts/ubuntu/select-port.sh 8080 8081 18080 18081)"
```

실제로 발생한 문제와 해결 과정은 [트러블슈팅](troubleshooting.md)에 기록합니다.

---

## 12. Clean clone 검증

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

결과는 [최종 검증 결과](test-results.md)에 기록합니다.

---

## 13. 최종 체크리스트

- [ ] OrbStack 실행과 Ubuntu 24.04 확인
- [ ] SSH 접속 성공
- [ ] Docker Client·Server와 hello-world 성공
- [ ] 저장소를 Ubuntu 홈에 clone
- [ ] VS Code Remote-SSH 연결
- [ ] Ubuntu workspace 검증 Task 성공
- [ ] 기본 로그 생성과 검토
- [ ] 공통 Docker 미션 수행
- [ ] 실제 트러블슈팅 2건 이상
- [ ] 필수 스크린샷 저장
- [ ] clean clone build·run·HTTP 검증
- [ ] 민감정보 확인
