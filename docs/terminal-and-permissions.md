# 터미널 및 권한 실습

> 아래 명령을 실제로 실행하고 출력 결과를 기록합니다. `bash scripts/ubuntu/collect-evidence.sh`를 사용하면 기본 로그를 생성할 수 있지만, 결과 해석은 본인이 작성해야 합니다.

## 1. 터미널 기본 명령

```bash
{
  cd "$(git rev-parse --show-toplevel)"
  mkdir -p practice/terminal
  cd practice/terminal

  echo '$ pwd'
  pwd
  echo '$ ls'
  ls
  echo '$ ls -la'
  ls -la
  echo '$ touch sample.txt'
  touch sample.txt
  echo '$ echo "Codyssey E1-1" > sample.txt'
  echo 'Codyssey E1-1' > sample.txt
  echo '$ cat sample.txt'
  cat sample.txt
  echo '$ cp sample.txt sample-copy.txt'
  cp sample.txt sample-copy.txt
  echo '$ mv sample-copy.txt renamed.txt'
  mv sample-copy.txt renamed.txt
  echo '$ mkdir -p archive'
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
} 2>&1 | tee docs/logs/terminal-basic.txt
```

실제 관찰:

- `pwd`:
- `ls -la`에서 확인한 파일:
- `cat sample.txt`:
- `cp`와 `mv`의 차이:
- `rm`과 `rmdir`의 차이:

## 2. 절대 경로와 상대 경로

- 절대 경로 정의:
- 상대 경로 정의:
- 현재 저장소의 절대 경로:
- `practice/terminal/sample.txt`의 상대 경로:
- 실제 사용 예시:

확인 명령:

```bash
pwd
realpath practice/terminal/sample.txt
ls -l practice/terminal/sample.txt
```

## 3. 파일 권한 변경

```bash
{
  cd "$(git rev-parse --show-toplevel)/practice/permissions"
  touch permission-file.txt

  echo '$ ls -l permission-file.txt'
  ls -l permission-file.txt
  echo '$ chmod 644 permission-file.txt'
  chmod 644 permission-file.txt
  ls -l permission-file.txt
  echo '$ chmod 600 permission-file.txt'
  chmod 600 permission-file.txt
  ls -l permission-file.txt
} 2>&1 | tee docs/logs/permissions.txt
```

- 변경 전:
- `644` 변경 후:
- `600` 변경 후:
- 읽기·쓰기 권한 차이:

## 4. 디렉터리 권한 변경

`permissions.txt`에 이어서 기록하려면 `tee -a`를 사용합니다.

```bash
{
  cd "$(git rev-parse --show-toplevel)/practice/permissions"
  mkdir -p permission-dir

  echo '$ ls -ld permission-dir'
  ls -ld permission-dir
  echo '$ chmod 755 permission-dir'
  chmod 755 permission-dir
  ls -ld permission-dir
  echo '$ chmod 700 permission-dir'
  chmod 700 permission-dir
  ls -ld permission-dir
} 2>&1 | tee -a docs/logs/permissions.txt
```

- 변경 전:
- `755` 변경 후:
- `700` 변경 후:
- 디렉터리에서 실행 권한 `x`의 의미:

## 5. 권한 해석

| 숫자 | 소유자 | 그룹 | 기타 |
|---|---|---|---|
| `755` | `rwx` | `r-x` | `r-x` |
| `700` | `rwx` | `---` | `---` |
| `644` | `rw-` | `r--` | `r--` |
| `600` | `rw-` | `---` | `---` |

- `r = 4`, `w = 2`, `x = 1`
- `755 = 7/5/5 = rwx/r-x/r-x`
- `644 = 6/4/4 = rw-/r--/r--`

## 6. 증거

- `docs/logs/terminal-basic.txt`
- `docs/logs/permissions.txt`
- `docs/screenshots/terminal/`
- `docs/screenshots/permissions/`

화면에는 명령과 변경 전후 출력이 함께 보여야 합니다. 실제 로그를 확인한 뒤에만 `docs/evidence-index.md`의 상태를 변경합니다.
