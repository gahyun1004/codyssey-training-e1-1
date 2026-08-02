# Docker 볼륨 영속성

> 컨테이너를 삭제해도 Docker 볼륨의 데이터가 유지되는지 실제로 검증하고 결과를 기록합니다.

## 1. 볼륨 정보

- 볼륨 이름: `e1-1-data`
- 컨테이너 마운트 경로: `/data`

## 2. 첫 번째 컨테이너에서 데이터 생성

```bash
{
  echo '$ docker volume create e1-1-data'
  docker volume create e1-1-data

  echo '$ docker volume inspect e1-1-data'
  docker volume inspect e1-1-data

  echo '$ docker run first container'
  docker rm -f e1-1-volume-1 2>/dev/null || true
  docker run -d \
    --name e1-1-volume-1 \
    -v e1-1-data:/data \
    ubuntu:24.04 \
    sleep infinity

  echo '$ create /data/result.txt'
  docker exec e1-1-volume-1 \
    bash -lc 'echo "persistent data" > /data/result.txt; cat /data/result.txt'

  echo '$ docker inspect mount'
  docker inspect e1-1-volume-1 \
    --format '{{range .Mounts}}{{.Type}} {{.Name}} -> {{.Destination}}{{println}}{{end}}'

  echo '$ delete first container'
  docker rm -f e1-1-volume-1

  echo '$ docker volume ls'
  docker volume ls --filter name=e1-1-data

  echo '$ run second container with same volume'
  docker rm -f e1-1-volume-2 2>/dev/null || true
  docker run -d \
    --name e1-1-volume-2 \
    -v e1-1-data:/data \
    ubuntu:24.04 \
    sleep infinity

  echo '$ read existing data'
  docker exec e1-1-volume-2 cat /data/result.txt
} 2>&1 | tee docs/logs/volume-persistence.txt
```

마지막 명령에서 다음 문구가 출력되어야 합니다.

```text
persistent data
```

## 3. 실제 결과

### 첫 번째 컨테이너

- 컨테이너 이름: `e1-1-volume-1`
- 생성한 파일: `/data/result.txt`
- 저장한 데이터:
- 파일 확인 결과:

### 컨테이너 삭제

- 삭제 명령 결과:
- 삭제 후 볼륨 존재 여부:

### 두 번째 컨테이너

- 컨테이너 이름: `e1-1-volume-2`
- 동일 볼륨 연결 여부:
- 기존 파일 확인 결과:

## 4. 결론

- 컨테이너 수명 주기:
- Docker 볼륨 수명 주기:
- 컨테이너 삭제 후에도 데이터가 유지된 이유:

## 5. 증거

- 로그: `docs/logs/volume-persistence.txt`
- 스크린샷: `docs/screenshots/volume/`

화면에는 첫 번째 컨테이너의 데이터 생성, 컨테이너 삭제, 두 번째 컨테이너의 동일 데이터 출력이 확인되어야 합니다.

## 6. 정리

평가용 증거를 저장한 뒤에만 정리합니다.

```bash
docker rm -f e1-1-volume-2 2>/dev/null || true
docker volume rm e1-1-data
```
