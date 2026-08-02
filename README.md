# E1-1. 내 컴퓨터에 개발자용 ‘작업실’ 꾸미기

> **분야:** 입학연수  
> **구분:** 개발 입문  
> **학습시간:** 40시간

개발은 코드를 작성하는 순간이 아니라 **환경을 세팅하는 순간부터** 시작됩니다. 이 미션에서는 리눅스 CLI, Docker, Git·GitHub를 직접 사용하여 누구나 같은 방식으로 실행·검증할 수 있는 개발 워크스테이션을 구축합니다.

---

## 수행 문서

- [초보자 단계별 수행 가이드](E1-1-training.md)
- [실행 환경](docs/environment.md)
- [터미널 및 권한 실습](docs/terminal-and-permissions.md)
- [Docker 운영](docs/docker-operations.md)
- [커스텀 이미지 설계](docs/image-design.md)
- [포트 매핑 및 바인드 마운트](docs/port-and-bind.md)
- [볼륨 영속성](docs/volume-persistence.md)
- [최종 검증 결과](docs/test-results.md)
- [트러블슈팅](docs/troubleshooting.md)
- [스크린샷 증거](docs/screenshots/)

> 위 문서와 폴더는 미션을 수행하면서 채웁니다. 평가 시 README에서 모든 결과와 증거로 접근할 수 있어야 합니다.

---

## 목차

