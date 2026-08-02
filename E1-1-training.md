# E1-1 초보자 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 ‘작업실’ 꾸미기  
> **권장 환경:** macOS + OrbStack + Ubuntu 24.04 LTS + Docker  
> **대상 저장소:** `gahyun1004/codyssey-training-e1-1`  
> **작업 브랜치:** `feat/e1-1-workstation`

[미션 요구사항 README로 돌아가기](README.md)

이 문서는 초보자가 위에서부터 한 단계씩 실행하면서 E1-1 미션을 완료하도록 구성한 실습 가이드입니다.

벤치마킹 문서의 장점인 **실행 위치 표시, 정상 기준 확인, 오류 발생 시 중단, 작업 브랜치 사용, clean clone 재검증** 방식을 적용하되, 현재 저장소와 E1-1 필수 요구사항에 맞게 절차를 단순화했습니다.

> 컴퓨터마다 설치 상태가 다르므로 오류가 전혀 없다고 보장할 수는 없습니다. 각 단계의 정상 기준과 오류 대응표를 확인하면서 진행하면 시행착오를 크게 줄일 수 있습니다.

---

## 목차

1. [문서 사용 규칙](#1-문서-사용-규칙)
2. [완료 기준](#2-완료-기준)
3. [전체 수행 순서](#3-전체-수행-순서)
4. [OrbStack과 Ubuntu 준비](#4-orbstack과-ubuntu-준비)
5. [Ubuntu 기본 환경 준비](#5-ubuntu-기본-환경-준비)
6. [Docker 연결과 점검](#6-docker-연결과-점검)
7. [GitHub CLI 설치와 로그인](#7-github-cli-설치와-로그인)
8. [저장소 clone과 작업 브랜치](#8-저장소-clone과-작업-브랜치)
9. [VS Code Remote-SSH 연결](#9-vs-code-remote-ssh-연결)
10. [저장소 기본 구조 만들기](#10-저장소-기본-구조-만들기)
11. [터미널 기본 조작 실습](#11-터미널-기본-조작-실습)
12. [파일과 디렉터리 권한 실습](#12-파일과-디렉터리-권한-실습)
13. [Docker 기본 운영 실습](#13-docker-기본-운영-실습)
14. [Dockerfile 웹 서버 제작](#14-dockerfile-웹-서버-제작)
15. [포트 매핑 검증](#15-포트-매핑-검증)
16. [바인드 마운트 검증](#16-바인드-마운트-검증)
17. [Docker 볼륨 영속성 검증](#17-docker-볼륨-영속성-검증)
18. [증거와 트러블슈팅 기록](#18-증거와-트러블슈팅-기록)
19. [Git 커밋과 push](#19-git-커밋과-push)
20. [Clean clone 재현성 검증](#20-clean-clone-재현성-검증)
21. [Pull Request와 main 병합](#21-pull-request와-main-병합)
22. [병합 후 최종 검증](#22-병합-후-최종-검증)
23. [대표 오류 해결표](#23-대표-오류-해결표)
24. [평가 전 최종 체크리스트](#24-평가-전-최종-체크리스트)

---

# 1. 문서 사용 규칙

## 1.1 실행 위치

| 표시 | 실행 위치 |
|---|---|
| **[macOS]** | Mac 터미널 |
| **[Ubuntu]** | OrbStack `codyssey-training` 셸 |
| **[VS Code Ubuntu]** | Remote-SSH로 연결한 VS Code 통합 터미널 |
| **[컨테이너]** | Docker 컨테이너 내부 |
| **[확인]** | 상태 확인 명령 |
| **[오류 시]** | 실제 오류가 발생했을 때만 실행 |

## 1.2 실행 원칙

1. 명령 블록을 한 번에 하나씩 실행합니다.
2. 명령 앞의 `$`나 설명 문구는 입력하지 않습니다.
3. 바로 아래의 정상 기준을 확인한 후 다음 단계로 이동합니다.
4. 오류가 발생하면 다음 단계로 넘어가지 않습니다.
5. 현재 브랜치가 `main`이면 파일을 수정하지 않습니다.
6. `git diff --cached`를 확인한 후 커밋합니다.
7. 토큰, 비밀번호, 인증 코드, 개인키는 캡처하거나 커밋하지 않습니다.

사용하지 않을 명령:

```bash
git push --force
git reset --hard
docker system prune
docker system prune -a
rm -rf ~
```

## 1.3 즉시 중단 조건

- `docker version`에서 Server 정보가 나오지 않음
- `docker info` 실패
- `docker run --rm hello-world` 실패
- `gh auth status` 실패
- GitHub 권한이 `READ`
- 현재 브랜치가 `main`인데 파일이 수정됨
- VS Code 터미널 경로가 `/Users/...`로 표시됨
- clean clone에서 Docker 빌드 실패

---

# 2. 완료 기준

평가자는 기본 브랜치인 `main`에서 다음 결과를 확인할 수 있어야 합니다.

- [ ] OrbStack Ubuntu 24.04 환경을 사용했다.
- [ ] Docker Client와 Server가 정상 연결된다.
- [ ] `hello-world` 실행에 성공했다.
- [ ] 터미널 기본 명령 수행 결과가 있다.
- [ ] 파일과 디렉터리 권한 변경 전후가 있다.
- [ ] Docker 이미지와 컨테이너 운영 결과가 있다.
- [ ] 직접 작성한 `Dockerfile`이 있다.
- [ ] NGINX 웹 서버 이미지 빌드에 성공했다.
- [ ] 포트 매핑 후 브라우저 또는 `curl` 접속에 성공했다.
- [ ] 바인드 마운트 변경 전후가 확인된다.
- [ ] 컨테이너 삭제 후에도 볼륨 데이터가 유지된다.
- [ ] Git, GitHub, VS Code 연동 증거가 있다.
- [ ] 트러블슈팅을 최소 2건 기록했다.
- [ ] clean clone에서 다시 빌드하고 실행했다.
- [ ] 민감정보가 저장소에 없다.

---

# 3. 전체 수행 순서

```text
1. OrbStack 실행 확인
2. Ubuntu 24.04 머신 생성 또는 확인
3. Ubuntu 기본 패키지 설치
4. Docker 연결과 hello-world 확인
5. GitHub CLI 설치와 로그인
6. 저장소 clone
7. 작업 브랜치 생성
8. VS Code Remote-SSH 연결
9. 터미널과 권한 실습
10. Docker 기본 운영
11. Dockerfile 웹 서버 제작
12. 포트 매핑 검증
13. 바인드 마운트 검증
14. Docker 볼륨 영속성 검증
15. 증거와 트러블슈팅 정리
16. 커밋과 push
17. clean clone 검증
18. Pull Request 생성과 main 병합
19. main에서 최종 검증
```

---

# 4. OrbStack과 Ubuntu 준비

## 4.1 OrbStack 확인

OrbStack 애플리케이션을 실행한 뒤 Mac 터미널에서 확인합니다.

```bash
# [macOS]
orb version
orb status
orb list
```

정상 기준:

- OrbStack 버전이 출력된다.
- OrbStack이 실행 중이다.
- Linux machine 목록이 표시된다.

`orb: command not found`가 나오면 OrbStack 설치 여부를 확인하고 앱과 터미널을 다시 실행합니다.

## 4.2 Ubuntu 머신 확인 또는 생성

목록에 `codyssey-training`이 있으면 확인합니다.

```bash
# [macOS]
orb info codyssey-training
```

없을 때만 생성합니다.

```bash
orb create ubuntu:noble codyssey-training
```

자원을 제한하려면 위 명령 대신 다음 명령 하나만 사용합니다.

```bash
orb create \
  --memory 4G \
  --cpus 2 \
  --disk 32G \
  ubuntu:noble \
  codyssey-training
```

## 4.3 Ubuntu 접속

```bash
# [macOS]
orb -m codyssey-training
```

```bash
# [Ubuntu]
cat /etc/os-release
uname -a
uname -m
whoami
pwd
```

정상 기준:

- Ubuntu 24.04 또는 `VERSION_CODENAME=noble`
- 현재 사용자 표시
- `/home/...` 경로 표시

---

# 5. Ubuntu 기본 환경 준비

## 5.1 네트워크 확인

```bash
# [Ubuntu]
getent hosts github.com
curl -I https://github.com
```

두 명령 중 하나라도 실패하면 네트워크 문제를 먼저 해결합니다.

## 5.2 패키지 설치

```bash
sudo apt update
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
```

## 5.3 작업 폴더

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

# 6. Docker 연결과 점검

## 6.1 Docker 명령 확인

```bash
# [Ubuntu]
command -v docker || true
```

경로가 출력되지 않을 때만 실행합니다.

```bash
mac link docker
hash -r
command -v docker
```

## 6.2 Client와 Server 확인

```bash
docker version
docker info
```

정상 기준:

- `docker version`에 Client와 Server가 모두 표시된다.
- `docker info`가 오류 없이 출력된다.

## 6.3 hello-world

```bash
docker run --rm hello-world
```

정상 출력:

```text
Hello from Docker!
```

## 6.4 연결 오류 복구

실제 연결 오류가 있을 때만 실행합니다.

```bash
mac unlink docker
mac link docker
hash -r
exec "$SHELL" -l
```

새 셸에서 다시 확인합니다.

```bash
docker version
docker info
docker run --rm hello-world
```

---

# 7. GitHub CLI 설치와 로그인

## 7.1 설치 확인

```bash
# [Ubuntu]
command -v gh || true
gh --version || true
```

버전이 출력되면 설치 단계를 건너뜁니다.

## 7.2 설치

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

```bash
gh --version
```

## 7.3 로그인

```bash
gh auth login \
  --hostname github.com \
  --git-protocol https \
  --web
```

브라우저 안내에 따라 로그인한 후 확인합니다.

```bash
gh auth status --hostname github.com
gh auth setup-git --hostname github.com
```

## 7.4 저장소 권한 확인

```bash
gh repo view gahyun1004/codyssey-training-e1-1 \
  --json nameWithOwner,viewerPermission
```

`ADMIN`, `MAINTAIN`, `WRITE` 중 하나여야 합니다. `READ`이면 push 권한을 먼저 해결합니다.

---

# 8. 저장소 clone과 작업 브랜치

## 8.1 처음 clone하는 경우

```bash
cd ~/codyssey-training
gh repo clone gahyun1004/codyssey-training-e1-1
cd codyssey-training-e1-1
```

## 8.2 폴더가 이미 있는 경우

기존 폴더를 삭제하지 않습니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git status -sb
git remote -v
```

`origin`이 `gahyun1004/codyssey-training-e1-1`을 가리켜야 합니다.

## 8.3 Git 사용자 정보

```bash
git config --global user.name || true
git config --global user.email || true
```

값이 없을 때만 설정합니다.

```bash
git config --global user.name "본인의 Git 이름"
git config --global user.email "본인의 GitHub 이메일"
git config --global init.defaultBranch main
```

## 8.4 main 최신화

```bash
git switch main
git pull --ff-only origin main
```

## 8.5 작업 브랜치 생성

처음 생성할 때:

```bash
git switch -c feat/e1-1-workstation
```

이미 존재한다는 오류가 나오면 다음 명령으로 전환합니다.

```bash
git switch feat/e1-1-workstation
```

확인:

```bash
git branch --show-current
git status -sb
```

정상 브랜치:

```text
feat/e1-1-workstation
```

---

# 9. VS Code Remote-SSH 연결

## 9.1 Mac으로 돌아가기

```bash
# [Ubuntu]
exit
```

## 9.2 SSH 확인

```bash
# [macOS]
ssh codyssey-training@orb
```

Ubuntu가 열리면 성공입니다. 다시 Mac으로 돌아옵니다.

```bash
exit
```

## 9.3 VS Code 연결

Mac의 VS Code에서 `Remote - SSH` 확장을 설치합니다.

```text
확장 ID: ms-vscode-remote.remote-ssh
```

명령 팔레트에서 다음 순서로 접속합니다.

```text
Shift + Command + P
→ Remote-SSH: Connect to Host...
→ codyssey-training@orb
```

접속 후 다음 폴더를 엽니다.

```text
/home/사용자이름/codyssey-training/codyssey-training-e1-1
```

## 9.4 원격 터미널 검증

VS Code에서 `Terminal → New Terminal`을 선택한 후 실행합니다.

```bash
# [VS Code Ubuntu]
cat /etc/os-release
pwd
git rev-parse --show-toplevel
git branch --show-current
```

정상 기준:

- Ubuntu 24.04
- `/home/.../codyssey-training-e1-1`
- 현재 Git 저장소 경로 표시
- `feat/e1-1-workstation`

`/Users/...`, `main`, `not a git repository`가 나오면 올바른 원격 폴더를 다시 엽니다.

---

# 10. 저장소 기본 구조 만들기

아래 명령은 VS Code Ubuntu 터미널에서 실행합니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1

mkdir -p site bind-test practice docs/logs
mkdir -p docs/screenshots/{environment,terminal,permissions,docker,port-mapping,bind-mount,volume,github,vscode}
```

`.gitignore` 작성:

```bash
cat > .gitignore <<'EOF'
.DS_Store
.env
.env.local
*.log
EOF
```

환경 문서 작성:

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

실제 실행한 명령과 결과를 이곳에 작성합니다.
EOF
```

트러블슈팅 문서 작성:

```bash
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

환경 정보 확인:

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

# 11. 터미널 기본 조작 실습

## 11.1 실습

```bash
cd ~/codyssey-training/codyssey-training-e1-1
mkdir -p practice/terminal
cd practice/terminal

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

## 11.2 명령 의미

| 명령 | 의미 |
|---|---|
| `pwd` | 현재 위치 |
| `ls -la` | 숨김 파일을 포함한 상세 목록 |
| `cd` | 경로 이동 |
| `mkdir` | 디렉터리 생성 |
| `touch` | 빈 파일 생성 |
| `echo` | 문자열 출력 또는 파일 작성 |
| `cat` | 파일 내용 확인 |
| `cp` | 복사 |
| `mv` | 이동 또는 이름 변경 |
| `rm` | 파일 삭제 |
| `rmdir` | 빈 디렉터리 삭제 |

절대 경로와 상대 경로 확인:

```bash
pwd
realpath sample.txt
```

- `/`로 시작하는 경로: 절대 경로
- 현재 위치를 기준으로 하는 경로: 상대 경로

권장 캡처:

```text
docs/screenshots/terminal/01-basic-commands.png
```

---

# 12. 파일과 디렉터리 권한 실습

## 12.1 파일 권한

```bash
cd ~/codyssey-training/codyssey-training-e1-1/practice

touch permission-file.txt
ls -l permission-file.txt
chmod 644 permission-file.txt
ls -l permission-file.txt
chmod 600 permission-file.txt
ls -l permission-file.txt
```

## 12.2 디렉터리 권한

```bash
mkdir -p permission-dir
ls -ld permission-dir
chmod 755 permission-dir
ls -ld permission-dir
chmod 700 permission-dir
ls -ld permission-dir
```

## 12.3 숫자 권한

| 숫자 | 권한 |
|---:|---|
| 4 | 읽기 `r` |
| 2 | 쓰기 `w` |
| 1 | 실행·진입 `x` |
| 7 | `rwx` |
| 6 | `rw-` |
| 5 | `r-x` |

- `755`: 소유자 `rwx`, 그룹 `r-x`, 기타 `r-x`
- `644`: 소유자 `rw-`, 그룹 `r--`, 기타 `r--`

Git은 일반 파일의 `644`와 `600` 차이를 변경사항으로 표시하지 않을 수 있습니다. 따라서 `ls -l` 결과와 스크린샷으로 증명합니다.

```text
docs/screenshots/permissions/01-file-permission.png
docs/screenshots/permissions/02-directory-permission.png
```

---

# 13. Docker 기본 운영 실습

저장소 루트로 이동합니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
```

## 13.1 상태와 목록

```bash
docker --version
docker version
docker info
docker images
docker ps
docker ps -a
docker stats --no-stream
```

## 13.2 hello-world 컨테이너

```bash
docker rm -f e1-1-hello 2>/dev/null || true
docker run --name e1-1-hello hello-world
docker ps -a
docker logs e1-1-hello
```

## 13.3 Ubuntu 컨테이너

```bash
docker rm -f e1-1-ubuntu 2>/dev/null || true

docker run -d \
  --name e1-1-ubuntu \
  ubuntu:24.04 \
  bash -lc 'echo "e1-1-ubuntu started"; sleep infinity'

docker ps
docker logs e1-1-ubuntu
docker exec -it e1-1-ubuntu bash
```

컨테이너 내부:

```bash
# [컨테이너]
pwd
ls -la
echo "Hello from Ubuntu container"
exit
```

Ubuntu로 돌아와 실행합니다.

```bash
docker stop e1-1-ubuntu
docker ps -a
docker start e1-1-ubuntu
docker ps
docker rm -f e1-1-ubuntu
```

- `attach`: 컨테이너의 기본 프로세스에 연결
- `exec`: 실행 중인 컨테이너에서 새 명령 실행

초보자 실습에서는 `docker exec`가 더 안전합니다.

---

# 14. Dockerfile 웹 서버 제작

## 14.1 HTML 작성

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

```bash
cat site/index.html
```

## 14.2 Dockerfile 작성

```bash
cat > Dockerfile <<'EOF'
FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-e1-1-web"
LABEL org.opencontainers.image.description="Codyssey E1-1 custom NGINX web server"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
EOF
```

## 14.3 .dockerignore

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

## 14.4 빌드

```bash
docker build -t codyssey-e1-1-web:1.0 .
docker images | grep codyssey-e1-1-web
docker image inspect codyssey-e1-1-web:1.0
```

정상 기준: 빌드가 오류 없이 완료되고 이미지가 목록에 표시됩니다.

---

# 15. 포트 매핑 검증

## 15.1 8080 포트 실행

```bash
docker rm -f e1-1-web 2>/dev/null || true

docker run -d \
  --name e1-1-web \
  -p 8080:80 \
  codyssey-e1-1-web:1.0
```

```bash
docker ps
docker logs e1-1-web
docker port e1-1-web
curl http://localhost:8080
```

정상 기준:

- `e1-1-web`이 실행 중이다.
- `8080`이 컨테이너의 `80`에 연결된다.
- HTML 응답이 출력된다.

Mac 브라우저에서 접속합니다.

```text
http://localhost:8080
```

주소창과 웹 페이지가 함께 보이도록 캡처합니다.

```text
docs/screenshots/port-mapping/01-browser-8080.png
```

## 15.2 포트 충돌 시

다음 오류가 나오면 8080 포트가 사용 중입니다.

```text
port is already allocated
```

```bash
docker rm -f e1-1-web 2>/dev/null || true

docker run -d \
  --name e1-1-web \
  -p 8081:80 \
  codyssey-e1-1-web:1.0

curl http://localhost:8081
```

브라우저 주소도 `http://localhost:8081`로 변경합니다.

---

# 16. 바인드 마운트 검증

포트 충돌을 막기 위해 기존 컨테이너를 제거합니다.

```bash
docker rm -f e1-1-web e1-1-bind 2>/dev/null || true
```

## 16.1 최초 파일

```bash
cd ~/codyssey-training/codyssey-training-e1-1
mkdir -p bind-test

cat > bind-test/index.html <<'EOF'
<!doctype html>
<html lang="ko">
<head><meta charset="utf-8"><title>Bind Mount</title></head>
<body><h1>바인드 마운트 최초 화면</h1></body>
</html>
EOF
```

## 16.2 컨테이너 실행

```bash
docker run -d \
  --name e1-1-bind \
  -p 8080:80 \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine

curl http://localhost:8080
```

`바인드 마운트 최초 화면`이 출력되어야 합니다.

## 16.3 파일 변경

```bash
cat > bind-test/index.html <<'EOF'
<!doctype html>
<html lang="ko">
<head><meta charset="utf-8"><title>Bind Mount</title></head>
<body><h1>바인드 마운트 변경 반영 성공</h1></body>
</html>
EOF

curl http://localhost:8080
```

컨테이너를 재실행하지 않았는데 `변경 반영 성공`이 출력되어야 합니다.

```text
docs/screenshots/bind-mount/01-before.png
docs/screenshots/bind-mount/02-after.png
```

---

# 17. Docker 볼륨 영속성 검증

## 17.1 볼륨 생성

```bash
docker volume create e1-1-data
docker volume ls | grep e1-1-data
```

## 17.2 첫 번째 컨테이너

```bash
docker rm -f e1-1-volume-1 2>/dev/null || true

docker run -d \
  --name e1-1-volume-1 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-1 \
  bash -lc 'echo "persistent data" > /data/result.txt && cat /data/result.txt'
```

정상 출력:

```text
persistent data
```

## 17.3 첫 번째 컨테이너 삭제

```bash
docker rm -f e1-1-volume-1
```

## 17.4 두 번째 컨테이너

```bash
docker rm -f e1-1-volume-2 2>/dev/null || true

docker run -d \
  --name e1-1-volume-2 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-2 cat /data/result.txt
```

다시 `persistent data`가 출력되면 데이터 영속성 검증에 성공한 것입니다.

```text
docs/screenshots/volume/01-volume-persistence.png
```

---

# 18. 증거와 트러블슈팅 기록

## 18.1 필수 증거

| 구분 | 증거 |
|---|---|
| 환경 | OS, Shell, Docker, Git 버전 |
| 터미널 | 입력 명령과 출력 결과 |
| 권한 | 파일·디렉터리 변경 전후 |
| Docker | version, info, images, ps, logs, stats |
| Dockerfile | 빌드 성공 로그 |
| 포트 | 브라우저 주소창과 응답 또는 curl |
| 바인드 마운트 | 변경 전후 |
| 볼륨 | 컨테이너 삭제 전후 데이터 |
| GitHub | 브랜치와 push 결과 |
| VS Code | Remote-SSH와 Ubuntu 경로 |

## 18.2 트러블슈팅

`docs/troubleshooting.md`에 실제 오류를 2건 이상 기록합니다.

```markdown
## TS-01

- 문제:
- 실행 위치:
- 실행 명령:
- 오류 메시지 원문:
- 원인:
- 해결 방법:
- 해결 확인:
- 재발 방지:
```

실제 오류가 없으면 억지로 실패를 만들지 말고 예방 점검 사례를 기록합니다.

## 18.3 보안 점검

```bash
git status -sb
git diff
git diff --cached
git grep -n -i -E 'token|password|secret|private.?key' || true
```

커밋 금지:

- GitHub 토큰과 인증 코드
- 비밀번호와 개인키
- `~/.config/gh/hosts.yml`
- `~/.ssh` 전체
- `.env`, `.env.local`
- 학교 내부 민감정보

---

# 19. Git 커밋과 push

## 19.1 반복 절차

```text
수정 → git status → git diff → git add → git diff --cached → commit → push
```

## 19.2 기본 구조 커밋

```bash
cd ~/codyssey-training/codyssey-training-e1-1

git status -sb
git diff

git add E1-1-training.md .gitignore docs
git diff --cached --stat
git diff --cached
git commit -m "Docs: initialize E1-1 practice structure"
```

## 19.3 Dockerfile 커밋

```bash
git add Dockerfile .dockerignore site/index.html
git diff --cached
git commit -m "Feat: add custom NGINX Docker image"
```

## 19.4 실습 결과 커밋

```bash
git add practice bind-test docs README.md
git diff --cached
git commit -m "Docs: record terminal and Docker verification"
```

## 19.5 push

첫 push:

```bash
git push -u origin feat/e1-1-workstation
```

그다음부터:

```bash
git push
```

---

# 20. Clean clone 재현성 검증

## 20.1 현재 작업 저장

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git status -sb
git push
```

작업 파일이 남아 있으면 커밋하거나 원인을 확인합니다.

## 20.2 새 폴더에 clone

```bash
RETEST_DIR="$HOME/codyssey-retest/e1-1-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$(dirname "$RETEST_DIR")"

gh repo clone gahyun1004/codyssey-training-e1-1 \
  "$RETEST_DIR" \
  -- \
  --branch feat/e1-1-workstation \
  --single-branch

cd "$RETEST_DIR"
git status -sb
```

## 20.3 재빌드와 실행

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

- clone 직후 수정 없이 빌드 성공
- HTTP 응답 성공

정리:

```bash
docker rm -f e1-1-retest
cd ~/codyssey-training/codyssey-training-e1-1
```

검증 결과를 README 또는 문서에 기록한 후 커밋하고 push합니다.

---

# 21. Pull Request와 main 병합

동료 평가는 기본 브랜치 내용을 기준으로 진행되므로 최종 결과는 반드시 `main`에 있어야 합니다.

## 21.1 기존 PR 확인

```bash
gh pr list \
  --head feat/e1-1-workstation \
  --base main \
  --state open
```

기존 PR이 있으면 새로 만들지 않습니다.

## 21.2 PR 생성

기존 PR이 없을 때만 실행합니다.

```bash
gh pr create \
  --base main \
  --head feat/e1-1-workstation \
  --title "Feat: complete E1-1 workstation mission" \
  --body "터미널, 권한, Dockerfile, 포트 매핑, 바인드 마운트, 볼륨 영속성 및 clean clone 검증을 완료했습니다."
```

```bash
gh pr view
gh pr diff --name-only
gh pr diff
```

확인:

- 의도한 파일만 있다.
- 민감정보가 없다.
- Dockerfile, site, README, 증거 문서가 있다.
- clean clone 결과가 있다.

## 21.3 병합

모든 검증 후 실행합니다.

```bash
gh pr merge --merge --delete-branch
```

정책 때문에 막히면 `--admin`으로 우회하지 말고 원인을 해결합니다.

---

# 22. 병합 후 최종 검증

## 22.1 main 최신화

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git switch main
git pull --ff-only origin main
git fetch --prune
```

```bash
git status -sb
git log --oneline --graph --decorate -15
```

## 22.2 최종 빌드

```bash
docker build -t codyssey-e1-1-web:final .
docker rm -f e1-1-final 2>/dev/null || true

docker run -d \
  --name e1-1-final \
  -p 18081:80 \
  codyssey-e1-1-web:final

curl http://localhost:18081
```

성공 후 정리합니다.

```bash
docker rm -f e1-1-final
```

---

# 23. 대표 오류 해결표

| 증상 | 확인 | 조치 |
|---|---|---|
| `orb: command not found` | `command -v orb` | OrbStack 설치·실행 후 터미널 재시작 |
| 머신이 없음 | `orb list` | Ubuntu 머신 생성 |
| GitHub 접속 실패 | `getent hosts github.com` | Mac 네트워크와 OrbStack 상태 확인 |
| `docker: command not found` | `command -v docker` | `mac link docker` |
| Docker Server 없음 | `docker version` | OrbStack 실행과 command link 확인 |
| daemon 연결 실패 | `docker info` | `mac unlink docker` 후 다시 link |
| `gh: command not found` | `command -v gh` | 7장의 설치 수행 |
| GitHub 인증 실패 | `gh auth status` | `gh auth login ... --web` 다시 수행 |
| push 권한 없음 | `viewerPermission` | WRITE 이상 권한 확인 |
| clone 폴더 중복 | `git status -sb` | 기존 작업 보존, 삭제 금지 |
| 브랜치 중복 | `git branch` | 기존 작업 브랜치로 전환 |
| branch가 main | `git branch --show-current` | 작업 브랜치 전환 |
| VS Code 경로가 `/Users/...` | `pwd` | Remote-SSH로 다시 연결 |
| Git 저장소가 아님 | `pwd` | 저장소 폴더로 이동 |
| 포트 충돌 | `docker ps` | 8081 등 다른 포트 사용 |
| 컨테이너 이름 충돌 | `docker ps -a` | 해당 E1-1 컨테이너만 제거 |
| 바인드 변경 미반영 | `pwd`, `docker inspect` | 저장소 루트와 마운트 경로 확인 |
| 볼륨 파일 없음 | `docker volume ls` | 동일한 볼륨 이름 확인 |
| 권한 변경이 Git에 안 보임 | `ls -l` | 스크린샷과 문서로 증명 |
| push 거절 | `git fetch`, `git status` | force push 금지, 원격 변경 확인 |

---

# 24. 평가 전 최종 체크리스트

## 터미널과 권한

- [ ] `pwd`, `ls -la`, `cd`, `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat` 수행
- [ ] 절대 경로와 상대 경로 설명 가능
- [ ] 파일과 디렉터리 권한 변경 전후 기록
- [ ] `755`, `644` 설명 가능

## Docker

- [ ] `docker --version`, `docker info` 기록
- [ ] `docker images`, `docker ps -a`, `docker logs`, `docker stats` 기록
- [ ] hello-world 실행 성공
- [ ] Ubuntu 컨테이너 내부 명령 실행
- [ ] attach와 exec 차이 설명 가능

## Dockerfile과 접속

- [ ] Dockerfile 직접 작성
- [ ] 베이스 이미지 선택 이유 설명 가능
- [ ] 이미지 빌드 성공
- [ ] 포트 매핑 접속 성공
- [ ] 주소창과 화면이 함께 보이는 캡처

## 마운트와 볼륨

- [ ] 바인드 마운트 변경 전후 증명
- [ ] 볼륨 생성·연결·검증 기록
- [ ] 컨테이너 삭제 후 데이터 유지 확인

## Git과 문서

- [ ] Git 사용자 설정
- [ ] GitHub 로그인과 push
- [ ] VS Code Remote-SSH 증거
- [ ] 기능 단위 커밋
- [ ] 트러블슈팅 2건 이상
- [ ] clean clone 성공
- [ ] 작업 브랜치를 main에 병합
- [ ] 민감정보 없음

---

## 완료 문장 예시

> macOS와 OrbStack Ubuntu 24.04 환경에서 터미널·권한·Docker·Git/GitHub 개발 워크스테이션을 구축했다. 직접 작성한 Dockerfile로 NGINX 웹 서버 이미지를 빌드하고 포트 매핑, 바인드 마운트, Docker 볼륨 영속성을 검증했다. 모든 과정은 명령어와 출력 결과로 기록했으며, clean clone과 main 브랜치 최종 검증을 완료했다.
