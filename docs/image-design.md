# 커스텀 이미지 설계

> 아래 내용은 현재 `Dockerfile`의 설계 설명입니다. 빌드 성공 여부, 이미지 ID와 실행 결과는 실제 수행 후 기록합니다.

## 1. 선택한 베이스 이미지

- 태그: `nginx:1.30.4-alpine3.24`
- 실제 Dockerfile 참조: `nginx:1.30.4-alpine3.24@sha256:97d490c12ba55b4946b01546d1c3ed324e8d41ab1c9fcb2a616aa470620e5b46`
- digest 유형: Docker Official Image의 multi-platform index digest
- 공식 이미지: Docker Official Image `nginx`
- 선택 이유:
  1. 정적 웹 콘텐츠를 서비스하는 목적에 맞는 NGINX가 포함되어 있음
  2. Alpine 기반으로 이미지 크기가 비교적 작음
  3. `nginx:alpine` 같은 이동 태그 대신 NGINX와 Alpine 버전을 명시함
  4. multi-platform index digest를 함께 고정해 macOS와 Windows·WSL의 서로 다른 CPU 환경에서도 같은 이미지 릴리스를 선택하도록 함

공식 태그와 digest는 Docker Hub의 `nginx` 공식 이미지 페이지에서 확인합니다.

## 2. 적용한 커스텀 포인트

1. `LABEL org.opencontainers.image.title`: 이미지 이름과 목적 식별
2. `LABEL org.opencontainers.image.description`: 이미지 설명 기록
3. `LABEL org.opencontainers.image.source`: 원본 GitHub 저장소 연결
4. `COPY site/ /usr/share/nginx/html/`: 직접 작성한 정적 웹 콘텐츠 포함
5. `EXPOSE 80`: 컨테이너가 사용하는 HTTP 포트 문서화

`EXPOSE 80`만으로 호스트 포트가 열리는 것은 아닙니다. 실행할 때 `-p "127.0.0.1:${HOST_PORT}:80"` 포트 매핑을 별도로 지정합니다.

## 3. Dockerfile

```dockerfile
FROM nginx:1.30.4-alpine3.24@sha256:97d490c12ba55b4946b01546d1c3ed324e8d41ab1c9fcb2a616aa470620e5b46

LABEL org.opencontainers.image.title="codyssey-e1-1-web"
LABEL org.opencontainers.image.description="Codyssey E1-1 custom NGINX web server"
LABEL org.opencontainers.image.source="https://github.com/gahyun1004/codyssey-training-e1-1"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
```

원본: [`../Dockerfile`](../Dockerfile)

## 4. 빌드

```bash
{
  echo '$ docker build --pull -t codyssey-e1-1-web:1.0 .'
  docker build --pull -t codyssey-e1-1-web:1.0 .
  echo '$ docker image inspect codyssey-e1-1-web:1.0'
  docker image inspect codyssey-e1-1-web:1.0 \
    --format 'ID={{.Id}} CREATED={{.Created}} SIZE={{.Size}}'
} 2>&1 | tee docs/logs/docker-build.txt
```

## 5. 실행과 HTTP 확인

```bash
HOST_PORT="$(bash scripts/ubuntu/select-port.sh)"

docker rm -f e1-1-web 2>/dev/null || true
docker run -d \
  --name e1-1-web \
  -p "127.0.0.1:${HOST_PORT}:80" \
  codyssey-e1-1-web:1.0

curl -fsS "http://localhost:${HOST_PORT}"
```

## 6. digest 유지 관리

이미지 버전을 변경할 때는 태그와 digest를 함께 갱신합니다.

1. Docker Hub에서 새 공식 태그와 multi-platform index digest 확인
2. `Dockerfile` 수정
3. `scripts/ci/check-dockerfile.sh`의 기대값 수정
4. 이 문서의 태그·digest 수정
5. clean clone과 GitHub Actions build·HTTP 검증

태그는 같더라도 digest가 달라졌다면 임의로 교체하지 말고 변경 이유와 검증 결과를 커밋에 남깁니다.

## 7. 실제 결과 기록

- 수행 날짜:
- 수행 환경:
- Git commit SHA:
- 이미지 빌드: 성공 / 실패
- 이미지 ID:
- 이미지 크기:
- 컨테이너 실행: 성공 / 실패
- 선택한 호스트 포트:
- HTTP 응답 핵심 문구:
- 빌드 로그: `docs/logs/docker-build.txt`
- 화면 증거: `docs/screenshots/docker/`, `docs/screenshots/port-mapping/`
