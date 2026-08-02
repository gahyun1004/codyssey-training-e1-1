# E1-1 초보자 수행 가이드

> **미션:** 내 컴퓨터에 개발자용 ‘작업실’ 꾸미기  
> **권장 환경:** macOS + OrbStack + Ubuntu 24.04 LTS + OrbStack Docker  
> **대상 저장소:** `gahyun1004/codyssey-training-e1-1`  
> **작업 브랜치:** `feat/e1-1-workstation`

[미션 요구사항 README로 돌아가기](README.md)

이 문서는 입문자가 위에서부터 한 단계씩 실행하면서 E1-1 미션을 완료하도록 구성한 실습 가이드입니다. 각 단계는 **실행 위치 → 명령 → 정상 기준 → 오류 대응 → 증거 기록** 순서로 진행합니다.

> 컴퓨터마다 설치 상태가 다르므로 오류가 전혀 없다고 단정할 수는 없습니다. 오류가 발생하면 다음 단계로 넘어가지 말고, 오류 메시지 원문과 해결 과정을 `docs/troubleshooting.md`에 기록합니다.

---

## 목차

1. [문서 사용 규칙](#1-문서-사용-규칙)
2. [완료 기준](#2-완료-기준)
3. [전체 수행 순서](#3-전체-수행-순서)
4. [OrbStack과 Ubuntu 준비](#4-orbstack과-ubuntu-준비)
5. [Ubuntu 기본 환경 준비](#5-ubuntu-기본-환경-준비)
6. [Docker 연결과 경로 사전 시험](#6-docker-연결과-경로-사전-시험)
7. [GitHub CLI 설치와 로그인](#7-github-cli-설치와-로그인)
8. [저장소 clone과 작업 브랜치](#8-저장소-clone과-작업-브랜치)
9. [VS Code Remote-SSH와 GitHub 로그인](#9-vs-code-remote-ssh와-github-로그인)
10. [저장소 기본 구조 만들기](#10-저장소-기본-구조-만들기)
11. [Git 설정과 실행 환경 기록](#11-git-설정과-실행-환경-기록)
12. [터미널 기본 조작 실습](#12-터미널-기본-조작-실습)
13. [파일과 디렉터리 권한 실습](#13-파일과-디렉터리-권한-실습)
14. [Docker 기본 운영과 attach·exec 실습](#14-docker-기본-운영과-attachexec-실습)
15. [Dockerfile 웹 서버 제작](#15-dockerfile-웹-서버-제작)
16. [안전한 포트 선택](#16-안전한-포트-선택)
17. [포트 매핑 검증](#17-포트-매핑-검증)
18. [바인드 마운트 검증](#18-바인드-마운트-검증)
19. [Docker 볼륨 영속성 검증](#19-docker-볼륨-영속성-검증)
20. [증거·로그·스크린샷 기록](#20-증거로그스크린샷-기록)
21. [Git 커밋과 push](#21-git-커밋과-push)
22. [Clean clone 재현성 검증](#22-clean-clone-재현성-검증)
23. [Pull Request와 main 병합](#23-pull-request와-main-병합)
24. [병합 후 최종 검증](#24-병합-후-최종-검증)
25. [대표 오류 해결표](#25-대표-오류-해결표)
26. [평가 전 최종 체크리스트](#26-평가-전-최종-체크리스트)

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
8. Ubuntu 셸에서 Mac에 게시된 Docker 포트를 확인할 때는 `mac curl http://localhost:포트`를 사용합니다.
9. Mac 브라우저에서는 `http://localhost:포트`로 접속합니다.

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
- Docker 경로 사전 시험 실패
- `gh auth status` 실패
- GitHub 권한이 `READ`
- 현재 브랜치가 `main`인데 파일이 수정됨
- VS Code 터미널 경로가 `/Users/...`로 표시됨
- `git diff --cached`에 의도하지 않은 파일 존재
- clean clone에서 Docker 빌드 또는 HTTP 확인 실패

---

# 2. 완료 기준

평가자는 기본 브랜치인 `main`에서 다음 결과를 확인할 수 있어야 합니다.

- [ ] OrbStack Ubuntu 24.04 환경을 사용했다.
- [ ] Docker Client와 Server가 정상 연결된다.
- [ ] `hello-world` 실행에 성공했다.
- [ ] Docker가 Ubuntu 경로의 build context와 bind mount를 정상 처리한다.
- [ ] 터미널 기본 명령 수행 결과가 있다.
- [ ] 파일과 디렉터리 권한 변경 전후가 있다.
- [ ] Docker 이미지와 컨테이너 운영 결과가 있다.
- [ ] `attach`와 `exec`를 실제로 관찰하고 차이를 정리했다.
- [ ] 직접 작성한 `Dockerfile`이 있다.
- [ ] 베이스 이미지 선택 이유와 커스텀 포인트를 기록했다.
- [ ] 포트 매핑 후 브라우저 또는 `curl` 접속에 성공했다.
- [ ] 바인드 마운트 변경 전후가 확인된다.
- [ ] 컨테이너 삭제 후에도 볼륨 데이터가 유지된다.
- [ ] `git config --list` 결과를 확인했다.
- [ ] GitHub CLI와 VS Code에서 GitHub 로그인을 확인했다.
- [ ] 트러블슈팅을 최소 2건 기록했다.
- [ ] clean clone에서 다시 빌드하고 실행했다.
- [ ] README에서 수행 가이드와 증거 문서에 접근할 수 있다.
- [ ] 민감정보가 저장소에 없다.

---

# 3. 전체 수행 순서

```text
1. OrbStack 실행 확인
2. Ubuntu 24.04 머신 생성 또는 확인
3. Ubuntu 기본 패키지 설치
4. Docker 연결과 hello-world 확인
5. Docker build·bind mount 경로 사전 시험
6. GitHub CLI 설치와 로그인
7. 저장소 clone
8. local·remote branch를 확인하고 작업 브랜치 선택
9. VS Code Remote-SSH 연결
10. VS Code GitHub 로그인과 Source Control 확인
11. 문서·로그·스크린샷 구조 생성
12. Git 설정과 실행 환경 기록
13. 터미널과 권한 실습
14. Docker 기본 운영과 attach·exec 관찰
15. Dockerfile 웹 서버 제작
16. 안전한 포트 선택
17. 포트 매핑 검증
18. 바인드 마운트 검증
19. Docker 볼륨 영속성 검증
20. 증거와 트러블슈팅 정리
21. 기능 단위 commit과 push
22. clean clone 검증
23. Pull Request 생성과 main 병합
24. main에서 최종 검증
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
  tar \
  unzip \
  zip
```

설치 확인:

```bash
git --version
curl --version | head -n 1
tar --version | head -n 1
jq --version
```

`sudo`가 정책상 제한되어 있으면 임의로 우회하지 말고 퍼실리테이터에게 설치 가능 여부를 확인합니다.

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

# 6. Docker 연결과 경로 사전 시험

## 6.1 Docker 명령 확인

```bash
# [Ubuntu]
command -v docker || true
docker context show || true
```

Docker 명령이 없으면 먼저 Mac에서 OrbStack 상태를 확인합니다.

```bash
# [Ubuntu]
mac orb status || true
```

그래도 명령이 없을 때만 실행합니다.

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

## 6.5 Docker 경로 사전 시험

Docker가 Ubuntu 홈 경로의 build context와 bind mount를 정상 처리하는지 확인합니다.

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

두 실행에서 모두 다음 문자열이 출력되어야 합니다.

```text
OrbStack path test
```

실패하면 E1-1 저장소의 Dockerfile·바인드 마운트 실습으로 넘어가지 않습니다.

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
ls -ld codyssey-training-e1-1 2>/dev/null || true
```

폴더가 없을 때만 clone합니다.

```bash
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

작업 내용이 남아 있으면 먼저 보존하고 정리합니다. `git reset --hard`로 지우지 않습니다.

## 8.3 Git 사용자 정보와 기본 브랜치

```bash
git config --global user.name || true
git config --global user.email || true
```

값이 없을 때만 본인 정보로 설정합니다.

```bash
git config --global user.name "본인의 Git 이름"
git config --global user.email "본인의 GitHub 이메일"
```

기본 브랜치는 사용자 정보 존재 여부와 관계없이 설정합니다.

```bash
git config --global init.defaultBranch main
git config --list
```

스크린샷에 이메일이 보이면 필요한 부분을 마스킹합니다.

## 8.4 local·remote branch를 확인하고 전환

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
```

확인:

```bash
pwd
git branch --show-current
git status -sb
git branch -vv
git remote -v
```

정상 브랜치:

```text
feat/e1-1-workstation
```

---

# 9. VS Code Remote-SSH와 GitHub 로그인

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

## 9.3 VS Code Remote-SSH 연결

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

## 9.5 VS Code에서 GitHub 로그인과 연동 확인

VS Code 왼쪽 아래의 계정 아이콘을 선택합니다.

```text
Accounts
→ Sign in with GitHub
→ 브라우저 인증
→ 승인 후 VS Code로 복귀
```

Source Control 화면에서 다음을 확인합니다.

- 현재 저장소가 `codyssey-training-e1-1`이다.
- 현재 브랜치가 `feat/e1-1-workstation`이다.
- 변경 파일 목록을 확인할 수 있다.
- GitHub 계정 로그인 상태가 표시된다.

권장 캡처:

```text
docs/screenshots/github/01-vscode-github-login.png
docs/screenshots/github/02-source-control-repository.png
docs/screenshots/vscode/01-remote-ssh-path-branch.png
```

---

# 10. 저장소 기본 구조 만들기

아래 명령은 VS Code Ubuntu 터미널에서 실행합니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1

mkdir -p site bind-test practice docs/logs
mkdir -p docs/screenshots/{environment,terminal,permissions,docker,port-mapping,bind-mount,volume,github,vscode}
```

빈 스크린샷 폴더도 Git에서 보이도록 `.gitkeep`을 만듭니다.

```bash
for directory in docs/screenshots/{environment,terminal,permissions,docker,port-mapping,bind-mount,volume,github,vscode}
do
  touch "$directory/.gitkeep"
done
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

문서 뼈대를 만듭니다.

```bash
for file in \
  docs/environment.md \
  docs/terminal-and-permissions.md \
  docs/docker-operations.md \
  docs/image-design.md \
  docs/port-and-bind.md \
  docs/volume-persistence.md \
  docs/test-results.md \
  docs/troubleshooting.md
do
  if test ! -e "$file"
  then
    printf '# %s\n\n' "$(basename "$file" .md)" > "$file"
  fi
done
```

README의 상단 또는 목차 아래에 다음 링크 영역이 있는지 확인합니다. 없다면 추가합니다.

```markdown
## 수행 문서

- [초보자 수행 가이드](E1-1-training.md)
- [실행 환경](docs/environment.md)
- [터미널 및 권한 실습](docs/terminal-and-permissions.md)
- [Docker 운영](docs/docker-operations.md)
- [커스텀 이미지 설계](docs/image-design.md)
- [포트 매핑 및 바인드 마운트](docs/port-and-bind.md)
- [볼륨 영속성](docs/volume-persistence.md)
- [최종 검증 결과](docs/test-results.md)
- [트러블슈팅](docs/troubleshooting.md)
```

---

# 11. Git 설정과 실행 환경 기록

## 11.1 환경 로그 저장

명령과 출력 결과를 함께 저장합니다. 증거 파일은 `.log` 대신 Git에 포함되는 `.txt`를 사용합니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1

{
  echo '$ cat /etc/os-release'
  cat /etc/os-release
  echo
  echo '$ uname -a'
  uname -a
  echo
  echo '$ echo $SHELL'
  echo "$SHELL"
  echo
  echo '$ git --version'
  git --version
  echo
  echo '$ gh --version'
  gh --version | head -n 1
  echo
  echo '$ docker --version'
  docker --version
  echo
  echo '$ git config --list'
  git config --list
} 2>&1 | tee docs/logs/environment.txt
```

`docs/logs/environment.txt`에 이메일 또는 로컬 경로 등 공개하고 싶지 않은 정보가 있는지 확인합니다. 필요한 값은 마스킹한 뒤 커밋합니다.

## 11.2 환경 문서 작성 항목

`docs/environment.md`에 다음을 작성합니다.

```markdown
# 실행 환경

- OS:
- Shell:
- Terminal:
- OrbStack:
- Ubuntu:
- Docker:
- Git:
- GitHub CLI:
- VS Code:
- Remote-SSH host: codyssey-training@orb
- 작업 브랜치: feat/e1-1-workstation

## Git 설정 확인

- user.name: 확인 완료
- user.email: 확인 완료 또는 마스킹
- init.defaultBranch: main
- remote.origin.url: 확인 완료

## 원본 로그

- [환경 로그](logs/environment.txt)
```

---

# 12. 터미널 기본 조작 실습

## 12.1 실습과 로그 저장

```bash
cd ~/codyssey-training/codyssey-training-e1-1
mkdir -p practice/terminal
cd practice/terminal

{
  echo '$ pwd'
  pwd
  echo '$ ls'
  ls
  echo '$ ls -la'
  ls -la

  echo '$ touch sample.txt'
  touch sample.txt
  echo '$ echo "Codyssey E1-1" > sample.txt'
  echo "Codyssey E1-1" > sample.txt
  echo '$ cat sample.txt'
  cat sample.txt

  echo '$ cp sample.txt sample-copy.txt'
  cp sample.txt sample-copy.txt
  echo '$ mv sample-copy.txt renamed.txt'
  mv sample-copy.txt renamed.txt

  echo '$ mkdir archive'
  mkdir -p archive
  echo '$ mv renamed.txt archive/'
  mv renamed.txt archive/
  echo '$ ls -la archive'
  ls -la archive

  echo '$ rm archive/renamed.txt'
  rm archive/renamed.txt
  echo '$ rmdir archive'
  rmdir archive
  echo '$ realpath sample.txt'
  realpath sample.txt
} 2>&1 | tee ../../docs/logs/terminal-basic.txt
```

## 12.2 명령 의미

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

- `/`로 시작하는 경로: 절대 경로
- 현재 위치를 기준으로 작성한 경로: 상대 경로

`docs/terminal-and-permissions.md`에 명령 의미, 절대·상대 경로 설명, 로그 링크를 작성합니다.

권장 캡처:

```text
docs/screenshots/terminal/01-basic-commands.png
```

---

# 13. 파일과 디렉터리 권한 실습

## 13.1 권한 변경 전후 로그

```bash
cd ~/codyssey-training/codyssey-training-e1-1/practice

{
  echo '$ touch permission-file.txt'
  touch permission-file.txt
  echo '$ ls -l permission-file.txt'
  ls -l permission-file.txt
  echo '$ chmod 644 permission-file.txt'
  chmod 644 permission-file.txt
  ls -l permission-file.txt
  echo '$ chmod 600 permission-file.txt'
  chmod 600 permission-file.txt
  ls -l permission-file.txt

  echo '$ mkdir -p permission-dir'
  mkdir -p permission-dir
  echo '$ ls -ld permission-dir'
  ls -ld permission-dir
  echo '$ chmod 755 permission-dir'
  chmod 755 permission-dir
  ls -ld permission-dir
  echo '$ chmod 700 permission-dir'
  chmod 700 permission-dir
  ls -ld permission-dir
} 2>&1 | tee ../docs/logs/permissions.txt
```

## 13.2 숫자 권한

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

Git은 일반 파일의 `644`와 `600` 차이를 변경사항으로 표시하지 않을 수 있습니다. `ls -l` 결과, 로그, 스크린샷으로 증명합니다.

```text
docs/screenshots/permissions/01-file-permission.png
docs/screenshots/permissions/02-directory-permission.png
```

---

# 14. Docker 기본 운영과 attach·exec 실습

저장소 루트로 이동합니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
```

## 14.1 상태와 목록 로그

```bash
{
  echo '$ docker --version'
  docker --version
  echo '$ docker version'
  docker version
  echo '$ docker info'
  docker info
  echo '$ docker images'
  docker images
  echo '$ docker ps'
  docker ps
  echo '$ docker ps -a'
  docker ps -a
  echo '$ docker stats --no-stream'
  docker stats --no-stream
} 2>&1 | tee docs/logs/docker-basic.txt
```

## 14.2 hello-world 컨테이너

```bash
docker rm -f e1-1-hello 2>/dev/null || true
docker run --name e1-1-hello hello-world
docker ps -a
docker logs e1-1-hello 2>&1 | tee docs/logs/hello-world.txt
```

## 14.3 Ubuntu 컨테이너와 exec

```bash
docker rm -f e1-1-ubuntu 2>/dev/null || true

docker run -d \
  --name e1-1-ubuntu \
  ubuntu:24.04 \
  bash -lc 'echo "e1-1-ubuntu started"; sleep infinity'

docker ps
docker logs e1-1-ubuntu

docker exec e1-1-ubuntu \
  bash -lc 'pwd; ls -la; echo "Hello from docker exec"'
```

`exec`는 실행 중인 컨테이너 내부에서 새로운 명령 프로세스를 실행합니다.

## 14.4 attach 실제 관찰

```bash
docker rm -f e1-1-attach 2>/dev/null || true

docker run -dit \
  --name e1-1-attach \
  ubuntu:24.04 \
  bash

docker attach e1-1-attach
```

컨테이너 안에서 실행합니다.

```bash
# [컨테이너]
echo "attached to the container main shell"
```

컨테이너를 종료하지 않고 빠져나오려면 다음 키를 순서대로 누릅니다.

```text
Ctrl + P
Ctrl + Q
```

Ubuntu 셸로 돌아온 후 확인합니다.

```bash
docker ps
docker exec e1-1-attach \
  bash -lc 'echo "exec creates another process"'
```

정리:

```bash
docker rm -f e1-1-ubuntu e1-1-attach
```

`docs/docker-operations.md`에 다음을 정리합니다.

- `attach`: 컨테이너의 기존 기본 프로세스에 직접 연결한다.
- `exec`: 실행 중인 컨테이너에서 별도 프로세스를 생성한다.
- `attach` 상태에서 `exit`를 실행하면 기본 프로세스가 끝나 컨테이너가 중지될 수 있다.

---

# 15. Dockerfile 웹 서버 제작

## 15.1 HTML 작성

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

## 15.3 .dockerignore

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

## 15.4 설계 문서 작성

`docs/image-design.md`에 다음 내용을 본인의 표현으로 작성합니다.

```markdown
# 커스텀 이미지 설계

## 베이스 이미지

`nginx:alpine`을 선택했다. 웹 서버가 이미 구성되어 있어 별도 패키지 설치 없이 정적 페이지를 서비스할 수 있고, Alpine 기반으로 이미지 크기가 비교적 작기 때문이다.

## 커스텀 포인트

1. `LABEL`: 이미지의 목적과 프로젝트 정보를 기록했다.
2. `COPY site/`: 직접 만든 HTML을 NGINX 기본 문서 경로에 배치했다.
3. `EXPOSE 80`: 웹 서버가 사용하는 컨테이너 포트를 문서화했다.
```

## 15.5 빌드와 로그 저장

```bash
docker build -t codyssey-e1-1-web:1.0 . \
  2>&1 | tee docs/logs/docker-build.txt

docker images | grep codyssey-e1-1-web
docker image inspect codyssey-e1-1-web:1.0
```

정상 기준: 빌드가 오류 없이 완료되고 이미지가 목록에 표시됩니다.

---

# 16. 안전한 포트 선택

고정 포트 충돌을 방지하기 위해 한 번 선택한 포트를 `.env.local`에 저장합니다. `.env.local`은 커밋하지 않습니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
unset HOST_PORT

for candidate in 8080 8081 18080 18081
do
  if ! mac lsof -nP -iTCP:"$candidate" -sTCP:LISTEN 2>/dev/null | grep -q LISTEN
  then
    HOST_PORT="$candidate"
    break
  fi
done

if test -z "${HOST_PORT:-}"
then
  echo "[FAIL] 사용할 수 있는 포트를 찾지 못했습니다."
  exit 1
fi

printf 'HOST_PORT=%s\n' "$HOST_PORT" > .env.local
source .env.local
echo "선택 포트: $HOST_PORT"
```

새 터미널을 열면 다시 실행합니다.

```bash
cd ~/codyssey-training/codyssey-training-e1-1
source .env.local
```

---

# 17. 포트 매핑 검증

```bash
source .env.local
docker rm -f e1-1-web 2>/dev/null || true

docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0
```

Ubuntu 또는 VS Code Ubuntu 셸에서 Mac의 게시 포트를 확인합니다.

```bash
docker ps
docker logs e1-1-web
docker port e1-1-web
mac curl "http://localhost:${HOST_PORT}" \
  2>&1 | tee docs/logs/port-mapping.txt
```

정상 기준:

- `e1-1-web`이 실행 중이다.
- 선택 포트가 컨테이너의 `80`에 연결된다.
- HTML 응답이 출력된다.

Mac 브라우저에서 접속합니다.

```text
http://localhost:선택한포트
```

주소창과 웹 페이지가 함께 보이도록 캡처합니다.

```text
docs/screenshots/port-mapping/01-browser-response.png
```

> Ubuntu 셸에서 `curl http://localhost:포트`를 실행하지 않습니다. 이 가이드에서는 Ubuntu에서 Mac 명령을 실행하는 `mac curl`로 확인합니다.

---

# 18. 바인드 마운트 검증

기존 웹 컨테이너를 제거하고 같은 선택 포트를 재사용합니다.

```bash
source .env.local
docker rm -f e1-1-web e1-1-bind 2>/dev/null || true
```

## 18.1 최초 파일

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

## 18.2 컨테이너 실행과 최초 확인

```bash
docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:${HOST_PORT}:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine

mac curl "http://localhost:${HOST_PORT}"
```

`바인드 마운트 최초 화면`이 출력되어야 합니다.

## 18.3 파일 변경과 재확인

```bash
cat > bind-test/index.html <<'EOF'
<!doctype html>
<html lang="ko">
<head><meta charset="utf-8"><title>Bind Mount</title></head>
<body><h1>바인드 마운트 변경 반영 성공</h1></body>
</html>
EOF

mac curl "http://localhost:${HOST_PORT}" \
  2>&1 | tee docs/logs/bind-mount-after.txt
```

컨테이너를 재실행하지 않았는데 `변경 반영 성공`이 출력되어야 합니다.

```text
docs/screenshots/bind-mount/01-before.png
docs/screenshots/bind-mount/02-after.png
```

`docs/port-and-bind.md`에 실행 명령, 최초 응답, 변경 후 응답, 바인드 마운트의 의미를 정리합니다.

---

# 19. Docker 볼륨 영속성 검증

## 19.1 볼륨 생성

```bash
docker volume create e1-1-data
docker volume ls | grep e1-1-data
```

## 19.2 첫 번째 컨테이너

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

## 19.3 첫 번째 컨테이너 삭제

```bash
docker rm -f e1-1-volume-1
```

## 19.4 두 번째 컨테이너

```bash
docker rm -f e1-1-volume-2 2>/dev/null || true

docker run -d \
  --name e1-1-volume-2 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-2 cat /data/result.txt \
  2>&1 | tee docs/logs/volume-persistence.txt
```

다시 `persistent data`가 출력되면 데이터 영속성 검증에 성공한 것입니다.

```text
docs/screenshots/volume/01-volume-persistence.png
```

`docs/volume-persistence.md`에 다음을 정리합니다.

- 볼륨 이름
- 첫 번째 컨테이너에서 저장한 데이터
- 컨테이너 삭제 명령
- 두 번째 컨테이너에서 데이터를 다시 읽은 결과
- 컨테이너와 볼륨 수명 주기의 차이

---

# 20. 증거·로그·스크린샷 기록

## 20.1 필수 증거

| 구분 | 증거 |
|---|---|
| 환경 | OS, Shell, Docker, Git, GitHub CLI 버전 |
| Git | `git config --list`, branch, remote, push |
| 터미널 | 입력 명령과 출력 결과 |
| 권한 | 파일·디렉터리 변경 전후 |
| Docker | version, info, images, ps, logs, stats |
| 컨테이너 접속 | attach와 exec 관찰 결과 |
| Dockerfile | 빌드 성공 로그, 베이스 이미지 선택 이유, 커스텀 포인트 |
| 포트 | 브라우저 주소창과 응답 또는 `mac curl` |
| 바인드 마운트 | 변경 전후 |
| 볼륨 | 컨테이너 삭제 전후 데이터 |
| GitHub | GitHub CLI 인증, VS Code 로그인, Source Control |
| VS Code | Remote-SSH, Ubuntu 경로, 작업 브랜치 |

## 20.2 Mac 스크린샷을 Ubuntu 저장소에 넣기

Finder에서 OrbStack 머신 파일을 열어 다음 경로로 이미지를 복사합니다.

```text
OrbStack
→ codyssey-training
→ home
→ 사용자이름
→ codyssey-training
→ codyssey-training-e1-1
→ docs
→ screenshots
```

이미지를 넣은 후 Ubuntu에서 확인합니다.

```bash
find docs/screenshots -maxdepth 2 -type f | sort
```

## 20.3 트러블슈팅 최소 2건

`docs/troubleshooting.md`에는 실제 문제 해결 사례를 다음 형식으로 기록합니다.

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

권장 사례:

- 사용하려는 포트가 이미 사용 중이어서 다른 포트를 선택한 과정
- Docker Client는 보이지만 Server 연결이 실패해 OrbStack 상태를 점검한 과정
- local에는 없고 remote에만 있는 작업 브랜치를 tracking branch로 연결한 과정
- 잘못된 VS Code 폴더를 열어 `/Users/...`가 표시된 문제를 Remote-SSH로 수정한 과정

실제 오류가 없으면 억지로 시스템을 고장 내지 말고, 실제로 수행한 진단·예방 점검을 문제 해결 형식으로 기록합니다.

## 20.4 보안 점검

```bash
git status -sb
git diff
git diff --cached

git grep -n -i -E 'token|password|secret|private.?key' || true
find . -maxdepth 5 -type f \
  \( -name '.env' -o -name '.env.local' -o -name '*.pem' -o -name 'id_rsa' -o -name 'id_ed25519' -o -name 'hosts.yml' \)
```

검색 결과가 있다는 사실만으로 민감정보 노출을 의미하지는 않습니다. 해당 줄이 설명 문구인지 실제 토큰·비밀번호 값인지 직접 확인합니다.

커밋 금지:

- GitHub 토큰과 인증 코드
- 비밀번호와 개인키
- `~/.config/gh/hosts.yml`
- `~/.ssh` 전체
- `.env`, `.env.local`
- 학교 내부 민감정보

---

# 21. Git 커밋과 push

모든 작업 단위에서 다음을 반복합니다.

```text
수정 → git status -sb → git diff → 필요한 파일만 git add → git diff --cached → commit → push
```

## 21.1 기본 구조와 환경

```bash
cd ~/codyssey-training/codyssey-training-e1-1

git add \
  README.md \
  E1-1-training.md \
  .gitignore \
  docs/environment.md \
  docs/logs/environment.txt \
  docs/screenshots

git diff --cached --stat
git diff --cached
git commit -m "Docs: record E1-1 environment and evidence structure"
```

## 21.2 터미널과 권한

```bash
git add \
  practice \
  docs/terminal-and-permissions.md \
  docs/logs/terminal-basic.txt \
  docs/logs/permissions.txt \
  docs/screenshots/terminal \
  docs/screenshots/permissions

git diff --cached
git commit -m "Docs: record terminal and permission practice"
```

## 21.3 Docker 기본 운영

```bash
git add \
  docs/docker-operations.md \
  docs/logs/docker-basic.txt \
  docs/logs/hello-world.txt \
  docs/screenshots/docker

git diff --cached
git commit -m "Docs: record Docker image and container operations"
```

## 21.4 Dockerfile·포트·마운트·볼륨

```bash
git add \
  Dockerfile \
  .dockerignore \
  site/index.html \
  bind-test/index.html \
  docs/image-design.md \
  docs/port-and-bind.md \
  docs/volume-persistence.md \
  docs/logs/docker-build.txt \
  docs/logs/port-mapping.txt \
  docs/logs/bind-mount-after.txt \
  docs/logs/volume-persistence.txt \
  docs/screenshots/port-mapping \
  docs/screenshots/bind-mount \
  docs/screenshots/volume

git diff --cached
git commit -m "Feat: verify Dockerfile ports mounts and volume persistence"
```

## 21.5 트러블슈팅과 최종 문서

```bash
git add \
  README.md \
  docs/troubleshooting.md \
  docs/test-results.md \
  docs/screenshots/github \
  docs/screenshots/vscode

git diff --cached
git commit -m "Docs: add troubleshooting and final verification evidence"
```

## 21.6 push

첫 push:

```bash
git push -u origin feat/e1-1-workstation
```

그다음부터:

```bash
git push
```

커밋할 변경이 없다는 메시지가 나오면 오류가 아닙니다. 다음 작업 단위로 이동합니다.

---

# 22. Clean clone 재현성 검증

## 22.1 현재 작업 저장

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git status -sb
git push
```

작업 파일이 남아 있으면 커밋하거나 원인을 확인합니다.

## 22.2 새 폴더에 clone

```bash
SOURCE_DIR="$PWD"
CURRENT_BRANCH="$(git branch --show-current)"
RETEST_DIR="$HOME/codyssey-retest/e1-1-$(date +%Y%m%d-%H%M%S)"

if test "$CURRENT_BRANCH" != "feat/e1-1-workstation"
then
  echo "[FAIL] clean clone 전 작업 브랜치를 확인하세요."
  exit 1
fi

mkdir -p "$(dirname "$RETEST_DIR")"

gh repo clone gahyun1004/codyssey-training-e1-1 \
  "$RETEST_DIR" \
  -- \
  --branch "$CURRENT_BRANCH" \
  --single-branch

cd "$RETEST_DIR"
git status -sb
```

## 22.3 충돌 없는 재시험 포트 선택

```bash
unset RETEST_PORT
for candidate in 18080 18081 18082
do
  if ! mac lsof -nP -iTCP:"$candidate" -sTCP:LISTEN 2>/dev/null | grep -q LISTEN
  then
    RETEST_PORT="$candidate"
    break
  fi
done

if test -z "${RETEST_PORT:-}"
then
  echo "[FAIL] clean clone 시험 포트를 찾지 못했습니다."
  exit 1
fi
```

## 22.4 재빌드와 실행

```bash
docker build -t codyssey-e1-1-web:retest .
docker rm -f e1-1-retest 2>/dev/null || true

docker run -d \
  --name e1-1-retest \
  -p "127.0.0.1:${RETEST_PORT}:80" \
  codyssey-e1-1-web:retest

mac curl "http://localhost:${RETEST_PORT}"
```

정상 기준:

- clone 직후 파일 수정 없이 빌드 성공
- Mac 게시 포트에서 HTTP 응답 성공

원본으로 돌아와 결과를 기록합니다.

```bash
docker rm -f e1-1-retest
cd "$SOURCE_DIR"

cat >> docs/test-results.md <<EOF

## Clean clone 검증

- 브랜치: $CURRENT_BRANCH
- 재시험 폴더: $RETEST_DIR
- 재시험 포트: $RETEST_PORT
- Docker build: 성공
- HTTP 응답: 성공
EOF

git add docs/test-results.md
git diff --cached
git commit -m "Test: record clean clone verification"
git push
```

---

# 23. Pull Request와 main 병합

동료 평가는 기본 브랜치 내용을 기준으로 진행되므로 최종 결과는 반드시 `main`에 있어야 합니다.

## 23.1 기존 PR 확인

```bash
gh pr list \
  --head feat/e1-1-workstation \
  --base main \
  --state open
```

기존 PR이 있으면 새로 만들지 않습니다.

## 23.2 PR 생성

기존 PR이 없을 때만 실행합니다.

```bash
gh pr create \
  --base main \
  --head feat/e1-1-workstation \
  --title "Feat: complete E1-1 workstation mission" \
  --body "터미널, 권한, Docker 기본 운영, attach·exec, Dockerfile, 포트 매핑, 바인드 마운트, 볼륨 영속성, 증거 문서 및 clean clone 검증을 완료했습니다."
```

```bash
gh pr view
gh pr diff --name-only
gh pr diff
```

확인:

- 의도한 파일만 있다.
- 민감정보가 없다.
- Dockerfile, site, README, 가이드, 증거 문서가 있다.
- `git config --list`, VS Code GitHub 로그인, attach·exec 증거가 있다.
- clean clone 결과가 있다.

## 23.3 병합

모든 검증 후 실행합니다.

```bash
gh pr merge --merge --delete-branch
```

정책 때문에 막히면 `--admin`으로 우회하지 말고 원인을 해결합니다.

---

# 24. 병합 후 최종 검증

## 24.1 main 최신화

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git switch main
git pull --ff-only origin main
git fetch --prune

git status -sb
git log --oneline --graph --decorate -20
```

## 24.2 최종 포트 선택과 빌드

```bash
unset FINAL_PORT
for candidate in 18081 18082 18083
do
  if ! mac lsof -nP -iTCP:"$candidate" -sTCP:LISTEN 2>/dev/null | grep -q LISTEN
  then
    FINAL_PORT="$candidate"
    break
  fi
done

if test -z "${FINAL_PORT:-}"
then
  echo "[FAIL] 최종 검증 포트를 찾지 못했습니다."
  exit 1
fi

docker build -t codyssey-e1-1-web:final .
docker rm -f e1-1-final 2>/dev/null || true

docker run -d \
  --name e1-1-final \
  -p "127.0.0.1:${FINAL_PORT}:80" \
  codyssey-e1-1-web:final

mac curl "http://localhost:${FINAL_PORT}"
```

성공 후 정리합니다.

```bash
docker rm -f e1-1-final
```

공용 장비에서 모든 제출 확인이 끝난 뒤에만 GitHub CLI 로그아웃을 진행합니다.

```bash
gh auth logout --hostname github.com
```

---

# 25. 대표 오류 해결표

| 증상 | 확인 | 조치 |
|---|---|---|
| `orb: command not found` | `command -v orb` | OrbStack 설치·실행 후 터미널 재시작 |
| 머신이 없음 | `orb list` | Ubuntu 머신 생성 |
| GitHub 접속 실패 | `getent hosts github.com` | Mac 네트워크와 OrbStack 상태 확인 |
| `docker: command not found` | `command -v docker` | OrbStack 상태 확인 후 필요할 때 `mac link docker` |
| Docker Server 없음 | `docker version` | OrbStack 실행과 Docker 연결 확인 |
| daemon 연결 실패 | `docker info` | 실제 오류일 때 command link 재설정 |
| Docker 경로 시험 실패 | build·mount 출력 | Ubuntu 경로 공유 상태를 해결한 후 진행 |
| `gh: command not found` | `command -v gh` | 7장의 설치 수행 |
| GitHub 인증 실패 | `gh auth status` | `gh auth login ... --web` 다시 수행 |
| push 권한 없음 | `viewerPermission` | WRITE 이상 권한 확인 |
| clone 폴더 중복 | `git status -sb` | 기존 작업 보존, 삭제 금지 |
| local branch는 없고 remote에만 있음 | `git branch -a` | tracking branch 생성 절차 사용 |
| branch가 main | `git branch --show-current` | 작업 브랜치 전환 |
| VS Code 경로가 `/Users/...` | `pwd` | Remote-SSH로 다시 연결 |
| VS Code GitHub 로그아웃 | Accounts | GitHub 로그인 후 Source Control 재확인 |
| Git 저장소가 아님 | `pwd` | 저장소 폴더로 이동 |
| 포트 충돌 | `mac lsof`, `docker ps` | `.env.local` 포트 선택 절차 재실행 |
| Ubuntu에서 localhost 응답 없음 | 실행 위치 확인 | `mac curl http://localhost:포트` 사용 |
| 컨테이너 이름 충돌 | `docker ps -a` | 해당 E1-1 컨테이너만 제거 |
| 바인드 변경 미반영 | `pwd`, `docker inspect` | 저장소 루트와 마운트 경로 확인 |
| 볼륨 파일 없음 | `docker volume ls` | 두 컨테이너에 동일한 볼륨 이름 사용 |
| 권한 변경이 Git에 안 보임 | `ls -l` | 로그·스크린샷으로 증명 |
| push 거절 | `git fetch`, `git status` | force push 금지, 원격 변경 확인 |

---

# 26. 평가 전 최종 체크리스트

## 터미널과 권한

- [ ] `pwd`, `ls -la`, `cd`, `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat` 수행
- [ ] 절대 경로와 상대 경로 설명 가능
- [ ] 파일과 디렉터리 권한 변경 전후 기록
- [ ] `755`, `644` 설명 가능

## Docker

- [ ] `docker --version`, `docker info` 기록
- [ ] Docker build context와 bind mount 경로 사전 시험 성공
- [ ] `docker images`, `docker ps -a`, `docker logs`, `docker stats` 기록
- [ ] hello-world 실행 성공
- [ ] Ubuntu 컨테이너 내부 명령 실행
- [ ] attach와 exec를 실제로 관찰하고 차이를 기록

## Dockerfile과 접속

- [ ] Dockerfile 직접 작성
- [ ] `nginx:alpine` 선택 이유 기록
- [ ] LABEL, COPY, EXPOSE 커스텀 목적 기록
- [ ] 이미지 빌드 성공 로그
- [ ] 안전한 포트를 선택해 포트 매핑 접속 성공
- [ ] Mac 주소창과 화면이 함께 보이는 캡처

## 마운트와 볼륨

- [ ] 바인드 마운트 변경 전후 증명
- [ ] 볼륨 생성·연결·검증 기록
- [ ] 컨테이너 삭제 후 데이터 유지 확인

## Git·GitHub·VS Code

- [ ] Git 사용자 정보 확인
- [ ] `init.defaultBranch=main` 설정
- [ ] `git config --list` 결과 기록
- [ ] GitHub CLI 로그인과 push
- [ ] VS Code GitHub 로그인 증거
- [ ] VS Code Source Control 저장소·브랜치 증거
- [ ] VS Code Remote-SSH Ubuntu 경로 증거
- [ ] local·remote branch를 안전하게 처리
- [ ] 기능 단위 커밋

## 문서와 재현성

- [ ] README에서 가이드와 모든 증거 문서에 접근 가능
- [ ] 명령어와 출력 결과가 `.txt` 또는 Markdown에 기록됨
- [ ] 트러블슈팅 2건 이상
- [ ] clean clone 성공
- [ ] 작업 브랜치를 main에 병합
- [ ] main에서 최종 빌드와 HTTP 검증 성공
- [ ] 토큰·비밀번호·개인키·인증 코드 없음

---

## 완료 문장 예시

> macOS와 OrbStack Ubuntu 24.04 환경에서 터미널·권한·Docker·Git/GitHub 개발 워크스테이션을 구축했다. 직접 작성한 Dockerfile로 NGINX 웹 서버 이미지를 빌드하고 포트 매핑, 바인드 마운트, Docker 볼륨 영속성을 검증했다. attach와 exec의 차이를 실제로 관찰했으며, 모든 명령과 출력 결과를 문서화했다. 작업 브랜치를 clean clone으로 재검증하고 main에 병합한 뒤 최종 빌드와 HTTP 응답까지 확인했다.
