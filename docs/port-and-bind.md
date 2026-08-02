# 포트 매핑 및 바인드 마운트

> 실제 실행 결과를 기록하는 문서입니다. 아래 명령은 WSL2 Ubuntu와 OrbStack Ubuntu에서 공통으로 사용할 수 있습니다.

## 1. 사용 가능한 포트 선택

```bash
HOST_PORT="$(scripts/ubuntu/select-port.sh)"
printf 'HOST_PORT=%s\n' "$HOST_PORT"
printf 'HOST_PORT=%s\n' "$HOST_PORT" > .env.local
```

`select-port.sh`는 다음 항목을 확인합니다.

- Ubuntu·WSL의 `ss`
- `lsof`가 설치된 경우 Linux 수신 포트
- OrbStack의 `mac lsof`
- Docker가 게시한 포트

- 선택한 `HOST_PORT`:
- 충돌 여부와 선택 이유:

## 2. 포트 매핑

```bash
source .env.local

docker rm -f e1-1-web 2>/dev/null || true
docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0

{
  echo '$ docker ps --filter name=e1-1-web'
  docker ps --filter name=e1-1-web
  echo '$ docker port e1-1-web'
  docker port e1-1-web
  echo '$ docker logs e1-1-web'
  docker logs e1-1-web
  echo '$ curl -fsS http://localhost:'"$HOST_PORT"
  curl -fsS "http://localhost:${HOST_PORT}"
} 2>&1 | tee docs/logs/port-mapping.txt
```

확인 항목:

- WSL·Ubuntu `curl` 결과:
- Windows 브라우저 결과:
- OrbStack에서 수행한 경우 Mac 호스트 브라우저 또는 `curl` 결과:
- 브라우저 주소: `http://localhost:<HOST_PORT>`
- 주소창과 페이지가 함께 보이는 화면: `docs/screenshots/port-mapping/`

## 3. 바인드 마운트 최초 응답

```bash
source .env.local
docker rm -f e1-1-web e1-1-bind 2>/dev/null || true

docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:${HOST_PORT}:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:1.30.4-alpine3.24

curl -fsS "http://localhost:${HOST_PORT}"
```

- 변경 전 응답:

## 4. 호스트 파일 변경 후 재확인

`bind-test/index.html`의 제목 또는 본문을 수정합니다. 컨테이너를 재시작하지 않은 상태에서 다시 확인합니다.

```bash
{
  echo '$ docker inspect e1-1-bind --format mount'
  docker inspect e1-1-bind \
    --format '{{range .Mounts}}{{.Type}} {{.Source}} -> {{.Destination}}{{println}}{{end}}'
  echo '$ curl -fsS http://localhost:'"$HOST_PORT"
  curl -fsS "http://localhost:${HOST_PORT}"
} 2>&1 | tee docs/logs/bind-mount-after.txt
```

- 호스트 파일 변경 내용:
- 변경 후 응답:
- 컨테이너 재시작 여부: 없음
- 변경 반영 결론:
- 증거: `docs/screenshots/bind-mount/`

## 5. 정리

```bash
docker rm -f e1-1-bind
```

`.env.local`은 로컬 포트 기록용이며 `.gitignore` 대상이므로 커밋하지 않습니다.
