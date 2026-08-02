# Windows 11 Pro + WSL2 + Ubuntu 24.04 수행 가이드

이 문서는 Windows 11 Pro에서 WSL2, Ubuntu 24.04, VS Code Remote-WSL, Docker Desktop WSL Integration을 사용해 E1-1 개발 워크스테이션을 구성하는 절차입니다.

> 실제 설치·실행 결과는 사용자가 직접 확인해야 합니다. 이 문서와 스크립트는 실행 구조와 검증 기준을 제공하며, 실제 로그나 성공 증거를 대신하지 않습니다.

---

## 1. 구성 개요

```text
Windows 11 Pro
├── Windows Terminal / PowerShell
├── Visual Studio Code
│   └── WSL 확장
├── WSL2
│   └── Ubuntu-24.04
│       ├── bash
│       ├── Git / GitHub CLI
│       ├── 프로젝트 저장소
│       └── Docker CLI
└── Docker Desktop
    └── WSL 2 backend + Ubuntu-24.04 integration
```

권장 저장소 위치:

```text
/home/<WSL사용자>/codyssey-training/codyssey-training-e1-1
```

Windows 파일시스템 경로인 `/mnt/c/...`보다 WSL Linux 파일시스템에 저장하는 구성을 권장합니다.

---

## 2. Windows 버전 확인

```powershell
# [PowerShell]
Get-ComputerInfo |
  Select-Object WindowsProductName, WindowsVersion, OsBuildNumber
```

기록 항목:

- Windows 제품명: Windows 11 Pro
- Windows 버전:
- OS 빌드:
- CPU 아키텍처:

```powershell
$env:PROCESSOR_ARCHITECTURE
```

---

## 3. WSL 설치

PowerShell 또는 Windows Terminal을 관리자 권한으로 실행합니다.

```powershell
# [PowerShell 관리자]
wsl.exe --list --online
```

`Ubuntu-24.04`가 목록에 있으면:

```powershell
wsl.exe --install -d Ubuntu-24.04
```

설치 과정에서 재시작을 요구하면 Windows를 재시작합니다.

Ubuntu 24.04 첫 실행 시:

1. 배포판 초기화 대기
2. Linux 사용자 이름 입력
3. Linux 비밀번호 입력
4. 프롬프트가 표시되는지 확인

보조 스크립트:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\setup-wsl.ps1
```

스크립트는 관리자 권한, WSL 상태, 배포판 설치 여부를 확인합니다. 재부팅과 최초 Linux 사용자 생성은 자동으로 완료하지 않습니다.

---

## 4. WSL2 상태 확인

```powershell
wsl.exe --version
wsl.exe --status
wsl.exe --list --verbose
```

정상 예시:

```text
NAME              STATE           VERSION
* Ubuntu-24.04    Running         2
```

필요한 경우:

```powershell
wsl.exe --set-default-version 2
wsl.exe --set-version Ubuntu-24.04 2
wsl.exe --set-default Ubuntu-24.04
```

WSL 업데이트:

```powershell
wsl.exe --update
```

WSL 재시작:

```powershell
wsl.exe --shutdown
```

---

## 5. Ubuntu 24.04 초기 설정

```powershell
wsl.exe -d Ubuntu-24.04
```

Ubuntu에서:

```bash
cat /etc/os-release
uname -a
whoami
printf 'HOME=%s\n' "$HOME"
printf 'SHELL=%s\n' "$SHELL"
printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-}"
```

패키지 설치:

```bash
sudo apt update
sudo apt install -y \
  ca-certificates curl wget git gnupg nano vim tree jq tar unzip zip
```

Git 설정:

```bash
git config --global init.defaultBranch main
git config --global user.name "본인의 Git 이름"
git config --global user.email "본인의 GitHub 이메일"
git config --list
```

이메일이 포함된 화면을 공개할 때는 일부를 마스킹합니다.

---

## 6. 저장소 clone

```bash
mkdir -p ~/codyssey-training
cd ~/codyssey-training

git clone https://github.com/gahyun1004/codyssey-training-e1-1.git
cd codyssey-training-e1-1

