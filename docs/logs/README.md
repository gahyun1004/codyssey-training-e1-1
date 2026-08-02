# 실행 로그

E1-1에서 직접 실행한 명령과 출력 결과를 저장합니다. 로그 파일은 비어 있는 템플릿이 아니라 실제 명령과 결과를 함께 포함해야 합니다.

## 공통 파일

- 환경: `environment.txt`
- 터미널: `terminal-basic.txt`
- 권한: `permissions.txt`
- Docker 기본 운영: `docker-basic.txt`
- hello-world: `hello-world.txt`
- Docker 빌드: `docker-build.txt`
- 포트 매핑: `port-mapping.txt`
- 바인드 마운트: `bind-mount-after.txt`
- 볼륨: `volume-persistence.txt`

## Windows 11 Pro + WSL2

- Windows 호스트: `windows-wsl-host.txt`
- WSL Ubuntu: `windows-wsl-environment.txt`
- Docker Desktop WSL Integration: `windows-wsl-docker.txt`

## 기본 로그 자동 생성

WSL·Ubuntu 저장소 루트에서 다음 명령을 실행하면 환경, 터미널, 권한, Docker 기본 운영과 hello-world 로그를 생성합니다.

```bash
bash scripts/ubuntu/collect-evidence.sh
```

Windows PowerShell에서 다음 스크립트를 실행하면 WSL 저장소의 `windows-wsl-host.txt`를 생성합니다.

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\windows\collect-wsl-host-evidence.ps1
```

자동 생성 범위에 포함되지 않는 다음 항목은 README와 세부 문서에 따라 직접 수행합니다.

- `attach`와 `exec`의 상호작용 관찰
- 커스텀 이미지 build
- 포트 매핑과 브라우저 접속
- 바인드 마운트 변경 전후
- Docker 볼륨 영속성
- 화면 캡처

## 권장 로그 형식

```bash
{
  echo '$ 실행한 명령'
  실제_명령
} 2>&1 | tee docs/logs/파일명.txt
```

명령 문자열과 출력 결과가 모두 있어야 평가자가 수행 과정을 재현할 수 있습니다.

## 기록 원칙

- 실제 실행하지 않은 결과를 작성하지 않습니다.
- 자동 생성된 로그도 본인이 내용을 확인한 후 사용합니다.
- 토큰, 비밀번호, 인증 코드, 개인키를 저장하지 않습니다.
- 사용자 이름, 이메일, 내부 경로는 필요하면 마스킹합니다.
- 로그가 없는 상태와 실제 검증 성공 상태를 구분합니다.
- 오류가 포함된 로그를 임의로 삭제하지 말고 해결 과정과 함께 `docs/troubleshooting.md`에 연결합니다.
