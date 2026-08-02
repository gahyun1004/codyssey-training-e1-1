# E1-1 초보자 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 ‘작업실’ 꾸미기  
> **권장 환경:** macOS + OrbStack + Ubuntu 24.04 LTS + OrbStack Docker  
> **대상 저장소:** `gahyun1004/codyssey-training-e1-1`  
> **OrbStack 머신 기본 이름:** `codyssey-training`  
> **작업 브랜치:** `feat/e1-1-workstation`

이 README는 입문자가 위에서부터 한 단계씩 실행하면서 E1-1 미션을 완료하도록 구성했습니다. 각 단계는 **실행 위치 → 명령 → 정상 기준 → 오류 대응 → 증거 기록** 순서로 진행합니다.

> 오류가 발생하면 다음 단계로 넘어가지 말고 오류 메시지 원문, 원인 가설, 확인 과정, 해결 결과를 `docs/troubleshooting.md`에 기록합니다.

---

## 수행 문서

- [실행 환경](docs/environment.md)
- [터미널 및 권한 실습](docs/terminal-and-permissions.md)
- [Docker 운영](docs/docker-operations.md)
- [커스텀 이미지 설계](docs/image-design.md)
- [포트 매핑 및 바인드 마운트](docs/port-and-bind.md)
- [볼륨 영속성](docs/volume-persistence.md)
- [최종 검증 결과](docs/test-results.md)
- [트러블슈팅](docs/troubleshooting.md)
- [스크린샷 규칙](docs/screenshots/README.md)

---

## 목차

