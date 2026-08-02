# 포트 매핑 및 바인드 마운트

## 선택한 포트

- `HOST_PORT`:
- 선택 이유 또는 충돌 여부:

## 포트 매핑

```bash
docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0
```

- `docker port` 결과:
- `mac curl` 결과:
- 브라우저 주소:
- 증거: `docs/screenshots/port-mapping/`

## 바인드 마운트

```bash
docker run -d \
  --name e1-1-bind \
  -p "127.0.0.1:${HOST_PORT}:80" \
  -v "$PWD/bind-test:/usr/share/nginx/html:ro" \
  nginx:alpine
```

- 변경 전 응답:
- 호스트 파일 변경 내용:
- 변경 후 응답:
- 컨테이너 재시작 여부: 없음
- 증거: `docs/screenshots/bind-mount/`
