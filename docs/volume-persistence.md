# Docker 볼륨 영속성

## 볼륨 정보

- 볼륨 이름: `e1-1-data`
- 마운트 경로: `/data`

## 첫 번째 컨테이너

- 컨테이너 이름:
- 생성한 파일:
- 저장한 데이터:
- 확인 결과:

## 컨테이너 삭제

```bash
docker rm -f e1-1-volume-1
```

## 두 번째 컨테이너

- 동일 볼륨 연결 여부:
- 기존 파일 확인 결과:

## 결론

컨테이너의 수명 주기와 Docker 볼륨의 수명 주기가 어떻게 다른지 설명합니다.

## 증거

- `docs/logs/volume-persistence.txt`
- `docs/screenshots/volume/`