git status -sb
git remote -v
pwd
```

이미 clone되어 있다면:

```bash
cd ~/codyssey-training/codyssey-training-e1-1
git pull --ff-only origin main
```

경로 확인:

```bash
case "$PWD" in
  /mnt/*)
    echo "[WARN] 현재 저장소가 Windows 마운트 경로에 있습니다: $PWD"
    ;;
  "$HOME"/*)
    echo "[PASS] 저장소가 WSL Linux 홈에 있습니다: $PWD"
    ;;
esac
```

---

## 7. VS Code와 WSL 확장

Windows에 VS Code가 설치되어 있어야 합니다.

PowerShell에서:

```powershell
code --version
code --install-extension ms-vscode-remote.remote-wsl
code --list-extensions |
  Select-String -SimpleMatch "ms-vscode-remote.remote-wsl"
```

`code` 명령이 없다면 VS Code 설치 과정의 PATH 옵션을 확인하거나 VS Code를 재설치합니다.

---

## 8. WSL 저장소에서 VS Code 실행

Ubuntu에서:

```bash
cd ~/codyssey-training/codyssey-training-e1-1
code .
```

Windows 스크립트:

```powershell
.\scripts\windows\open-vscode-wsl.ps1
```

매개변수 지정:

```powershell
.\scripts\windows\open-vscode-wsl.ps1 `
  -Distribution "Ubuntu-24.04" `
  -RepositoryPath "codyssey-training/codyssey-training-e1-1"
```

성공 기준:

- 왼쪽 아래 상태 표시: `WSL: Ubuntu-24.04`
- Explorer 폴더: `codyssey-training-e1-1`
- 새 통합 터미널: bash
- 터미널 경로: Git 저장소 루트
- `/etc/os-release`: Ubuntu 24.04

---

## 9. VS Code 새 터미널 검증

```text
Terminal
→ New Terminal
```

```bash
cat /etc/os-release
printf 'SHELL=%s\n' "$SHELL"
ps -p $$ -o comm=
printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-}"
pwd
git rev-parse --show-toplevel
git branch --show-current
```

Task 실행:

```text
Ctrl + Shift + P
→ Tasks: Run Task
→ E1-1: Verify WSL Ubuntu Workspace
```

직접 실행:

```bash
scripts/ubuntu/verify-wsl-workspace.sh
```

---

## 10. Docker Desktop WSL Integration

권장 방식은 Windows용 Docker Desktop의 WSL 2 backend입니다.

Docker Desktop 설정:

```text
Settings
→ General
→ Use the WSL 2 based engine

Settings
→ Resources
→ WSL Integration
→ Ubuntu-24.04 활성화
→ Apply & Restart
```

주의:

- Docker Desktop을 사용하는 경우 WSL Ubuntu에 독립 Docker Engine을 중복 설치하지 않습니다.
- WSL Integration 대상 배포판을 정확히 선택합니다.
- Docker Desktop이 Windows containers mode이면 Linux containers로 전환합니다.

Ubuntu에서 확인:

```bash
docker --version
docker context show
docker version
docker info
docker run --rm hello-world
```

---

## 11. Dockerfile 웹 서버

```bash
cd ~/codyssey-training/codyssey-training-e1-1

docker build -t codyssey-e1-1-web:1.0 . \
  2>&1 | tee docs/logs/docker-build.txt
```

실행:

```bash
docker rm -f e1-1-web 2>/dev/null || true

docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:8080:80" \
  codyssey-e1-1-web:1.0

docker ps
docker logs e1-1-web
curl http://localhost:8080
```

Windows 브라우저:

```text
http://localhost:8080
```

주소창과 응답을 함께 캡처합니다.

---

## 12. 포트 충돌 처리

```bash
source <(scripts/ubuntu/select-port.sh)
printf 'HOST_PORT=%s\n' "$HOST_PORT"
```

```bash
docker rm -f e1-1-web 2>/dev/null || true

docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0
```

PowerShell에서 확인:

```powershell
Get-NetTCPConnection -State Listen |
  Where-Object LocalPort -eq 8080
```

---

## 13. 바인드 마운트

```bash
docker rm -f e1-1-bind 2>/dev/null || true

docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:8080:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine

curl http://localhost:8080
```

`bind-test/index.html` 수정 후:

```bash
curl http://localhost:8080
```

컨테이너를 재시작하지 않고 변경이 반영되어야 합니다.

---

## 14. 볼륨 영속성

```bash
docker volume create e1-1-data

docker run -d \
  --name e1-1-volume-1 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-1 \
  bash -lc 'echo "persistent data" > /data/result.txt'

docker rm -f e1-1-volume-1

docker run -d \
  --name e1-1-volume-2 \
  -v e1-1-data:/data \
  ubuntu:24.04 \
  sleep infinity

docker exec e1-1-volume-2 cat /data/result.txt
```

`persistent data`가 출력되어야 합니다.

---

## 15. Windows·Linux 경로 구분

| Windows | WSL |
|---|---|
| `C:\Users\name\project` | `/mnt/c/Users/name/project` |
| `\\wsl$\Ubuntu-24.04\home\name` | `/home/name` |
| PowerShell | bash |
| `Get-ChildItem` | `ls -la` |
| `Get-Location` | `pwd` |

권장 원칙:

- Git·Docker 빌드·권한 실습은 `/home/...`에서 수행
- Windows Explorer에서 WSL 파일을 볼 때 `\\wsl$\Ubuntu-24.04\home\<사용자>` 사용
- WSL 파일을 Windows 편집기로 직접 반복 수정하기보다 VS Code WSL 창 사용
- PowerShell 경로를 bash 명령에 그대로 전달하지 않음

---

## 16. 줄바꿈 정책

저장소의 `.gitattributes`:

```gitattributes
* text=auto
*.sh text eol=lf
Dockerfile text eol=lf
*.ps1 text eol=crlf
```

검증:

```bash
git ls-files --eol
```

셸 스크립트에서 `^M` 오류가 발생하면:

```bash
sed -i 's/\r$//' scripts/ubuntu/*.sh
```

단, 변경 전 `git diff`를 확인합니다.

---

## 17. 환경 증거 저장

WSL Ubuntu:

```bash
{
  echo '$ cat /etc/os-release'
  cat /etc/os-release
  echo '$ uname -a'
  uname -a
  echo '$ echo $WSL_DISTRO_NAME'
  echo "${WSL_DISTRO_NAME:-}"
  echo '$ pwd'
  pwd
  echo '$ git rev-parse --show-toplevel'
  git rev-parse --show-toplevel
  echo '$ docker version'
  docker version
} 2>&1 | tee docs/logs/windows-wsl-environment.txt
```

PowerShell:

```powershell
$log = @(
  "`$ wsl.exe --version"
  (wsl.exe --version)
  "`$ wsl.exe --status"
  (wsl.exe --status)
  "`$ wsl.exe --list --verbose"
  (wsl.exe --list --verbose)
)

$log | Set-Content -Encoding utf8 docs\logs\windows-wsl-host.txt
```

민감정보와 개인 경로를 검토한 후 커밋합니다.

---

## 18. 트러블슈팅

### WSL 설치 명령이 도움말만 출력

```powershell
wsl.exe --list --online
wsl.exe --install -d Ubuntu-24.04
```

### Ubuntu가 WSL 1

```powershell
wsl.exe --set-version Ubuntu-24.04 2
```

### VS Code가 Windows 로컬 창으로 열림

WSL Ubuntu 터미널에서 저장소로 이동한 뒤:

```bash
code .
```

왼쪽 아래 `WSL: Ubuntu-24.04`를 확인합니다.

### `code: command not found`

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

VS Code 설치 경로와 PATH를 확인하고 Windows Terminal과 WSL을 다시 엽니다.

### Docker Client만 있고 Server 없음

- Docker Desktop 실행 여부
- WSL 2 based engine
- Ubuntu-24.04 WSL Integration
- Linux containers mode

확인 후:

```powershell
wsl.exe --shutdown
```

Docker Desktop을 재시작하고 Ubuntu를 다시 엽니다.

### 저장소가 `/mnt/c`에 있음

Linux 홈에 다시 clone합니다.

```bash
mkdir -p ~/codyssey-training
cd ~/codyssey-training
git clone https://github.com/gahyun1004/codyssey-training-e1-1.git
```

---

## 19. 최종 체크리스트

- [ ] Windows 11 Pro 버전 기록
- [ ] WSL 버전 기록
- [ ] Ubuntu-24.04 설치
- [ ] `wsl -l -v`에서 VERSION 2
- [ ] Ubuntu Linux 사용자 생성
- [ ] 저장소를 `/home/...`에 clone
- [ ] VS Code WSL 확장 설치
- [ ] Ubuntu에서 `code .`
- [ ] VS Code 왼쪽 아래 WSL 표시
- [ ] bash와 workspace 경로 확인
- [ ] Docker Desktop WSL Integration 활성화
- [ ] Docker Client·Server 확인
- [ ] Dockerfile 빌드
- [ ] 포트 매핑
- [ ] 바인드 마운트
- [ ] 볼륨 영속성
- [ ] 실제 로그·스크린샷 저장
- [ ] 민감정보 검토
- [ ] clean clone 재검증

---

## 공식 참고자료

- Microsoft WSL 설치: <https://learn.microsoft.com/windows/wsl/install>
- VS Code WSL: <https://code.visualstudio.com/docs/remote/wsl>
- Docker Desktop WSL 2 backend: <https://docs.docker.com/desktop/features/wsl/>
- Docker Desktop + WSL 개발: <https://docs.docker.com/desktop/features/wsl/use-wsl/>