1. [문서 사용 규칙](#1-문서-사용-규칙)
2. [완료 기준](#2-완료-기준)
3. [전체 수행 순서](#3-전체-수행-순서)
4. [OrbStack과 Ubuntu 준비](#4-orbstack과-ubuntu-준비)
5. [Ubuntu 기본 환경과 Docker 점검](#5-ubuntu-기본-환경과-docker-점검)
6. [GitHub CLI와 저장소 준비](#6-github-cli와-저장소-준비)
7. [VS Code Remote-SSH를 현재 원격 폴더로 실행](#7-vs-code-remote-ssh를-현재-원격-폴더로-실행)
8. [프로젝트별 VS Code 터미널 설정](#8-프로젝트별-vs-code-터미널-설정)
9. [저장소 기본 구조와 환경 기록](#9-저장소-기본-구조와-환경-기록)
10. [터미널과 권한 실습](#10-터미널과-권한-실습)
11. [Docker 기본 운영과 attach·exec](#11-docker-기본-운영과-attachexec)
12. [Dockerfile 웹 서버 제작](#12-dockerfile-웹-서버-제작)
13. [포트 매핑 검증](#13-포트-매핑-검증)
14. [바인드 마운트 검증](#14-바인드-마운트-검증)
15. [Docker 볼륨 영속성 검증](#15-docker-볼륨-영속성-검증)
16. [증거와 트러블슈팅 기록](#16-증거와-트러블슈팅-기록)
17. [Git 커밋과 push](#17-git-커밋과-push)
18. [Clean clone과 main 최종 검증](#18-clean-clone과-main-최종-검증)
19. [대표 오류 해결표](#19-대표-오류-해결표)
20. [평가 전 최종 체크리스트](#20-평가-전-최종-체크리스트)

---

# 1. 문서 사용 규칙

## 1.1 실행 위치

| 표시 | 실행 위치 |
|---|---|
| **[macOS]** | Mac 터미널 |
| **[Ubuntu]** | OrbStack `codyssey-training` 셸 |
| **[VS Code Ubuntu]** | Remote-SSH로 연결된 VS Code 통합 터미널 |
| **[컨테이너]** | Docker 컨테이너 내부 |
| **[오류 시]** | 실제 오류가 발생했을 때만 실행 |

## 1.2 실행 원칙

1. 명령 블록을 한 번에 하나씩 실행합니다.
2. 명령 바로 아래의 정상 기준을 확인한 뒤 다음 단계로 이동합니다.
3. 현재 브랜치가 `main`이면 실습 파일을 수정하지 않습니다.
4. 커밋 전 `git diff --cached`로 포함 파일을 확인합니다.
5. 토큰, 비밀번호, 인증 코드, 개인키는 저장소와 캡처에 포함하지 않습니다.
6. Mac에서 원격 VS Code를 열 때는 **Mac의 `code` CLI와 `--remote` 옵션**을 사용합니다.
7. VS Code Remote-SSH 창이 열린 뒤 새 터미널은 **Ubuntu의 `/bin/bash`**와 **열린 저장소 폴더**에서 시작해야 합니다.

사용하지 않을 명령:

```bash
git push --force
git reset --hard
docker system prune
docker system prune -a
rm -rf ~
```

## 1.3 즉시 중단 조건

- `ssh codyssey-training@orb` 실패
- `code --remote` 실행 후 VS Code 왼쪽 아래에 SSH 원격 표시가 없음
- VS Code 터미널의 `pwd`가 `/Users/...`로 표시됨
- VS Code 터미널의 셸이 Ubuntu bash가 아님
- `docker version`에서 Server 정보가 나오지 않음
- `docker info` 또는 `hello-world` 실패
- GitHub 권한이 `READ`
- clean clone에서 Docker 빌드 또는 HTTP 확인 실패

---

# 2. 완료 기준

평가자는 기본 브랜치인 `main`에서 다음 결과를 확인할 수 있어야 합니다.

- [ ] OrbStack Ubuntu 24.04를 사용했다.
- [ ] Mac에서 `ssh codyssey-training@orb` 접속에 성공했다.
- [ ] Mac의 `code --remote "ssh-remote+codyssey-training@orb" <원격경로>`로 원격 저장소를 열었다.
- [ ] `.vscode/settings.json`을 통해 새 터미널이 Ubuntu bash와 `${workspaceFolder}`에서 열린다.
- [ ] VS Code 터미널에서 Ubuntu 버전, bash, 현재 폴더, Git root, 브랜치를 검증했다.
- [ ] Docker Client와 Server가 정상 연결된다.
- [ ] 터미널 기본 명령과 권한 변경 전후가 기록되어 있다.
- [ ] Docker 이미지·컨테이너 운영 결과가 있다.
- [ ] `attach`와 `exec` 차이를 실제로 관찰했다.
- [ ] 직접 작성한 Dockerfile과 웹 소스가 있다.
- [ ] 포트 매핑, 바인드 마운트, 볼륨 영속성을 검증했다.
- [ ] Git·GitHub·VS Code 연동 증거가 있다.
- [ ] 트러블슈팅을 최소 2건 기록했다.
- [ ] clean clone과 `main` 최종 검증을 완료했다.
- [ ] 민감정보가 저장소에 없다.

---

# 3. 전체 수행 순서

```text
1. OrbStack 실행 확인
2. Ubuntu 24.04 머신 생성 또는 확인
3. SSH 접속 확인
4. Ubuntu 기본 패키지와 Docker 확인
5. GitHub CLI 로그인과 저장소 clone
6. 작업 브랜치 선택
7. Mac에서 code --remote로 원격 저장소 열기
8. .vscode 설정으로 Ubuntu bash와 workspace cwd 검증
9. 터미널·권한 실습
10. Docker 기본 운영과 attach·exec 실습
11. Dockerfile 웹 서버 제작
12. 포트 매핑 검증
13. 바인드 마운트 검증
14. Docker 볼륨 영속성 검증
15. 로그·스크린샷·트러블슈팅 정리
16. 기능 단위 commit과 push
17. clean clone 검증
18. Pull Request 병합
19. main 최종 검증
```

---

# 4. OrbStack과 Ubuntu 준비

## 4.1 OrbStack 확인

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

## 4.2 Ubuntu 24.04 머신 확인 또는 생성

목록에 `codyssey-training`이 있으면:

```bash
# [macOS]
orb info codyssey-training
```

없을 때만 생성합니다.

```bash
orb create ubuntu:noble codyssey-training
```

자원 제한이 필요하면 위 명령 대신 다음 하나만 사용합니다.

```bash
orb create \
  --memory 4G \
  --cpus 2 \
  --disk 32G \
  ubuntu:noble \
  codyssey-training
```

## 4.3 SSH 접속 확인

```bash
# [macOS]
ssh codyssey-training@orb
```

Ubuntu 안에서 확인합니다.

```bash
# [Ubuntu]
cat /etc/os-release
uname -a
whoami
pwd
printf 'SHELL=%s\n' "$SHELL"
```

정상 기준:

- Ubuntu 24.04 또는 `VERSION_CODENAME=noble`
- 경로가 `/home/...`
- 셸이 `/bin/bash` 또는 bash 계열

Mac으로 돌아갑니다.

```bash
exit
```

---

# 5. Ubuntu 기본 환경과 Docker 점검

Ubuntu에 접속합니다.

```bash
# [macOS]
ssh codyssey-training@orb
```

## 5.1 네트워크와 패키지

```bash
# [Ubuntu]
getent hosts github.com
curl -I https://github.com

sudo apt update
sudo apt install -y \
  ca-certificates curl wget git gnupg nano vim tree jq tar unzip zip
```

`sudo`가 정책상 제한되면 임의로 우회하지 말고 교육 운영자에게 확인합니다.

## 5.2 Docker 연결

```bash
command -v docker || true
docker context show || true
docker version
docker info
docker run --rm hello-world
```

`docker` 명령이 없을 때만:

```bash
mac link docker
hash -r
command -v docker
```

정상 기준:

- `docker version`에 Client와 Server가 모두 표시된다.
- `docker info`가 성공한다.
- `Hello from Docker!`가 출력된다.

## 5.3 Docker 경로 사전 시험

```bash
mkdir -p ~/docker-path-test
cd ~/docker-path-test

cat > Dockerfile <<'EOF'
FROM alpine
COPY test.txt /test.txt
CMD ["cat", "/test.txt"]
EOF

echo "OrbStack path test" > test.txt

docker build -t orb-path-test .
docker run --rm orb-path-test

docker run --rm \
  -v "$PWD:/data:ro" \
  alpine \
  cat /data/test.txt
```

두 실행 모두 `OrbStack path test`를 출력해야 합니다.

---

# 6. GitHub CLI와 저장소 준비

## 6.1 GitHub CLI 로그인

```bash
# [Ubuntu]
command -v gh || true
gh --version || true
```

`gh`가 없으면 GitHub CLI 공식 설치 절차로 설치한 뒤 로그인합니다.

```bash
gh auth login \
  --hostname github.com \
  --git-protocol https \
  --web

gh auth status --hostname github.com
gh auth setup-git --hostname github.com
```

권한 확인:

```bash
gh repo view gahyun1004/codyssey-training-e1-1 \
  --json nameWithOwner,viewerPermission
```

`ADMIN`, `MAINTAIN`, `WRITE` 중 하나여야 합니다.

## 6.2 저장소 clone

```bash
mkdir -p ~/codyssey-training
cd ~/codyssey-training

if test ! -d codyssey-training-e1-1/.git
then
  gh repo clone gahyun1004/codyssey-training-e1-1
fi

cd codyssey-training-e1-1
git status -sb
git remote -v
```

## 6.3 Git 설정과 작업 브랜치

```bash
git config --global user.name || true
git config --global user.email || true
git config --global init.defaultBranch main
git config --list
```

이름과 이메일이 없을 때만 본인 정보로 설정합니다.

```bash
git config --global user.name "본인의 Git 이름"
git config --global user.email "본인의 GitHub 이메일"
```

작업 브랜치를 안전하게 선택합니다.

```bash
WORK_BRANCH="feat/e1-1-workstation"

git switch main
git pull --ff-only origin main
git fetch origin

if git show-ref --verify --quiet "refs/heads/$WORK_BRANCH"
then
  git switch "$WORK_BRANCH"
elif git ls-remote --exit-code --heads origin "$WORK_BRANCH" >/dev/null 2>&1
then
  git switch --track -c "$WORK_BRANCH" "origin/$WORK_BRANCH"
else
  git switch -c "$WORK_BRANCH"
fi

git branch --show-current
git status -sb
```

---

# 7. VS Code Remote-SSH를 현재 원격 폴더로 실행

## 7.1 핵심 원칙

- Mac에서 실행하는 `code .`의 `.`은 **Mac 현재 폴더**입니다.
- OrbStack Ubuntu 저장소를 열려면 Mac의 VS Code CLI에 **SSH 원격 권한과 Ubuntu 절대 경로**를 함께 전달해야 합니다.
- 일반 SSH 셸에서 `code .`은 VS Code 원격 CLI가 PATH에 없으면 실패할 수 있습니다.
- 가장 안정적인 방법은 Mac에서 `code --remote`를 실행하는 것입니다.
- Remote-SSH 창이 열린 뒤 그 창의 Ubuntu 통합 터미널에서는 `code .`을 사용할 수 있습니다.

## 7.2 Mac의 `code` CLI 확인

```bash
# [macOS]
CODE_BIN="$(command -v code 2>/dev/null || true)"

if test -z "$CODE_BIN"
then
  for candidate in \
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
  do
    if test -x "$candidate"
    then
      CODE_BIN="$candidate"
      break
    fi
  done
fi

if test -z "$CODE_BIN"
then
  echo "[FAIL] VS Code CLI를 찾지 못했습니다."
  exit 1
fi

"$CODE_BIN" --version
"$CODE_BIN" --help | grep -- '--remote'
```

`code: command not found`가 나오면 VS Code에서 다음을 실행할 수도 있습니다.

```text
Shift + Command + P
→ Shell Command: Install 'code' command in PATH
```

권한이 제한된 장비에서는 위의 `CODE_BIN` 방식으로 앱 내부 CLI를 직접 사용합니다.

## 7.3 Remote-SSH 확장 설치

```bash
# [macOS]
"$CODE_BIN" --list-extensions \
  | grep -Fx 'ms-vscode-remote.remote-ssh' || \
  "$CODE_BIN" --install-extension ms-vscode-remote.remote-ssh
```

## 7.4 원격 현재 디렉터리 계산

```bash
# [macOS]
REMOTE_HOST="codyssey-training@orb"
REMOTE_DIR="$(ssh "$REMOTE_HOST" \
  'cd "$HOME/codyssey-training/codyssey-training-e1-1" && pwd -P')"

printf 'REMOTE_HOST=%s\n' "$REMOTE_HOST"
printf 'REMOTE_DIR=%s\n' "$REMOTE_DIR"
```

정상 예시:

```text
REMOTE_HOST=codyssey-training@orb
REMOTE_DIR=/home/사용자이름/codyssey-training/codyssey-training-e1-1
```

## 7.5 `code --remote`로 원격 폴더 열기

```bash
# [macOS]
"$CODE_BIN" \
  --new-window \
  --remote "ssh-remote+${REMOTE_HOST}" \
  "$REMOTE_DIR"
```

기본 형식:

```bash
code --remote \
  "ssh-remote+우분투머신이름@orb" \
  "/home/우분투사용자/현재-실행할-원격-디렉터리"
```

현재 저장소 기준 한 줄 예시:

```bash
code --new-window \
  --remote "ssh-remote+codyssey-training@orb" \
  "$(ssh codyssey-training@orb 'cd ~/codyssey-training/codyssey-training-e1-1 && pwd -P')"
```

## 7.6 자동 실행 스크립트

저장소에는 Mac에서 실행할 스크립트가 포함되어 있습니다.

```bash
# [macOS]
bash scripts/open-vscode-remote.sh
```

다른 OrbStack 머신 이름을 사용한다면:

```bash
bash scripts/open-vscode-remote.sh 다른-머신-이름
```

홈 기준 다른 저장소 경로를 열려면:

```bash
bash scripts/open-vscode-remote.sh \
  codyssey-training \
  codyssey-training/codyssey-training-e1-1
```

## 7.7 원격 연결 성공 기준

VS Code가 열린 뒤 확인합니다.

- 왼쪽 아래 상태 표시줄에 `SSH: codyssey-training@orb`
- Explorer 최상단 폴더가 `codyssey-training-e1-1`
- 새 터미널에서 `pwd`가 Ubuntu 저장소 경로
- 새 터미널에서 `cat /etc/os-release`가 Ubuntu 24.04
- 새 터미널에서 `ps -p $$ -o comm=` 결과가 `bash`

---

# 8. 프로젝트별 VS Code 터미널 설정

저장소의 `.vscode/settings.json`은 Remote-SSH로 열린 Ubuntu 환경에서 새 터미널을 다음 기준으로 시작하도록 설정합니다.

- Linux 기본 프로필: `/bin/bash -l`
- 자동화 작업 셸: `/bin/bash -l`
- 터미널 시작 폴더: `${workspaceFolder}`
- 분할 터미널 시작 폴더: workspace root
- 셸 통합: 활성화

핵심 설정:

```json
{
  "terminal.integrated.profiles.linux": {
    "Ubuntu Bash (login)": {
      "path": "/bin/bash",
      "args": ["-l"],
      "icon": "terminal-bash",
      "overrideName": true
    }
  },
  "terminal.integrated.defaultProfile.linux": "Ubuntu Bash (login)",
  "terminal.integrated.automationProfile.linux": {
    "path": "/bin/bash",
    "args": ["-l"]
  },
  "terminal.integrated.cwd": "${workspaceFolder}",
  "terminal.integrated.splitCwd": "workspaceRoot",
  "terminal.integrated.shellIntegration.enabled": true
}
```

## 8.1 Workspace Trust

처음 열 때 신뢰 여부를 묻는다면 저장소 내용을 확인한 후 **Trust**를 선택해야 프로젝트의 터미널 프로필 설정이 적용됩니다.

## 8.2 새 터미널 검증

먼저 Mac에서 Terminal 앱을 실행합니다.

```text
Command(⌘) + Space
→ Spotlight 검색창에 Terminal 입력
→ Return 또는 Terminal 앱 선택
```

열린 Mac Terminal에서 다음 명령으로 OrbStack Ubuntu의 현재 저장소를 VS Code Remote-SSH 창으로 엽니다.

```bash
code --new-window \
  --remote "ssh-remote+codyssey-training@orb" \
  "$(ssh codyssey-training@orb 'cd ~/codyssey-training/codyssey-training-e1-1 && pwd -P')"
```

`code: command not found`가 나오면 [7.2 Mac의 `code` CLI 확인](#72-mac의-code-cli-확인) 절차를 먼저 수행합니다.

VS Code 왼쪽 아래에 `SSH: codyssey-training@orb`가 표시되는지 확인합니다. 이후 기존 통합 터미널을 모두 닫고 다음 메뉴로 새 터미널을 엽니다.

```text
Terminal → New Terminal
```

검증 명령:

```bash
# [VS Code Ubuntu]
cat /etc/os-release
printf 'SHELL=%s\n' "$SHELL"
ps -p $$ -o comm=
pwd
git rev-parse --show-toplevel
git branch --show-current
```

정상 기준:

- Ubuntu 24.04
- `SHELL=/bin/bash`
- 프로세스가 `bash`
- `pwd`와 Git root가 현재 열린 저장소 폴더
- 브랜치가 `feat/e1-1-workstation`

명령 팔레트에서도 검증 작업을 실행할 수 있습니다.

```text
Shift + Command + P
→ Tasks: Run Task
→ E1-1: Verify Ubuntu Remote Workspace
```

> `.vscode/settings.json`은 원격 연결 이후의 터미널을 설정합니다. SSH 연결 자체는 Mac의 Remote-SSH 확장과 `code --remote` 명령이 담당합니다.

---

# 9. 저장소 기본 구조와 환경 기록

권장 구조:

```text
codyssey-training-e1-1/
├── README.md
├── Dockerfile
├── .dockerignore
├── .gitignore
├── .vscode/
│   ├── settings.json
│   ├── extensions.json
│   └── tasks.json
├── scripts/
│   └── open-vscode-remote.sh
├── site/
│   └── index.html
├── bind-test/
│   └── index.html
├── practice/
└── docs/
    ├── environment.md
    ├── terminal-and-permissions.md
    ├── docker-operations.md
    ├── image-design.md
    ├── port-and-bind.md
    ├── volume-persistence.md
    ├── test-results.md
    ├── troubleshooting.md
    ├── logs/
    └── screenshots/
```

환경 로그 저장:

```bash
# [VS Code Ubuntu]
mkdir -p docs/logs

{
  echo '$ cat /etc/os-release'
  cat /etc/os-release
  echo '$ echo $SHELL'
  echo "$SHELL"
  echo '$ ps -p $$ -o comm='
  ps -p $$ -o comm=
  echo '$ pwd'
  pwd
  echo '$ git rev-parse --show-toplevel'
  git rev-parse --show-toplevel
  echo '$ git branch --show-current'
  git branch --show-current
  echo '$ docker --version'
  docker --version
  echo '$ git --version'
  git --version
  echo '$ git config --list'
  git config --list
} 2>&1 | tee docs/logs/environment.txt
```

공개하면 안 되는 이메일, 토큰, 내부 경로가 있는지 확인한 뒤 커밋합니다.

---

# 10. 터미널과 권한 실습

## 10.1 터미널 기본 조작

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
mv sample-copy.txt renamed.txt
mkdir archive
mv renamed.txt archive/
ls -la archive
rm archive/renamed.txt
rmdir archive
realpath sample.txt
```

설명할 수 있어야 하는 명령:

- `pwd`, `ls`, `ls -la`, `cd`
- `mkdir`, `touch`, `cat`
- `cp`, `mv`, `rm`, `rmdir`
- 절대 경로와 상대 경로

## 10.2 파일과 디렉터리 권한

```bash
cd ~/codyssey-training/codyssey-training-e1-1/practice

touch permission-file.txt
ls -l permission-file.txt
chmod 644 permission-file.txt
ls -l permission-file.txt
chmod 600 permission-file.txt
ls -l permission-file.txt

mkdir -p permission-dir
ls -ld permission-dir
chmod 755 permission-dir
ls -ld permission-dir
chmod 700 permission-dir
ls -ld permission-dir
```

- `755`: 소유자 `rwx`, 그룹 `r-x`, 기타 `r-x`
- `644`: 소유자 `rw-`, 그룹 `r--`, 기타 `r--`

명령과 출력 결과를 `docs/terminal-and-permissions.md`와 스크린샷으로 기록합니다.

---

# 11. Docker 기본 운영과 attach·exec

```bash
cd ~/codyssey-training/codyssey-training-e1-1

docker --version
docker version
docker info
docker images
docker ps
docker ps -a
docker stats --no-stream
```

## 11.1 hello-world와 Ubuntu 컨테이너

```bash
docker rm -f e1-1-hello 2>/dev/null || true
docker run --name e1-1-hello hello-world
docker logs e1-1-hello

docker rm -f e1-1-ubuntu 2>/dev/null || true
docker run -d \
  --name e1-1-ubuntu \
  ubuntu:24.04 \
  bash -lc 'echo "e1-1-ubuntu started"; sleep infinity'

docker exec e1-1-ubuntu \
  bash -lc 'pwd; ls -la; echo "Hello from docker exec"'
```

## 11.2 attach 실제 관찰

```bash
docker rm -f e1-1-attach 2>/dev/null || true
docker run -dit --name e1-1-attach ubuntu:24.04 bash
docker attach e1-1-attach
```

컨테이너 안에서:

```bash
echo "attached to the container main shell"
```

컨테이너를 종료하지 않고 빠져나오기:

```text
Ctrl + P
Ctrl + Q
```

```bash
docker ps
docker exec e1-1-attach \
  bash -lc 'echo "exec creates another process"'
docker rm -f e1-1-ubuntu e1-1-attach
```

- `attach`: 기존 기본 프로세스에 직접 연결
- `exec`: 실행 중인 컨테이너에서 별도 프로세스 생성

---

# 12. Dockerfile 웹 서버 제작

## 12.1 웹 소스

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

## 12.2 Dockerfile

```bash
cat > Dockerfile <<'EOF'
FROM nginx:alpine
LABEL org.opencontainers.image.title="codyssey-e1-1-web"
LABEL org.opencontainers.image.description="Codyssey E1-1 custom NGINX web server"
COPY site/ /usr/share/nginx/html/
EXPOSE 80
EOF
```

```bash
docker build -t codyssey-e1-1-web:1.0 . \
  2>&1 | tee docs/logs/docker-build.txt

docker images | grep codyssey-e1-1-web
```

`docs/image-design.md`에 다음을 작성합니다.

- `nginx:alpine` 선택 이유
- `LABEL`, `COPY`, `EXPOSE`의 목적
- 빌드·실행 명령과 결과

---

# 13. 포트 매핑 검증

사용 가능한 포트를 선택합니다.

```bash
unset HOST_PORT
for candidate in 8080 8081 18080 18081
do
  if ! mac lsof -nP -iTCP:"$candidate" -sTCP:LISTEN 2>/dev/null | grep -q LISTEN
  then
    HOST_PORT="$candidate"
    break
  fi
done

test -n "${HOST_PORT:-}" || { echo '[FAIL] 사용 가능한 포트 없음'; exit 1; }
printf 'HOST_PORT=%s\n' "$HOST_PORT" > .env.local
source .env.local
```

```bash
docker rm -f e1-1-web 2>/dev/null || true
docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0

docker ps
docker logs e1-1-web
docker port e1-1-web
mac curl "http://localhost:${HOST_PORT}"
```

Mac 브라우저:

```text
http://localhost:선택한포트
```

주소창, 포트, 응답 화면을 함께 캡처합니다.

---

# 14. 바인드 마운트 검증

```bash
source .env.local
docker rm -f e1-1-web e1-1-bind 2>/dev/null || true
mkdir -p bind-test

cat > bind-test/index.html <<'EOF'
<!doctype html>
<html lang="ko">
<head><meta charset="utf-8"><title>Bind Mount</title></head>
<body><h1>바인드 마운트 최초 화면</h1></body>
</html>
EOF

docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:${HOST_PORT}:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine

mac curl "http://localhost:${HOST_PORT}"
```

파일을 변경합니다.

```bash
cat > bind-test/index.html <<'EOF'
<!doctype html>
<html lang="ko">
<head><meta charset="utf-8"><title>Bind Mount</title></head>
<body><h1>바인드 마운트 변경 반영 성공</h1></body>
</html>
EOF

mac curl "http://localhost:${HOST_PORT}"
```

컨테이너를 재실행하지 않아도 변경 내용이 보여야 합니다.

---

# 15. Docker 볼륨 영속성 검증

```bash
docker volume create e1-1-data

docker rm -f e1-1-volume-1 2>/dev/null || true
docker run -d \
  --name e1-1-volume-1 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-1 \
  bash -lc 'echo "persistent data" > /data/result.txt && cat /data/result.txt'

docker rm -f e1-1-volume-1

docker rm -f e1-1-volume-2 2>/dev/null || true
docker run -d \
  --name e1-1-volume-2 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-2 cat /data/result.txt
```

마지막에 `persistent data`가 출력되어야 합니다.

---

# 16. 증거와 트러블슈팅 기록

필수 증거:

| 구분 | 증거 |
|---|---|
| VS Code 원격 | SSH 표시, Ubuntu 버전, bash, workspace 경로 |
| Git | config, branch, remote, push |
| 터미널 | 입력 명령과 출력 결과 |
| 권한 | 파일·디렉터리 변경 전후 |
| Docker | version, info, images, ps, logs, stats |
| Dockerfile | 빌드 로그, 베이스 이미지와 커스텀 목적 |
| 포트 | 주소창과 응답 또는 `mac curl` |
| 마운트 | 파일 변경 전후 |
| 볼륨 | 컨테이너 삭제 전후 데이터 |

트러블슈팅 형식:

```markdown
## TS-01

- 문제:
- 발생 환경:
- 실행 위치:
- 실행 명령:
- 오류 메시지 원문:
- 원인 가설:
- 확인 과정:
- 실제 원인:
- 해결 방법 또는 대안:
- 해결 확인:
- 재발 방지:
```

보안 점검:

```bash
git status -sb
git diff
git diff --cached
git grep -n -i -E 'token|password|secret|private.?key' || true
```

실제 토큰, 비밀번호, 개인키, `.env.local`, `hosts.yml`은 커밋하지 않습니다.

---

# 17. Git 커밋과 push

```text
수정 → git status -sb → git diff → git add → git diff --cached → commit → push
```

환경과 VS Code 설정:

```bash
git add \
  README.md \
  .vscode/settings.json \
  .vscode/extensions.json \
  .vscode/tasks.json \
  scripts/open-vscode-remote.sh \
  docs/environment.md \
  docs/logs/environment.txt

git diff --cached
git commit -m "Feat: configure OrbStack Remote-SSH workspace"
```

터미널·권한·Docker 산출물은 기능 단위로 나누어 커밋합니다.

첫 push:

```bash
git push -u origin feat/e1-1-workstation
```

이후:

```bash
git push
```

---

# 18. Clean clone과 main 최종 검증

## 18.1 clean clone

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git status -sb
git push

CURRENT_BRANCH="$(git branch --show-current)"
RETEST_DIR="$HOME/codyssey-retest/e1-1-$(date +%Y%m%d-%H%M%S)"

gh repo clone gahyun1004/codyssey-training-e1-1 \
  "$RETEST_DIR" \
  -- \
  --branch "$CURRENT_BRANCH" \
  --single-branch

cd "$RETEST_DIR"
docker build -t codyssey-e1-1-web:retest .
```

새 clone에서도 `.vscode` 파일, Dockerfile, 웹 소스, 문서 링크가 존재해야 합니다.

## 18.2 Pull Request와 병합

```bash
gh pr list \
  --head feat/e1-1-workstation \
  --base main \
  --state open
```

기존 PR이 없을 때:

```bash
gh pr create \
  --base main \
  --head feat/e1-1-workstation \
  --title "Feat: complete E1-1 workstation mission" \
  --body "OrbStack Remote-SSH, Ubuntu bash workspace terminal, Docker, Git/GitHub 및 재현성 검증을 완료했습니다."
```

검증 후:

```bash
gh pr merge --merge --delete-branch
```

## 18.3 main 최종 확인

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git switch main
git pull --ff-only origin main
git status -sb
git log --oneline --graph --decorate -20
```

Mac에서 다시 실행합니다.

```bash
bash scripts/open-vscode-remote.sh
```

VS Code 새 터미널에서:

```bash
cat /etc/os-release
ps -p $$ -o comm=
pwd
git branch --show-current
```

최종 기준:

- Ubuntu 24.04
- bash
- 현재 저장소 경로
- `main`

---

# 19. 대표 오류 해결표

| 증상 | 확인 | 조치 |
|---|---|---|
| `ssh ...@orb` 실패 | `orb status`, `orb info` | OrbStack과 머신 실행 확인 |
| Mac에서 `code` 없음 | `command -v code` | 앱 내부 CLI 사용 또는 PATH 명령 설치 |
| `--remote`가 없음 | `code --version`, `code --help` | 올바른 VS Code CLI 선택 |
| VS Code가 로컬 폴더를 엶 | 왼쪽 아래 상태, `pwd` | `code --remote ... <Ubuntu 절대경로>` 재실행 |
| 일반 SSH에서 `code .` 실패 | `command -v code` | Mac의 `code --remote`를 기본 방식으로 사용 |
| 터미널이 `/Users/...` | `pwd` | Remote-SSH 창으로 다시 열기 |
| 터미널이 home에서 시작 | `pwd` | 저장소 폴더를 열고 새 터미널 생성 |
| 셸이 bash가 아님 | `ps -p $$ -o comm=` | Workspace Trust 후 `.vscode/settings.json` 확인 |
| `.vscode` 설정 미적용 | Trust 상태 | 저장소를 신뢰하고 기존 터미널을 닫은 뒤 재생성 |
| Docker Server 없음 | `docker version`, `docker info` | OrbStack Docker 연결 확인 |
| 포트 충돌 | `mac lsof`, `docker ps` | 다른 포트 선택 |
| 바인드 변경 미반영 | `pwd`, `docker inspect` | 저장소 루트와 마운트 경로 확인 |
| 볼륨 데이터 없음 | `docker volume ls` | 동일한 볼륨 이름 사용 확인 |
| push 거절 | `git fetch`, `git status` | 강제 push 금지, 원격 변경 확인 |

---

# 20. 평가 전 최종 체크리스트

## OrbStack·VS Code

- [ ] Ubuntu 24.04 머신을 생성·확인했다.
- [ ] `ssh codyssey-training@orb` 접속에 성공했다.
- [ ] Mac에서 `Command(⌘) + Space`로 Spotlight를 열고 Terminal을 실행했다.
- [ ] Mac에서 `code --remote`로 Ubuntu 저장소 절대 경로를 열었다.
- [ ] VS Code 왼쪽 아래에 SSH 원격 호스트가 표시된다.
- [ ] `.vscode/settings.json`이 저장소에 있다.
- [ ] 새 터미널이 Ubuntu bash로 열린다.
- [ ] 새 터미널의 `pwd`가 `${workspaceFolder}`이다.
- [ ] 검증 Task를 실행했다.

## 터미널·권한

- [ ] `pwd`, `ls -la`, `cd`, `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat` 수행
- [ ] 절대 경로와 상대 경로 설명 가능
- [ ] 파일·디렉터리 권한 변경 전후 기록
- [ ] `755`, `644` 설명 가능

## Docker

- [ ] `docker --version`, `docker info`, `hello-world` 성공
- [ ] `docker images`, `ps -a`, `logs`, `stats` 기록
- [ ] Ubuntu 컨테이너 내부 명령 실행
- [ ] `attach`와 `exec` 실제 관찰
- [ ] Dockerfile 직접 작성
- [ ] 베이스 이미지와 커스텀 목적 기록
- [ ] 포트 매핑 접속 성공
- [ ] 바인드 마운트 변경 전후 확인
- [ ] 볼륨 영속성 확인

## Git·문서·보안

- [ ] `git config --list` 결과 기록
- [ ] GitHub CLI와 VS Code 로그인 증거
- [ ] 기능 단위 커밋과 push
- [ ] README에서 모든 증거 문서 접근 가능
- [ ] 트러블슈팅 2건 이상
- [ ] clean clone 성공
- [ ] 작업 브랜치를 `main`에 병합
- [ ] `main`에서 Remote-SSH 터미널과 Docker 최종 검증
- [ ] 토큰·비밀번호·개인키·인증 코드 없음

---

## 완료 문장 예시

> macOS의 OrbStack Ubuntu 24.04에 SSH로 접속하고, Mac의 VS Code CLI에서 `code --remote`를 사용해 Ubuntu 저장소를 열었다. 프로젝트의 `.vscode` 설정을 통해 새 통합 터미널이 Ubuntu bash와 현재 workspace 폴더에서 시작되도록 구성했다. 터미널·권한·Docker·Git/GitHub 실습, 포트 매핑, 바인드 마운트, 볼륨 영속성, clean clone 및 `main` 최종 검증을 완료했다.
