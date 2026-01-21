# commit

변경된 파일들을 분석하여 필요없는 파일을 .gitignore에 추가하고, 연관성 있는 내용들끼리 묶어서 commit합니다.

## 사용자 입력

$ARGUMENTS - 커밋 메시지 접두사 (선택사항)

## 실행 단계

### 1. 현재 상태 확인

```bash
git status
git diff --stat
```

### 2. .gitignore 관리

변경/추가된 파일 중 다음 패턴에 해당하면 .gitignore에 추가 제안:

| 패턴 | 설명 |
|------|------|
| `node_modules/` | npm 패키지 |
| `*.log` | 로그 파일 |
| `.env*` | 환경 변수 (`.env.example` 제외) |
| `dist/`, `build/`, `out/` | 빌드 결과물 |
| `.DS_Store` | macOS 시스템 파일 |
| `Thumbs.db` | Windows 시스템 파일 |
| `*.pyc`, `__pycache__/` | Python 캐시 |
| `.idea/`, `.vscode/` | IDE 설정 (공유 설정 제외) |
| `*.swp`, `*.swo` | Vim 임시 파일 |
| `coverage/`, `.nyc_output/` | 테스트 커버리지 |
| `*.class`, `*.jar` | Java 컴파일 결과 |
| `vendor/` | 의존성 디렉토리 |
| `.cache/` | 캐시 디렉토리 |

**예외 (항상 커밋 허용)**:
- `.claude/` - Claude 설정 및 문서 디렉토리는 항상 커밋 대상

절차:
1. `git status --porcelain`으로 변경 파일 목록 확인
2. 위 패턴에 해당하는 파일 식별
3. .gitignore에 없는 패턴이면 AskUserQuestion으로 추가 여부 질문
4. 승인 시 .gitignore에 추가

### 3. 변경사항 분류

변경된 파일들을 다음 기준으로 그룹화:

| 그룹 | 기준 |
|------|------|
| feat | 새로운 기능 추가 (새 파일, 새 함수/클래스) |
| fix | 버그 수정 (기존 로직 변경) |
| docs | 문서 변경 (*.md, 주석) |
| style | 코드 스타일 (포맷팅, 세미콜론 등) |
| refactor | 리팩토링 (기능 변경 없는 코드 개선) |
| test | 테스트 관련 (*.test.*, *.spec.*) |
| chore | 빌드, 설정 변경 (package.json, config 등) |

분류 방법:
1. 파일 경로와 확장자로 1차 분류
2. `git diff` 내용으로 2차 분류 (새 함수 추가 vs 기존 수정)
3. 같은 디렉토리/모듈의 파일들은 함께 그룹화

### 4. 커밋 실행

각 그룹별로:
1. 해당 파일들을 staging (`git add`)
2. 커밋 메시지 생성:
   - 형식: `<type>: <description>`
   - $ARGUMENTS가 있으면 접두사로 사용
   - 예: `feat: add user authentication`
3. 커밋 메시지를 AskUserQuestion으로 확인/수정 기회 제공
4. 승인 시 커밋 실행

### 5. 결과 출력

```
## Commit Summary

### .gitignore 업데이트
- 추가됨: node_modules/, *.log

### 커밋 목록
1. feat: add user authentication (3 files)
2. fix: resolve login timeout issue (1 file)
3. docs: update README (1 file)

Total: 3 commits, 5 files changed
```

## 규칙

- 각 커밋 전에 사용자 확인 받기
- .gitignore 변경은 별도 커밋으로 먼저 처리
- 관련 없는 파일들은 묶지 않기
- 커밋 메시지는 한글 또는 영어로 일관되게 (프로젝트 기존 스타일 따르기)
- `Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>` 서명 포함
