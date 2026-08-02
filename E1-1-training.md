# E1-1 초보자 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 ‘작업실’ 꾸미기  
> **권장 환경:** macOS + OrbStack + Ubuntu 24.04 LTS + Docker  
> **대상 저장소:** `gahyun1004/codyssey-training-e1-1`  
> **작업 브랜치:** `feat/e1-1-workstation`

이 문서는 초보자가 명령어를 위에서부터 한 단계씩 실행하면서 E1-1 미션을 완료하도록 구성한 실습 가이드입니다.

벤치마킹 문서의 장점인 **실행 위치 표시, 정상 기준 확인, 오류 발생 시 중단, 작업 브랜치 사용, clean clone 재검증** 방식을 적용하되, 현재 저장소와 E1-1 필수 요구사항에 맞게 절차를 단순화했습니다.

> 모든 컴퓨터의 상태가 다르므로 오류를 완전히 없다고 보장할 수는 없습니다. 대신 각 단계마다 **정상 기준과 대표 오류 해결 방법**을 제공하여 시행착오를 최소화합니다.

---

## 목차

1. [문서 사용 규칙](#1-문서-사용-규칙)
2. [최종 완료 기준](#2-최종-완료-기준)
3. [전체 수행 순서](#3-전체-수행-순서)
4. [Mac과 OrbStack 사전 점검](#4-mac과-orbstack-사전-점검)
5. [Ubuntu 머신 생성과 접속](#5-ubuntu-머신-생성과-접속)
6. [Ubuntu 기본 환경 준비](#6-ubuntu-기본-환경-준비)
7. [Docker 연결과 기본 점검](#7-docker-연결과-기본-점검)
8. [GitHub CLI 설치와 로그인](#8-github-cli-설치와-로그인)
9. [저장소 복제와 작업 브랜치 생성](#9-저장소-복제와-작업-브랜치-생성)
10. [VS Code Remote-SSH 연결](#10-vs-code-remote-ssh-연결)
11. [저장소 기본 구조 만들기](#11-저장소-기본-구조-만들기)
12. [터미널 기본 조작 실습](#12-터미널-기본-조작-실습)
13. [파일과 디렉터리 권한 실습](#13-파일과-디렉터리-권한-실습)
14. [Docker 이미지와 컨테이너 실습](#14-docker-이미지와-컨테이너-실습)
15. [Dockerfile 웹 서버 제작](#15-dockerfile-웹-서버-제작)
16. [포트 매핑 검증](#16-포트-매핑-검증)
17. [바인드 마운트 검증](#17-바인드-마운트-검증)
18. [Docker 볼륨 영속성 검증](#18-docker-볼륨-영속성-검증)
19. [수행 증거와 문서 작성](#19-수행-증거와-문서-작성)
20. [Git 커밋과 GitHub 푸시](#20-git-커밋과-github-푸시)
21. [Clean clone 재현성 검증](#21-clean-clone-재현성-검증)
22. [Pull Request와 main 병합](#22-pull-request와-main-병합)
23. [병합 후 최종 검증](#23-병합-후-최종-검증)
24. [대표 오류 해결표](#24-대표-오류-해결표)
25. [평가 전 최종 체크리스트](#25-평가-전-최종-체크리스트)

---

# 1. 문서 사용 규칙

## 1.1 실행 위치 표시

| 표시 | 명령을 실행할 위치 |
|---|---|
| **[macOS]** | Mac의 터미널 앱 |
| **[Ubuntu]** | OrbStack의 `codyssey-training` Ubuntu 터미널 |
| **[VS Code Ubuntu]** | Remote-SSH로 연결된 VS Code 통합 터미널 |
| **[컨테이너]** | Docker 컨테이너 내부 |
| **[확인]** | 결과가 정상인지 확인하는 명령 |
| **[오류 시]** | 해당 오류가 발생했을 때만 실행하는 명령 |

## 1.2 초보자 실행 원칙

1. 명령어 블록을 **한 번에 하나씩** 실행합니다.
2. 명령어 앞의 `$`, `# [macOS]` 같은 설명 문구는 입력하지 않습니다.
3. 각 단계의 정상 기준을 확인한 후 다음 단계로 이동합니다.
4. 오류가 발생하면 다음 단계로 넘어가지 않습니다.
5. 오류 메시지는 임의로 고치지 말고 원문을 보존합니다.
6. 현재 브랜치가 `main`이면 파일을 수정하지 않습니다.
7. 아래 위험 명령은 사용하지 않습니다.

```bash
git push --force
git reset --hard
docker system prune
docker system prune -a
rm -rf ~
```

## 1.3 즉시 중단해야 하는 상태

다음 상황에서는 작업을 멈추고 해당 단계의 오류 해결 방법을 확인합니다.

- `docker version`에서 Server 정보가 나오지 않음
- `docker info` 실패
- `docker run --rm hello-world` 실패
- `gh auth status` 로그인 실패
- GitHub 저장소 권한이 `READ`
- 현재 브랜치가 `main`인데 파일이 수정됨
- VS Code 터미널 경로가 `/Users/...`로 표시됨
- `git diff --cached`에 의도하지 않은 파일이 포함됨
- clean clone에서 Docker 빌드 실패

---

# 2. 최종 완료 기준

평가자는 저장소의 기본 브랜치인 `main`에서 다음 내용을 확인할 수 있어야 합니다.

- [ ] macOS에서 OrbStack이 실행된다.
- [ ] Ubuntu 24.04 머신 `codyssey-training`을 사용했다.
- [ ] Docker Client와 Server가 정상 연결된다.
- [ ] `hello-world` 컨테이너 실행에 성공했다.
- [ ] 터미널 기본 조작 결과가 기록되어 있다.
- [ ] 파일과 디렉터리 권한 변경 전후가 기록되어 있다.
- [ ] Docker 이미지와 컨테이너 운영 결과가 기록되어 있다.
- [ ] 직접 작성한 `Dockerfile`이 있다.
- [ ] NGINX 웹 서버 이미지 빌드에 성공했다.
- [ ] 포트 매핑 후 브라우저 또는 `curl` 접속에 성공했다.
- [ ] 바인드 마운트 변경 전후가 확인된다.
- [ ] 컨테이너 삭제 후에도 Docker 볼륨 데이터가 유지된다.
- [ ] Git, GitHub, VS Code 연동 증거가 있다.
- [ ] 트러블슈팅이 2건 이상 작성되어 있다.
- [ ] 민감정보가 저장소와 캡처에 포함되지 않았다.
- [ ] clean clone 환경에서 다시 빌드하고 실행했다.

---

# 3. 전체 수행 순서

```text
1. OrbStack 실행 확인
2. Ubuntu 24.04 머신 생성 또는 확인
3. Ubuntu 기본 패키지 설치
4. Docker 연결 및 hello-world 확인
5. GitHub CLI 설치 및 로그인
6. 저장소 clone
7. 작업 브랜치 생성
8. VS Code Remote-SSH 연결
9. 터미널과 권한 실습
10. Docker 기본 운영 실습
11. Dockerfile 웹 서버 제작
12. 포트 매핑 검증
13. 바인드 마운트 검증
14. Docker 볼륨 영속성 검증
15. README와 증거 문서 정리
16. 커밋과 push
17. clean clone 재검증
18. Pull Request 생성 및 main 병합
19. main에서 최종 검증
```

---

# 4. Mac과 OrbStack 사전 점검

## 4.1 OrbStack 실행

먼저 Mac에서 OrbStack 애플리케이션을 실행합니다.

## 4.2 OrbStack CLI 확인

```bash
# [macOS]
orb version
orb status
orb list
```

정상 기준:

- OrbStack 버전이 출력된다.
- OrbStack이 실행 중이라고 표시된다.
- Linux machine 목록이 출력된다.

### `orb: command not found`가 나오는 경우

1. OrbStack이 설치되어 있는지 확인합니다.
2. OrbStack 앱을 한 번 실행합니다.
3. 터미널을 완전히 종료한 뒤 다시 엽니다.
4. 다시 실행합니다.

```bash
orb version
```

## 4.3 Git과 SSH 확인

```bash
# [macOS]
git --version
ssh -V
```

두 명령 모두 버전이 출력되어야 합니다.

---

# 5. Ubuntu 머신 생성과 접속

## 5.1 기존 머신 확인

```bash
# [macOS]
orb list
```

목록에 `codyssey-training`이 있다면 다음 명령으로 상태를 확인합니다.

```bash
orb info codyssey-training
```

## 5.2 머신이 없을 때만 생성

```bash
# [macOS]
orb create ubuntu:noble codyssey-training
```

`noble`은 Ubuntu 24.04 LTS를 의미합니다.

자원을 제한해 생성하려면 위 명령 대신 다음 명령 하나만 실행합니다.

```bash
orb create \
  --memory 4G \
  --cpus 2 \
  --disk 32G \
  ubuntu:noble \
  codyssey-training
```

## 5.3 Ubuntu 접속

```bash
# [macOS]
orb -m codyssey-training
```

접속 후 다음 명령을 실행합니다.

```bash
# [Ubuntu]
cat /etc/os-release
uname -a
uname -m
whoami
pwd
```

정상 기준:

- `VERSION_CODENAME=noble` 또는 Ubuntu 24.04가 표시된다.
- 현재 사용자가 표시된다.
- 경로가 `/home/...` 형태로 표시된다.

---

# 6. Ubuntu 기본 환경 준비

## 6.1 인터넷 연결 확인

```bash
# [Ubuntu]
getent hosts github.com
curl -I https://github.com
```

정상 기준:

- `github.com`의 IP 주소가 출력된다.
- HTTP 응답 헤더가 출력된다.

두 명령 중 하나라도 실패하면 네트워크 문제를 먼저 해결합니다.

## 6.2 패키지 목록 갱신

```bash
sudo apt update
```

## 6.3 필수 패키지 설치

```bash
sudo apt install -y \
  ca-certificates \
  curl \
  wget \
  git \
  gnupg \
  nano \
  vim \
  tree \
  jq \
  unzip \
  zip
```

설치 확인:

```bash
git --version
curl --version | head -n 1
jq --version
tree --version
```

## 6.4 작업 상위 폴더 생성

```bash
mkdir -p ~/codyssey-training
cd ~/codyssey-training
pwd
```

정상 경로 예시:

```text
/home/사용자이름/codyssey-training
```

---

# 7. Docker 연결과 기본 점검

## 7.1 Docker 명령 존재 여부 확인

```bash
# [Ubuntu]
command -v docker || true
```

Docker 경로가 출력되면 7.2로 이동합니다.

### Docker 명령이 없을 때만 실행

```bash
mac link docker
hash -r
command -v docker
```

## 7.2 Docker Client와 Server 확인

```bash
docker version
```

정상 기준:

- `Client` 정보가 표시된다.
- `Server` 정보가 표시된다.

Server 정보가 없으면 다음 명령으로 추가 확인합니다.

```bash
docker info
```

## 7.3 hello-world 실행

```bash
docker run --rm hello-world
```

정상 기준:

```text
Hello from Docker!
```

## 7.4 Docker 연결 복구

실제로 Docker 연결 오류가 있을 때만 실행합니다.

```bash
mac unlink docker
mac link docker
hash -r
exec "$SHELL" -l
```

새 셸이 열린 후 다시 확인합니다.

```bash
docker version
docker info
docker run --rm hello-world
```

---

# 8. GitHub CLI 설치와 로그인

## 8.1 설치 여부 확인

```bash
# [Ubuntu]
command -v gh || true
gh --version || true
```

`gh version`이 출력되면 8.3으로 이동합니다.

## 8.2 GitHub CLI 설치

```bash
sudo mkdir -p -m 755 /etc/apt/keyrings

wget -nv \
  -O /tmp/githubcli-archive-keyring.gpg \
  https://cli.github.com/packages/githubcli-archive-keyring.gpg

sudo cp /tmp/githubcli-archive-keyring.gpg \
  /etc/apt/keyrings/githubcli-archive-keyring.gpg

sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

sudo apt update
sudo apt install -y gh
```

설치 확인:

```bash
gh --version
```

## 8.3 GitHub 로그인

```bash
gh auth login \
  --hostname github.com \
  --git-protocol https \
  --web
```

브라우저에 표시되는 절차에 따라 로그인합니다.

로그인 확인:

```bash
gh auth status --hostname github.com
gh auth setup-git --hostname github.com
```

정상 기준:

- 로그인한 GitHub 계정이 표시된다.
- 인증 상태가 정상으로 표시된다.

## 8.4 저장소 쓰기 권한 확인

```bash
gh repo view gahyun1004/codyssey-training-e1-1 \
  --json nameWithOwner,viewerPermission
```

정상 권한:

```text
ADMIN
MAINTAIN
WRITE
```

`READ`가 나오면 저장소에 push할 수 없으므로 권한 문제를 먼저 해결합니다.

---

# 9. 저장소 복제와 작업 브랜치 생성

## 9.1 저장소가 아직 없을 때

```bash
cd ~/codyssey-training

gh repo clone gahyun1004/codyssey-training-e1-1
cd codyssey-training-e1-1
```

## 9.2 같은 이름의 폴더가 이미 있을 때

기존 폴더를 삭제하지 않습니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git status -sb
git remote -v
```

`origin`이 다음 저장소를 가리켜야 합니다.

```text
https://github.com/gahyun1004/codyssey-training-e1-1.git
```

## 9.3 Git 사용자 정보 확인

```bash
git config --global user.name || true
git config --global user.email || true
```

값이 비어 있을 때만 설정합니다.

```bash
git config --global user.name "본인의 Git 이름"
git config --global user.email "본인의 GitHub 이메일"
git config --global init.defaultBranch main
```

확인:

```bash
git config --global --list
```

## 9.4 main 최신화

```bash
git switch main
git pull --ff-only origin main
```

## 9.5 작업 브랜치 생성

처음 생성할 때:

```bash
git switch -c feat/e1-1-workstation
```

다음 오류가 나오면 이미 브랜치가 있다는 의미입니다.

```text
fatal: a branch named 'feat/e1-1-workstation' already exists
```

이 경우 새로 만들지 말고 전환합니다.

```bash
git switch feat/e1-1-workstation
```

최종 확인:

```bash
git branch --show-current
git status -sb
```

정상 기준:

```text
feat/e1-1-workstation
```

> 현재 브랜치가 `main`이면 파일을 수정하지 않습니다.

---

# 10. VS Code Remote-SSH 연결

## 10.1 Mac으로 돌아가기

Ubuntu 터미널에서 다음 명령을 실행합니다.

```bash
exit
```

## 10.2 SSH 접속 확인

```bash
# [macOS]
ssh codyssey-training@orb
```

Ubuntu 셸이 열리면 연결 성공입니다.

```bash
exit
```

## 10.3 VS Code 확장 설치

Mac의 VS Code에서 다음 확장을 설치합니다.

```text
Remote - SSH
확장 ID: ms-vscode-remote.remote-ssh
```

## 10.4 Remote-SSH로 접속

VS Code에서 다음 순서로 진행합니다.

```text
Shift + Command + P
→ Remote-SSH: Connect to Host...
→ codyssey-training@orb
```

접속 후 폴더를 엽니다.

```text
File → Open Folder...
→ /home/사용자이름/codyssey-training/codyssey-training-e1-1
```

## 10.5 VS Code 통합 터미널 확인

```text
Terminal → New Terminal
```

```bash
# [VS Code Ubuntu]
cat /etc/os-release
pwd
git rev-parse --show-toplevel
git branch --show-current
```

정상 기준:

- Ubuntu 24.04가 표시된다.
- 경로가 `/home/.../codyssey-training-e1-1`이다.
- Git 최상위 경로가 현재 저장소이다.
- 브랜치가 `feat/e1-1-workstation`이다.

다음 중 하나면 잘못 연결된 상태입니다.

- 경로가 `/Users/...`이다.
- 브랜치가 `main`이다.
- `not a git repository`가 나온다.

---

# 11. 저장소 기본 구조 만들기

아래 명령은 **VS Code의 Ubuntu 통합 터미널**에서 실행합니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1

mkdir -p site
mkdir -p bind-test
mkdir -p practice
mkdir -p docs/logs
mkdir -p docs/screenshots/environment
mkdir -p docs/screenshots/terminal
mkdir -p docs/screenshots/permissions
mkdir -p docs/screenshots/docker
mkdir -p docs/screenshots/port-mapping
mkdir -p docs/screenshots/bind-mount
mkdir -p docs/screenshots/volume
mkdir -p docs/screenshots/github
```

`.gitignore`를 생성합니다.

```bash
cat > .gitignore <<'EOF'
.DS_Store
.env
.env.local
*.log
EOF
```

> `docs/logs`에 실제 제출할 로그 파일이 필요하다면 `*.log` 대신 `.txt` 확장자로 저장합니다.

기본 문서 파일을 생성합니다.

```bash
cat > docs/environment.md <<'EOF'
# 실행 환경

- OS:
- Shell:
- Terminal:
- OrbStack:
- Ubuntu:
- Docker:
- Git:
- VS Code:

## 검증 명령과 결과

```text
실제 명령과 결과를 작성하세요.
```
EOF

cat > docs/troubleshooting.md <<'EOF'
# 트러블슈팅

## TS-01

- 문제:
- 실행 위치:
- 실행 명령:
- 오류 메시지:
- 원인:
- 해결 방법:
- 해결 확인:
- 재발 방지:

## TS-02

- 문제:
- 실행 위치:
- 실행 명령:
- 오류 메시지:
- 원인:
- 해결 방법:
- 해결 확인:
- 재발 방지:
EOF
```

환경 정보를 확인합니다.

```bash
cat /etc/os-release
uname -a
echo "$SHELL"
git --version
gh --version | head -n 1
docker --version
```

출력 결과를 `docs/environment.md`에 정리합니다.

---

# 12. 터미널 기본 조작 실습

## 12.1 실습 폴더 이동

```bash
cd ~/codyssey-training/codyssey-training-e1-1
mkdir -p practice/terminal
cd practice/terminal
```

## 12.2 기본 명령 실행

```bash
pwd
ls
ls -la

touch sample.txt
echo "Codyssey E1-1" > sample.txt
cat sample.txt

cp sample.txt sample-copy.txt
ls -la

mv sample-copy.txt renamed.txt
ls -la

mkdir archive
mv renamed.txt archive/
ls -la archive

rm archive/renamed.txt
rmdir archive
ls -la
```

## 12.3 명령 설명

| 명령 | 의미 |
|---|---|
| `pwd` | 현재 위치 확인 |
| `ls` | 파일과 디렉터리 목록 확인 |
| `ls -la` | 숨김 파일과 상세 정보 확인 |
| `cd` | 디렉터리 이동 |
| `mkdir` | 디렉터리 생성 |
| `touch` | 빈 파일 생성 |
| `echo` | 문자열 출력 또는 파일 작성 |
| `cat` | 파일 내용 확인 |
| `cp` | 파일 복사 |
| `mv` | 이동 또는 이름 변경 |
| `rm` | 파일 삭제 |
| `rmdir` | 빈 디렉터리 삭제 |

## 12.4 절대 경로와 상대 경로

```bash
pwd
realpath sample.txt
```

- `/home/...`처럼 `/`로 시작하는 경로는 **절대 경로**입니다.
- `sample.txt`, `../terminal`처럼 현재 위치를 기준으로 하는 경로는 **상대 경로**입니다.

## 12.5 기록할 증거

다음 화면을 캡처합니다.

- `pwd` 결과
- `ls -la` 결과
- 파일 생성·복사·이름 변경 결과
- 삭제 후 최종 목록

권장 파일명:

```text
docs/screenshots/terminal/01-basic-commands.png
```

---

# 13. 파일과 디렉터리 권한 실습

## 13.1 파일 권한

```bash
cd ~/codyssey-training/codyssey-training-e1-1/practice

touch permission-file.txt
ls -l permission-file.txt

chmod 644 permission-file.txt
ls -l permission-file.txt

chmod 600 permission-file.txt
ls -l permission-file.txt
```

## 13.2 디렉터리 권한

```bash
mkdir -p permission-dir
ls -ld permission-dir

chmod 755 permission-dir
ls -ld permission-dir

chmod 700 permission-dir
ls -ld permission-dir
```

## 13.3 숫자 권한 해석

| 숫자 | 권한 | 의미 |
|---:|---|---|
| 4 | `r` | 읽기 |
| 2 | `w` | 쓰기 |
| 1 | `x` | 실행 또는 디렉터리 진입 |
| 7 | `rwx` | 4+2+1 |
| 6 | `rw-` | 4+2 |
| 5 | `r-x` | 4+1 |

예시:

- `755` = 소유자 `rwx`, 그룹 `r-x`, 기타 사용자 `r-x`
- `644` = 소유자 `rw-`, 그룹 `r--`, 기타 사용자 `r--`

## 13.4 주의사항

Git은 일반 파일의 `644`와 `600` 차이를 변경사항으로 표시하지 않을 수 있습니다. 권한 실습은 다음 자료로 증명합니다.

- `ls -l` 출력
- 변경 전후 스크린샷
- README 또는 문서의 설명

권장 파일명:

```text
docs/screenshots/permissions/01-file-permission.png
docs/screenshots/permissions/02-directory-permission.png
```

---

# 14. Docker 이미지와 컨테이너 실습

저장소 루트로 이동합니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
```

## 14.1 설치와 상태 확인

```bash
docker --version
docker version
docker info
docker images
docker ps
docker ps -a
docker stats --no-stream
```

## 14.2 hello-world 컨테이너

기존 컨테이너가 있을 수 있으므로 동일 이름만 안전하게 삭제합니다.

```bash
docker rm -f e1-1-hello 2>/dev/null || true

docker run --name e1-1-hello hello-world
docker ps -a
docker logs e1-1-hello
```

정상 기준:

```text
Hello from Docker!
```

## 14.3 Ubuntu 컨테이너

```bash
docker rm -f e1-1-ubuntu 2>/dev/null || true

docker run -d \
  --name e1-1-ubuntu \
  ubuntu:24.04 \
  bash -lc 'echo "e1-1-ubuntu started"; sleep infinity'
```

상태와 로그를 확인합니다.

```bash
docker ps
docker logs e1-1-ubuntu
```

컨테이너 내부에 접속합니다.

```bash
docker exec -it e1-1-ubuntu bash
```

컨테이너 내부에서 실행합니다.

```bash
# [컨테이너]
pwd
ls -la
echo "Hello from Ubuntu container"
exit
```

Ubuntu 터미널로 돌아온 뒤 실행합니다.

```bash
docker stop e1-1-ubuntu
docker ps -a
docker start e1-1-ubuntu
docker ps
docker rm -f e1-1-ubuntu
```

## 14.4 `attach`와 `exec` 차이

- `docker attach`: 컨테이너의 기본 프로세스 입출력에 연결합니다.
- `docker exec`: 실행 중인 컨테이너에 새로운 명령이나 셸을 추가로 실행합니다.
- 초보자 실습에서는 기존 프로세스를 방해할 가능성이 낮은 `docker exec`를 권장합니다.

---

# 15. Dockerfile 웹 서버 제작

## 15.1 웹 페이지 작성

```bash
cd ~/codyssey-training/codyssey-training-e1-1
mkdir -p site

cat > site/index.html <<'EOF'
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Codyssey E1-1</title>
</head>
<body>
  <h1>Codyssey E1-1 개발 워크스테이션</h1>
  <p>OrbStack Ubuntu 환경에서 제작한 Docker 웹 서버입니다.</p>
</body>
</html>
EOF
```

확인:

```bash
cat site/index.html
```

## 15.2 Dockerfile 작성

```bash
cat > Dockerfile <<'EOF'
FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-e1-1-web"
LABEL org.opencontainers.image.description="Codyssey E1-1 custom NGINX web server"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
EOF
```

## 15.3 Docker 빌드 제외 파일

```bash
cat > .dockerignore <<'EOF'
.git
.github
.vscode
docs
practice
bind-test
.env
.env.local
.DS_Store
EOF
```

## 15.4 이미지 빌드

```bash
docker build -t codyssey-e1-1-web:1.0 .
```

정상 기준:

- 빌드가 오류 없이 끝난다.
- 마지막 단계에 성공 메시지가 표시된다.

이미지 확인:

```bash
docker images | grep codyssey-e1-1-web
docker image inspect codyssey-e1-1-web:1.0
```

---

# 16. 포트 매핑 검증

## 16.1 8080 포트로 실행

```bash
docker rm -f e1-1-web 2>/dev/null || true

docker run -d \
  --name e1-1-web \
  -p 8080:80 \
  codyssey-e1-1-web:1.0
```

상태 확인:

```bash
docker ps
docker logs e1-1-web
docker port e1-1-web
curl http://localhost:8080
```

정상 기준:

- `docker ps`에 `e1-1-web`이 표시된다.
- 포트가 `8080 -> 80`으로 연결된다.
- `curl` 결과에 `Codyssey E1-1 개발 워크스테이션`이 표시된다.

## 16.2 브라우저 접속

Mac 브라우저에서 다음 주소를 엽니다.

```text
http://localhost:8080
```

주소창과 웹 페이지가 동시에 보이도록 캡처합니다.

권장 파일명:

```text
docs/screenshots/port-mapping/01-browser-8080.png
```

## 16.3 8080 포트 충돌 시

다음 오류가 나오면 8080 포트를 다른 프로그램이 사용 중입니다.

```text
Bind for 0.0.0.0:8080 failed: port is already allocated
```

실패한 컨테이너를 제거하고 8081로 다시 실행합니다.

```bash
docker rm -f e1-1-web 2>/dev/null || true

docker run -d \
  --name e1-1-web \
  -p 8081:80 \
  codyssey-e1-1-web:1.0

curl http://localhost:8081
```

브라우저 주소도 다음과 같이 변경합니다.

```text
http://localhost:8081
```

---

# 17. 바인드 마운트 검증

포트 충돌 방지를 위해 기존 웹 컨테이너를 먼저 제거합니다.

```bash
docker rm -f e1-1-web e1-1-bind 2>/dev/null || true
```

## 17.1 최초 파일 작성

```bash
cd ~/codyssey-training/codyssey-training-e1-1
mkdir -p bind-test

cat > bind-test/index.html <<'EOF'
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <title>Bind Mount Test</title>
</head>
<body>
  <h1>바인드 마운트 최초 화면</h1>
</body>
</html>
EOF
```

## 17.2 바인드 마운트 컨테이너 실행

```bash
docker run -d \
  --name e1-1-bind \
  -p 8080:80 \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine
```

확인:

```bash
curl http://localhost:8080
```

출력에 다음 문구가 보여야 합니다.

```text
바인드 마운트 최초 화면
```

## 17.3 호스트 파일 변경

```bash
cat > bind-test/index.html <<'EOF'
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <title>Bind Mount Test</title>
</head>
<body>
  <h1>바인드 마운트 변경 반영 성공</h1>
</body>
</html>
EOF
```

컨테이너를 재시작하지 않고 다시 확인합니다.

```bash
curl http://localhost:8080
```

출력에 다음 문구가 보여야 합니다.

```text
바인드 마운트 변경 반영 성공
```

## 17.4 증거 캡처

```text
docs/screenshots/bind-mount/01-before.png
docs/screenshots/bind-mount/02-after.png
```

> 핵심은 컨테이너를 새로 빌드하거나 재실행하지 않아도 호스트 파일 변경이 즉시 반영되는 것입니다.

---

# 18. Docker 볼륨 영속성 검증

## 18.1 볼륨 생성

```bash
docker volume create e1-1-data
docker volume ls | grep e1-1-data
```

## 18.2 첫 번째 컨테이너에서 데이터 저장

```bash
docker rm -f e1-1-volume-1 2>/dev/null || true

docker run -d \
  --name e1-1-volume-1 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity
```

```bash
docker exec e1-1-volume-1 \
  bash -lc 'echo "persistent data" > /data/result.txt && cat /data/result.txt'
```

정상 출력:

```text
persistent data
```

## 18.3 첫 번째 컨테이너 삭제

```bash
docker rm -f e1-1-volume-1
```

## 18.4 두 번째 컨테이너에서 데이터 확인

```bash
docker rm -f e1-1-volume-2 2>/dev/null || true

docker run -d \
  --name e1-1-volume-2 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity
```

```bash
docker exec e1-1-volume-2 cat /data/result.txt
```

정상 출력:

```text
persistent data
```

이 결과는 첫 번째 컨테이너가 삭제되어도 Docker 볼륨의 데이터가 유지되었다는 증거입니다.

권장 캡처 파일명:

```text
docs/screenshots/volume/01-volume-persistence.png
```

---

# 19. 수행 증거와 문서 작성

## 19.1 반드시 남길 증거

| 구분 | 필수 증거 |
|---|---|
| 실행 환경 | OS, Shell, Docker, Git 버전 |
| 터미널 | 명령어 입력과 출력 결과 |
| 권한 | 파일과 디렉터리 변경 전후 |
| Docker | `docker version`, `docker info`, 이미지와 컨테이너 목록 |
| Dockerfile | 빌드 성공 로그 |
| 포트 | 주소창과 응답 화면 또는 `curl` 결과 |
| 바인드 마운트 | 변경 전과 변경 후 |
| 볼륨 | 컨테이너 삭제 전후 데이터 확인 |
| GitHub | 저장소와 브랜치, push 결과 |
| VS Code | Remote-SSH 상태와 Ubuntu 경로 |

## 19.2 트러블슈팅 작성 형식

`docs/troubleshooting.md`에 실제 발생한 오류를 최소 2건 작성합니다.

```markdown
## TS-01

- 문제: Docker 명령은 있지만 Server에 연결되지 않음
- 실행 위치: OrbStack Ubuntu
- 실행 명령: `docker info`
- 오류 메시지: 실제 오류 원문
- 원인: OrbStack Docker command link가 연결되지 않음
- 해결 방법: `mac unlink docker` 후 `mac link docker`
- 해결 확인: `docker version`, `docker info`, `hello-world` 성공
- 재발 방지: OrbStack 실행 상태를 먼저 확인
```

실제 오류가 없었다면 억지로 오류를 만들지 말고 다음처럼 작성합니다.

```markdown
## 예방 점검 사례

- 예상 문제:
- 사전 확인 명령:
- 예방 조치:
- 확인 결과:
```

## 19.3 보안 점검

```bash
git status -sb
git diff
git diff --cached

git grep -n -i -E 'token|password|secret|private.?key' || true
```

저장소에 포함하면 안 되는 정보:

- GitHub Personal Access Token
- 로그인 인증 코드
- 비밀번호
- 개인키
- `~/.config/gh/hosts.yml`
- `~/.ssh` 전체
- `.env`, `.env.local`
- 학교 내부 민감정보

---

# 20. Git 커밋과 GitHub 푸시

## 20.1 항상 반복할 순서

```text
파일 수정
→ git status -sb
→ git diff
→ 필요한 파일만 git add
→ git diff --cached
→ git commit
→ git push
```

## 20.2 첫 커밋

```bash
cd ~/codyssey-training/codyssey-training-e1-1

git status -sb
git diff

git add E1-1-training.md .gitignore docs

git diff --cached --stat
git diff --cached

git commit -m "Docs: initialize E1-1 practice structure"
```

## 20.3 Dockerfile 커밋

```bash
git add Dockerfile .dockerignore site/index.html

git diff --cached
git commit -m "Feat: add custom NGINX Docker image"
```

## 20.4 실습 결과 커밋

```bash
git add practice bind-test docs README.md

git diff --cached
git commit -m "Docs: record terminal Docker and persistence tests"
```

## 20.5 원격 저장소에 push

첫 push:

```bash
git push -u origin feat/e1-1-workstation
```

이후 push:

```bash
git push
```

> `git diff --cached`를 확인하기 전에는 커밋하지 않습니다.

---

# 21. Clean clone 재현성 검증

현재 작업 폴더가 아닌 새로운 폴더에 저장소를 다시 복제해 검증합니다.

## 21.1 현재 작업 저장

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git status -sb
git push
```

작업 파일이 남아 있으면 먼저 커밋하거나 원인을 확인합니다.

## 21.2 새 검증 폴더 생성

```bash
RETEST_DIR="$HOME/codyssey-retest/e1-1-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$(dirname "$RETEST_DIR")"

echo "$RETEST_DIR"
```

## 21.3 작업 브랜치만 새로 clone

```bash
gh repo clone gahyun1004/codyssey-training-e1-1 \
  "$RETEST_DIR" \
  -- \
  --branch feat/e1-1-workstation \
  --single-branch
```

```bash
cd "$RETEST_DIR"
git status -sb
```

## 21.4 다시 빌드하고 실행

```bash
docker build -t codyssey-e1-1-web:retest .

docker rm -f e1-1-retest 2>/dev/null || true

docker run -d \
  --name e1-1-retest \
  -p 18080:80 \
  codyssey-e1-1-web:retest

curl http://localhost:18080
```

정상 기준:

- clone 직후 별도 수정 없이 빌드된다.
- `curl` 결과에 웹 페이지가 표시된다.

검증 후 컨테이너만 정리합니다.

```bash
docker rm -f e1-1-retest
```

원래 작업 폴더로 돌아갑니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
```

clean clone 결과를 README 또는 `docs/environment.md`에 기록하고 커밋합니다.

---

# 22. Pull Request와 main 병합

동료 평가는 기본 브랜치인 `main`을 기준으로 진행되므로 최종 결과가 반드시 `main`에 있어야 합니다.

## 22.1 기존 PR 확인

```bash
gh pr list \
  --head feat/e1-1-workstation \
  --base main \
  --state open
```

기존 PR이 있으면 새 PR을 만들지 않습니다.

## 22.2 PR이 없을 때 생성

```bash
gh pr create \
  --base main \
  --head feat/e1-1-workstation \
  --title "Feat: complete E1-1 workstation mission" \
  --body "터미널, 권한, Dockerfile, 포트 매핑, 바인드 마운트, 볼륨 영속성 및 clean clone 검증을 완료했습니다."
```

PR 확인:

```bash
gh pr view
gh pr diff --name-only
gh pr diff
```

확인할 내용:

- 의도한 파일만 포함되어 있다.
- 토큰이나 인증 정보가 없다.
- Dockerfile과 웹 파일이 있다.
- README와 증거 문서가 있다.
- clean clone 결과가 있다.

## 22.3 병합

모든 검증이 끝난 후에만 실행합니다.

```bash
gh pr merge --merge --delete-branch
```

> 저장소 정책 때문에 병합이 막히면 `--admin`으로 우회하지 말고 표시된 원인을 해결합니다.

---

# 23. 병합 후 최종 검증

## 23.1 main 최신화

```bash
cd ~/codyssey-training/codyssey-training-e1-1

git switch main
git pull --ff-only origin main
git fetch --prune
```

## 23.2 Git 상태 확인

```bash
git status -sb
git log --oneline --graph --decorate -15
```

정상 기준:

- 현재 브랜치가 `main`이다.
- 작업 트리가 깨끗하다.
- E1-1 작업 커밋이 병합되어 있다.

## 23.3 main에서 재빌드

```bash
docker build -t codyssey-e1-1-web:final .

docker rm -f e1-1-final 2>/dev/null || true

docker run -d \
  --name e1-1-final \
  -p 18081:80 \
  codyssey-e1-1-web:final

curl http://localhost:18081
```

정상 기준:

- 빌드 성공
- 컨테이너 실행 성공
- HTTP 응답 성공

검증 후 컨테이너를 정리합니다.

```bash
docker rm -f e1-1-final
```

---

# 24. 대표 오류 해결표

| 증상 | 확인 명령 | 해결 방법 |
|---|---|---|
| `orb: command not found` | `command -v orb` | OrbStack 설치·실행 후 터미널 재시작 |
| 머신이 없음 | `orb list` | `orb create ubuntu:noble codyssey-training` |
| Ubuntu 인터넷 연결 실패 | `getent hosts github.com` | Mac 네트워크와 OrbStack 상태 확인 |
| `docker: command not found` | `command -v docker` | `mac link docker` 실행 |
| Docker Server가 안 보임 | `docker version` | OrbStack 실행 후 command link 재연결 |
| `Cannot connect to Docker daemon` | `docker info` | `mac unlink docker` → `mac link docker` |
| `gh: command not found` | `command -v gh` | 8장의 GitHub CLI 설치 수행 |
| GitHub 인증 실패 | `gh auth status` | `gh auth login --hostname github.com --git-protocol https --web` |
| push 권한 없음 | `viewerPermission` | `WRITE` 이상 권한 확인 |
| clone 폴더가 이미 있음 | `git status -sb` | 삭제하지 말고 기존 폴더 사용 |
| 브랜치가 이미 있음 | `git branch` | `git switch feat/e1-1-workstation` |
| 현재 브랜치가 `main` | `git branch --show-current` | 작업 브랜치로 전환 |
| VS Code 경로가 `/Users/...` | `pwd` | Remote-SSH로 다시 연결 |
| `not a git repository` | `pwd` | 저장소 폴더로 이동 |
| 포트가 이미 사용 중 | `docker ps` | 8081 또는 다른 포트 사용 |
| 컨테이너 이름 충돌 | `docker ps -a` | 해당 E1-1 컨테이너만 `docker rm -f` |
| 바인드 마운트 변경이 안 보임 | `pwd`, `docker inspect` | 저장소 루트에서 절대 경로 확인 |
| 볼륨 파일이 없음 | `docker volume ls` | 두 컨테이너에 같은 볼륨 이름 사용 확인 |
| Git에 권한 변경이 안 보임 | `ls -l` | 스크린샷과 문서로 증명 |
| push 거절 | `git fetch`, `git status` | force push 금지, 원격 변경 확인 후 해결 |
| PR에 파일이 너무 많음 | `gh pr diff --name-only` | 의도하지 않은 파일 제거 후 다시 push |

---

# 25. 평가 전 최종 체크리스트

## 저장소

- [ ] GitHub 저장소가 공개 또는 평가 가능한 권한이다.
- [ ] 최종 결과가 `main` 브랜치에 있다.
- [ ] README에서 수행 결과와 증거 위치를 확인할 수 있다.
- [ ] `E1-1-training.md`가 저장소에 있다.

## 터미널과 권한

- [ ] `pwd`, `ls -la`, `cd`, `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat`을 수행했다.
- [ ] 절대 경로와 상대 경로를 설명할 수 있다.
- [ ] 파일 권한 변경 전후를 기록했다.
- [ ] 디렉터리 권한 변경 전후를 기록했다.
- [ ] `755`와 `644`를 설명할 수 있다.

## Docker

- [ ] `docker --version`과 `docker info` 결과가 있다.
- [ ] `docker images`, `docker ps -a`, `docker logs`, `docker stats` 결과가 있다.
- [ ] `hello-world` 실행에 성공했다.
- [ ] Ubuntu 컨테이너 내부에서 명령을 실행했다.
- [ ] `attach`와 `exec`의 차이를 설명할 수 있다.

## Dockerfile과 네트워크

- [ ] Dockerfile을 직접 작성했다.
- [ ] 베이스 이미지 선택 이유를 설명할 수 있다.
- [ ] 이미지 빌드에 성공했다.
- [ ] 포트 매핑이 필요한 이유를 설명할 수 있다.
- [ ] 주소창과 웹 페이지가 함께 보이는 캡처가 있다.

## 저장소 연결

- [ ] 바인드 마운트 변경 전후를 증명했다.
- [ ] Docker 볼륨 생성·연결·검증 명령을 기록했다.
- [ ] 컨테이너 삭제 후에도 데이터가 유지되었다.

## Git과 GitHub

- [ ] Git 사용자 설정을 완료했다.
- [ ] GitHub CLI 로그인을 완료했다.
- [ ] VS Code Remote-SSH 연결 증거가 있다.
- [ ] 기능 단위 커밋이 있다.
- [ ] 작업 브랜치를 main에 병합했다.

## 문서와 보안

- [ ] 트러블슈팅을 2건 이상 기록했다.
- [ ] 명령과 출력 결과가 함께 보인다.
- [ ] clean clone 검증에 성공했다.
- [ ] 특정 개인 PC 경로에 대한 설명 또는 대체 방법이 있다.
- [ ] 토큰, 비밀번호, 개인키, 인증 코드가 노출되지 않았다.

---

## 완료 문장 예시

> macOS와 OrbStack Ubuntu 24.04 환경에서 터미널·권한·Docker·Git/GitHub 개발 워크스테이션을 구축했다. 직접 작성한 Dockerfile로 NGINX 웹 서버 이미지를 빌드하고 포트 매핑, 바인드 마운트, Docker 볼륨 영속성을 검증했다. 모든 과정은 명령어와 출력 결과로 기록했으며, clean clone과 main 브랜치 최종 검증을 완료했다.