1. [미션 소개](#1-미션-소개)
2. [서울캠퍼스 환경 안내](#2-서울캠퍼스-환경-안내)
3. [최종 결과물](#3-최종-결과물)
4. [과제 목표](#4-과제-목표)
5. [기능 요구 사항](#5-기능-요구-사항)
6. [실행 흐름](#6-실행-흐름)
7. [보너스 과제](#7-보너스-과제)
8. [개발 환경](#8-개발-환경)
9. [제약 사항](#9-제약-사항)
10. [권장 저장소 구조](#10-권장-저장소-구조)
11. [평가 전 체크리스트](#11-평가-전-체크리스트)
12. [동료 평가 유의사항](#12-동료-평가-유의사항)

---

## 1. 미션 소개

개발 워크스테이션은 코드가 특정 개인의 컴퓨터에서만 동작하는 문제를 줄이고, 팀원 누구나 같은 방식으로 실행·배포·디버깅할 수 있도록 만드는 환경입니다.

이번 미션에서는 다음 핵심 도구를 함께 사용합니다.

- **리눅스 CLI:** 경로, 파일, 디렉터리, 권한 조작
- **Docker:** 재현 가능한 컨테이너 실행 환경
- **Dockerfile:** 기존 이미지를 기반으로 커스텀 이미지 제작
- **포트 매핑:** 호스트에서 컨테이너 서비스 접속
- **바인드 마운트:** 호스트 파일 변경사항의 실시간 반영
- **Docker 볼륨:** 컨테이너 삭제 후에도 유지되는 영속 데이터
- **Git:** 로컬 변경 이력 관리
- **GitHub:** 원격 저장소 및 협업
- **VS Code:** GitHub 로그인과 저장소 연동

단순히 명령어를 따라 입력하는 것이 아니라, **명령어와 출력 결과, 브라우저 접속, 변경 전후 비교, 데이터 유지 여부**를 증거로 남겨야 합니다.

이 경험은 이후 리눅스 트러블슈팅, CI/CD 파이프라인, 클라우드 배포 및 운영 학습으로 확장됩니다.

---

## 2. 서울캠퍼스 환경 안내

서울캠퍼스에서는 시스템 보안 정책상 `sudo` 권한 사용이 제한될 수 있습니다. 일반적인 방식으로 Docker를 직접 설치하거나 데몬을 제어하기 어려운 경우 **OrbStack**을 활용합니다.

OrbStack은 Docker Desktop과 유사한 컨테이너 실행 환경을 제공하며, 앱을 실행하면 내부 Docker 엔진을 사용할 수 있습니다.

```bash
docker run
docker ps
docker build
```

이 저장소의 단계별 가이드는 다음 환경을 기준으로 작성되어 있습니다.

```text
macOS
└── OrbStack
    ├── Ubuntu 24.04 LTS: codyssey-training
    └── OrbStack Docker Engine
```

---

## 3. 최종 결과물

다음 결과물을 GitHub Repository에서 확인할 수 있어야 합니다.

### 3.1 GitHub 제출 저장소

- 공개 또는 과제 제출 규칙에 맞는 권한으로 생성한다.
- 제출은 GitHub Repository URL로 진행한다.
- 평가자는 기본 브랜치인 `main`의 내용을 확인한다.

### 3.2 기술 문서

README 또는 README에서 연결되는 문서에 다음을 포함한다.

- 프로젝트 개요와 미션 목표
- 실행 환경
  - OS
  - Shell
  - Terminal
  - OrbStack 또는 Docker 실행 환경
  - Docker 버전
  - Git 버전
  - VS Code 버전
- 수행 항목 체크리스트
- 검증 명령과 출력 결과
- 증거 파일 또는 스크린샷 링크
- 트러블슈팅 최소 2건

### 3.3 터미널 조작 로그

현재 위치, 목록, 이동, 생성, 복사, 이동·이름 변경, 삭제, 파일 내용 확인, 빈 파일 생성 명령과 결과를 기록한다.

### 3.4 권한 변경 증거

- 파일 최소 1개
- 디렉터리 최소 1개
- 권한 변경 전과 변경 후
- `r/w/x`, `755`, `644` 설명

### 3.5 Docker 운영·검증 로그

다음 명령의 실행 결과를 기록한다.

```bash
docker --version
docker version
docker info
docker images
docker ps
docker ps -a
docker logs <container_name>
docker stats --no-stream
```

### 3.6 Dockerfile 기반 웹 서버

- 웹 서버 소스코드
- 직접 작성한 `Dockerfile`
- 선택한 베이스 이미지
- 적용한 커스텀 포인트와 목적
- 이미지 빌드 성공 로그
- 컨테이너 실행 성공 로그

### 3.7 포트 매핑 증거

- 호스트 포트와 컨테이너 포트 연결
- 브라우저 주소창과 응답 화면 또는 `curl` 응답
- 포트 충돌 시 원인 확인과 대체 포트 기록

### 3.8 바인드 마운트와 볼륨 증거

- 바인드 마운트 실행 명령
- 호스트 파일 변경 전·후 비교
- 컨테이너 재실행 없이 변경 반영 확인
- Docker 볼륨 생성·연결·검증
- 컨테이너 삭제 전·후 데이터 유지 확인

### 3.9 Git·GitHub·VS Code 증거

- Git 사용자 정보와 기본 브랜치 설정
- `git config --list` 결과
- GitHub CLI 인증
- GitHub 저장소 push
- VS Code GitHub 로그인
- VS Code Source Control에서 저장소와 브랜치 확인
- Remote-SSH 환경과 Ubuntu 경로 확인

---

## 4. 과제 목표

미션 완료 후 다음 내용을 스스로 설명할 수 있어야 합니다.

### 4.1 경로와 터미널

- 절대 경로와 상대 경로의 차이
- `pwd`, `ls`, `cd`, `mkdir`, `touch`, `cp`, `mv`, `rm`, `cat`의 역할

### 4.2 파일 권한

- `r`, `w`, `x`의 의미
- 소유자·그룹·기타 사용자의 권한
- `755`, `644` 숫자 권한 계산 규칙

### 4.3 Docker 구조

- 이미지와 컨테이너의 차이
- 격리된 실행 환경이 필요한 이유
- `attach`와 `exec`의 차이
- 기존 베이스 이미지로 커스텀 이미지를 만드는 방법

### 4.4 네트워크와 스토리지

- 포트 매핑이 필요한 이유
- 호스트 포트와 컨테이너 포트의 차이
- 바인드 마운트의 역할
- Docker 볼륨과 데이터 영속성

### 4.5 Git과 GitHub

- Git의 로컬 버전 관리 역할
- GitHub의 원격 저장소·협업 역할
- 작업 브랜치와 기본 브랜치의 차이
- clean clone으로 재현성을 검증하는 이유

---

## 5. 기능 요구 사항

### 5.1 제출 저장소 및 기술 문서

- GitHub Repository 링크로 제출한다.
- 모든 결과는 README에서 접근 가능해야 한다.
- 기술 문서의 명령과 출력은 코드 블록 또는 로그 파일로 정리한다.

### 5.2 터미널 조작

다음 작업을 CLI로 수행한다.

```bash
pwd
ls
ls -la
cd
mkdir
touch
cat
cp
mv
rm
rmdir
```

### 5.3 권한 실습

```bash
ls -l
ls -ld
chmod 644 <file>
chmod 755 <directory>
```

파일과 디렉터리 각각에 대해 변경 전후를 기록한다.

### 5.4 Docker 설치·연결 점검

```bash
docker --version
docker version
docker info
docker run --rm hello-world
```

Client와 Server가 모두 표시되고 `Hello from Docker!`가 출력되어야 한다.

### 5.5 Docker 기본 운영

- 이미지 다운로드와 목록 확인
- 컨테이너 실행·중지·재시작·삭제
- 실행 중 목록과 전체 목록 확인
- 로그와 리소스 확인
- Ubuntu 컨테이너 내부에서 `pwd`, `ls`, `echo` 실행
- `attach`와 `exec`를 실제로 관찰하고 차이 기록

### 5.6 커스텀 이미지 제작

다음 방식 중 하나를 선택한다.

1. NGINX·Apache 등 웹 서버 이미지에 정적 콘텐츠 또는 설정 추가
2. Ubuntu·Alpine 등 Linux 이미지에 패키지·사용자·환경 변수·헬스체크 추가

기술 문서에는 다음을 작성한다.

- 베이스 이미지와 선택 이유
- 커스텀 포인트와 목적
- Dockerfile
- 빌드·실행 명령
- 핵심 출력과 스크린샷

### 5.7 포트 매핑

```bash
docker run -d \
  -p <host_port>:<container_port> \
  --name <container_name> \
  <image_name>
```

브라우저 또는 `curl`로 접속하고 주소와 응답을 기록한다.

### 5.8 바인드 마운트

```bash
docker run -d \
  -v "$(pwd)/site:/usr/share/nginx/html:ro" \
  <image_name>
```

호스트 파일을 변경하고 컨테이너 재실행 없이 반영되는지 확인한다.

### 5.9 Docker 볼륨

```bash
docker volume create mydata

docker run -d \
  --name vol-test \
  -v mydata:/data \
  ubuntu:24.04 \
  sleep infinity
```

컨테이너를 삭제한 후 새 컨테이너에 같은 볼륨을 연결해 기존 데이터를 확인한다.

### 5.10 Git 및 GitHub 연동

```bash
git config --global user.name "<name>"
git config --global user.email "<email>"
git config --global init.defaultBranch main
git config --list
```

- 작업 브랜치에서 기능 단위로 커밋한다.
- GitHub에 push한다.
- Pull Request로 `main`에 병합한다.
- 최종 결과가 `main`에 존재하는지 확인한다.

### 5.11 보안과 개인정보 보호

저장소, 로그, 캡처에 다음 정보를 포함하지 않는다.

- 비밀번호
- GitHub 토큰과 인증 코드
- API 토큰
- 개인키
- `~/.config/gh/hosts.yml`
- `~/.ssh` 전체
- `.env`, `.env.local`
- 학교 내부 민감정보

민감정보가 노출되면 문서와 Git 기록에서 제거하고 해당 토큰·키를 폐기·재발급한다.

---

## 6. 실행 흐름

1. OrbStack과 Ubuntu 환경 확인
2. 네트워크와 기본 패키지 확인
3. Docker Client·Server·hello-world 확인
4. Docker build context와 bind mount 경로 시험
5. GitHub CLI 설치와 로그인
6. 저장소 clone과 안전한 작업 브랜치 생성
7. VS Code Remote-SSH와 GitHub 로그인 확인
8. 터미널·권한 실습
9. Docker 기본 운영과 attach·exec 관찰
10. Dockerfile과 정적 웹 페이지 제작
11. 포트 매핑 검증
12. 바인드 마운트 변경 반영 검증
13. 볼륨 데이터 영속성 검증
14. 로그·스크린샷·트러블슈팅 정리
15. 기능 단위 commit과 push
16. clean clone 재현성 검증
17. Pull Request 병합
18. `main`에서 최종 빌드와 HTTP 응답 확인

자세한 명령과 오류 대응은 [초보자 단계별 수행 가이드](E1-1-training.md)를 따릅니다.

---

## 7. 보너스 과제

### 7.1 Docker Compose 기초

- `compose.yml` 또는 `docker-compose.yml` 작성
- 단일 서비스 실행
- 명령형 실행을 문서화된 설정으로 바꾸는 이유 정리

### 7.2 멀티 컨테이너

- 웹 서버와 보조 서비스 2개 이상 실행
- 컨테이너 간 네트워크 통신 확인
- 서비스 디스커버리 개념 정리

### 7.3 Compose 운영

```bash
docker compose up
docker compose down
docker compose ps
docker compose logs
```

### 7.4 환경 변수

Dockerfile 또는 Compose에 환경 변수를 주입해 서버 포트나 실행 모드를 변경한다.

### 7.5 GitHub SSH 키

HTTPS 대신 SSH 방식으로 push하도록 설정하고 인증 방식 차이와 보안 습관을 정리한다.

---

## 8. 개발 환경

원문 미션은 특정 버전을 강제하지 않고 개발 환경을 `N/A`로 제시합니다. 실제 수행 환경은 다음 표와 `docs/environment.md`에 기록합니다.

| 항목 | 실제 환경 |
|---|---|
| OS | 작성 예정 |
| Shell | 작성 예정 |
| Terminal | 작성 예정 |
| OrbStack | 작성 예정 |
| Ubuntu | 작성 예정 |
| Docker | 작성 예정 |
| Git | 작성 예정 |
| GitHub CLI | 작성 예정 |
| VS Code | 작성 예정 |

---

## 9. 제약 사항

### 9.1 제출

- GitHub Repository URL로 제출한다.
- 별도 문서를 사용할 수 있지만 README에서 링크로 접근할 수 있어야 한다.

### 9.2 실행

- 모든 핵심 작업은 CLI 기반으로 수행한다.
- Dockerfile은 직접 작성한다.
- 포트 매핑, 바인드 마운트, 볼륨을 직접 설정하고 검증한다.

### 9.3 증거

- 캡처와 로그에 명령 입력과 출력 결과가 함께 있어야 한다.
- 브라우저 캡처에는 주소창과 포트를 포함한다.
- 민감정보는 반드시 제거하거나 마스킹한다.

### 9.4 재현성

- 평가자가 README와 연결 문서만 보고 절차를 재현할 수 있어야 한다.
- 개인 PC에 종속된 경로나 설정에는 대체 방법과 주의사항을 작성한다.
- clean clone으로 Docker 이미지 빌드와 HTTP 응답을 다시 검증한다.

---

## 10. 권장 저장소 구조

```text
codyssey-training-e1-1/
├── README.md
├── E1-1-training.md
├── Dockerfile
├── .dockerignore
├── .gitignore
├── site/
│   └── index.html
├── bind-test/
│   └── index.html
├── practice/
├── docs/
│   ├── environment.md
│   ├── terminal-and-permissions.md
│   ├── docker-operations.md
│   ├── image-design.md
│   ├── port-and-bind.md
│   ├── volume-persistence.md
│   ├── test-results.md
│   ├── troubleshooting.md
│   ├── logs/
│   └── screenshots/
│       ├── environment/
│       ├── terminal/
│       ├── permissions/
│       ├── docker/
│       ├── port-mapping/
│       ├── bind-mount/
│       ├── volume/
│       ├── github/
│       └── vscode/
└── compose.yml                 # 선택 과제
```

---

## 11. 평가 전 체크리스트

### 터미널과 권한

- [ ] 터미널 기본 명령 수행 및 로그 기록
- [ ] 절대 경로와 상대 경로 설명
- [ ] 파일과 디렉터리 권한 변경 전후 기록
- [ ] `755`, `644` 설명

### Docker

- [ ] Docker Client·Server 연결 확인
- [ ] hello-world 실행 성공
- [ ] 이미지·컨테이너·로그·리소스 확인
- [ ] Ubuntu 컨테이너 내부 명령 실행
- [ ] attach와 exec 실제 관찰

### Dockerfile·포트·스토리지

- [ ] Dockerfile 직접 작성
- [ ] 베이스 이미지 선택 이유 기록
- [ ] 커스텀 포인트 목적 기록
- [ ] 이미지 빌드와 컨테이너 실행 성공
- [ ] 포트 매핑 접속 증거
- [ ] 바인드 마운트 변경 전후 증거
- [ ] 컨테이너 삭제 후 볼륨 데이터 유지

### Git·GitHub·VS Code

- [ ] `git config --list` 기록
- [ ] GitHub CLI 로그인과 push
- [ ] VS Code GitHub 로그인
- [ ] Source Control 저장소와 브랜치 확인
- [ ] 작업 브랜치의 기능 단위 커밋
- [ ] Pull Request를 `main`에 병합

### 문서·재현성·보안

- [ ] README에서 모든 수행 문서와 증거에 접근 가능
- [ ] 트러블슈팅 최소 2건
- [ ] clean clone 재현성 검증
- [ ] `main` 최종 빌드와 HTTP 응답 성공
- [ ] 토큰·비밀번호·인증 코드·개인키 없음

---

## 12. 동료 평가 유의사항

- 동료 평가는 캐빈에서 평가자와 피평가자가 함께 대면으로 진행한다.
- 평가 과정과 피드백 작성은 피평가자의 PC에서 진행한다.
- 원격 평가와 여러 평가의 동시 진행은 금지된다.
- 코드 리뷰는 제출 GitHub Repository의 **Default branch** 내용을 기준으로 진행된다.
- 피평가자는 구현 방법, 기술 선택, 선택 이유를 설명할 수 있어야 한다.
- “AI가 작성했다”는 답변만으로 구현을 정당화할 수 없다.
- 평가자는 실제 명령 실행, 로그, 접속, 변경 반영, 데이터 유지 여부를 확인한다.
- 피드백에는 확인한 기능, 명령, 코드, 문제 해결 과정과 배운 점을 구체적으로 작성한다.
