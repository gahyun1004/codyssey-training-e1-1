# Docker 운영 실습

> 이 문서는 실행 절차와 기록 양식입니다. 실제 명령 출력과 관찰 결과는 본인이 수행한 뒤 채웁니다.

## 1. 설치 및 연결 점검

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
  echo '$ docker ps -a'
  docker ps -a
  echo '$ docker stats --no-stream'
  docker stats --no-stream
} 2>&1 | tee docs/logs/docker-basic.txt
```

정상 기준:

- Docker Client와 Server 정보가 모두 표시됨
- `docker info`가 오류 없이 종료됨

## 2. hello-world

```bash
{
  echo '$ docker run --rm hello-world'
  docker run --rm hello-world
} 2>&1 | tee docs/logs/hello-world.txt
```

- 실제 출력 요약:
- 성공 여부:

## 3. Ubuntu 컨테이너 내부 명령

```bash
docker rm -f e1-1-attach 2>/dev/null || true
docker run -dit --name e1-1-attach ubuntu:24.04 bash
docker attach e1-1-attach
```

컨테이너 안에서 직접 실행합니다.

```bash
pwd
ls -la
echo "inside ubuntu container"
cat /etc/os-release
```

컨테이너를 종료하지 않고 분리합니다.

```text
Ctrl + P
Ctrl + Q
```

- `pwd` 결과:
- `ls -la` 결과:
- `echo` 결과:
- Ubuntu 버전:

## 4. attach와 exec 비교

분리 후 호스트의 Ubuntu 터미널에서 실행합니다.

```bash
docker ps --filter name=e1-1-attach
docker exec e1-1-attach \
  bash -lc 'echo "exec creates another process"; ps -ef'
```

| 구분 | 관찰 내용 |
|---|---|
| `attach` | 컨테이너의 기존 기본 프로세스에 연결 |
| `exec` | 실행 중인 컨테이너에서 별도 프로세스를 생성 |

- `attach` 실제 관찰 결과:
- `exec` 실제 관찰 결과:
- 두 방식의 차이를 본인 표현으로 설명:

## 5. 정리

```bash
docker rm -f e1-1-attach
```

## 6. 증거

- `docs/logs/docker-basic.txt`
- `docs/logs/hello-world.txt`
- `docs/screenshots/docker/`

스크린샷에는 명령과 출력이 함께 보이도록 합니다.
