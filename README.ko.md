# Claude Code Project Template

Claude Code를 사용한 대형 프로젝트 개발을 위한 템플릿입니다.

## 특징

- **TDD 기반 개발**: Red → Green → Refactor 사이클
- **Phase > Step 워크플로우**: 체계적인 작업 분할 및 진행 관리
- **지식 관리**: 발견 사항, 결정 사항, 패턴 등을 문서화
- **커스텀 Commands**: 반복 작업 자동화
- **Skills**: 언어/프레임워크별 전문가 지침

---

## 시작하기

### 1. 템플릿 복사

```bash
cp -r MyTemplate /path/to/your/project/.claude
```

또는 새 프로젝트에서:

```bash
git clone <this-repo> my-project
cd my-project
rm -rf .git
git init
```

### 2. 프로젝트 설정

1. `.claude/PLAN.md` - 프로젝트 목표와 Phase/Step 계획 작성
2. `.claude/knowledge/ARCHITECTURE.md` - 프로젝트 구조 정의
3. `.claude/knowledge/BUILD.md` - 빌드 명령어 설정

### 3. 작업 시작

```
/startsession
```

---

## 디렉토리 구조

```
.claude/
├── PLAN.md              # Phase > Step 구조의 프로젝트 계획
├── STATE.md             # 현재 진행 상태
├── CACHE.md             # 임시 발견 사항
├── HISTORY.md           # 주요 결정/전환점 요약
├── DECISIONS.md         # 기술적 결정 기록
├── README.md            # .claude 디렉토리 가이드
├── USAGE.md             # 커맨드 사용 시나리오
│
├── commands/            # 커스텀 커맨드
│   ├── startsession.md  # 세션 시작
│   ├── endsession.md    # 세션 종료
│   ├── nextstep.md      # 새 Step 시작
│   ├── endstep.md       # Step 완료
│   ├── tdd.md           # TDD 사이클
│   ├── phase.md         # Phase 관리
│   ├── status.md        # 상태 확인
│   ├── issue.md         # 이슈 관리
│   ├── flush.md         # 캐시 정리
│   ├── commit.md        # 스마트 커밋
│   ├── release.md       # 릴리스
│   └── ...
│
├── skills/              # 언어/프레임워크 전문가
│   └── fsharp.md        # F# 전문가 (ROP, Expecto, Serilog)
│
├── knowledge/           # 프로젝트 지식
│   ├── ARCHITECTURE.md  # 프로젝트 구조
│   ├── BUILD.md         # 빌드 가이드
│   ├── TESTING.md       # 테스트 가이드
│   ├── TDD.md           # TDD 사이클
│   ├── PATTERNS.md      # 코드 패턴
│   └── RULES.md         # 개발 규칙
│
└── prompts/             # 재사용 프롬프트
    ├── prompt-logger.md
    └── history-summarizer.md

docs/
├── spec/                # 스펙 문서
└── issues/              # 이슈 기록
```

---

## 워크플로우

### 기본 작업 흐름

```
/startsession → /nextstep → /tdd (반복) → /endstep → /endsession
```

### Phase 전환

```
/phase status → /phase complete → /phase next
```

### 작업 구조

```
Phase 1: (Phase 이름)
  └─ Step 1.1: (Step 이름)     ← 1~2시간 분량
  └─ Step 1.2: (Step 이름)
  └─ Step 1.3: (Step 이름)
Phase 2: (Phase 이름)
  └─ Step 2.1: (Step 이름)
```

---

## 커맨드 목록

### 세션 관리

| 커맨드 | 설명 |
|--------|------|
| `/startsession` | 작업 세션 시작, 컨텍스트 로드 |
| `/endsession` | 세션 종료, 상태 저장 |
| `/status` | 현재 상태 확인 |

### Step 관리

| 커맨드 | 설명 |
|--------|------|
| `/nextstep` | 다음 Step 시작 |
| `/nextstep "목표"` | 새 목표로 Step 생성 |
| `/endstep` | 현재 Step 완료 |
| `/tdd` | TDD 사이클 실행 |

### Phase 관리

| 커맨드 | 설명 |
|--------|------|
| `/phase status` | Phase 진행 상태 |
| `/phase complete` | 현재 Phase 완료 |
| `/phase next` | 다음 Phase 시작 |

### 지식 관리

| 커맨드 | 설명 |
|--------|------|
| `/flush` | CACHE → knowledge 파일로 정리 |
| `/issue` | 이슈 기록 |
| `/issue resolve <id>` | 이슈 해결 |

### 릴리스

| 커맨드 | 설명 |
|--------|------|
| `/commit` | 스마트 커밋 (gitignore + 그룹 커밋) |
| `/release` | 버전 업그레이드 + CHANGELOG |
| `/howto` | 튜토리얼 문서 생성 |

---

## CACHE와 지식 관리

### CACHE란?

`.claude/CACHE.md`는 작업 중 발견한 임시 정보를 저장하는 파일입니다.

**누가 기록하나?**
- **Claude가 자동으로** 작업 중 발견한 사항을 기록
- **사용자 요청으로** "이거 CACHE에 기록해줘"라고 하면 기록

**언제 기록하나?**
- 코드 작업 중 새로운 패턴 발견 시
- 빌드/테스트 실행 후 특이사항 발견 시
- 프로젝트 규칙이나 제약 발견 시
- 나중에 정리할 TODO 발견 시

**용도**:
- 작업 중 발견한 사항 (버그, 개선점, 특이사항)
- 나중에 정리할 메모
- TODO 항목

**구조**:
```markdown
# CACHE

**Status**: CLEAN | DIRTY

---

## 발견 사항
- 빌드 시 --release 플래그 필요
- API 응답 시간이 느림

## 메모
- 리팩토링 아이디어

## TODO (나중에 처리)
- 문서 업데이트
```

**Status**:
- `CLEAN`: 정리할 내용 없음
- `DIRTY`: `/flush` 필요

### /flush 커맨드

CACHE에 쌓인 내용을 적절한 knowledge 파일로 분류하여 이동합니다.

**동작 방식**:

```
CACHE.md (DIRTY)
    │
    ├─ 빌드 관련 ──────→ knowledge/BUILD.md
    ├─ 테스트 관련 ────→ knowledge/TESTING.md
    ├─ TDD 관련 ───────→ knowledge/TDD.md
    ├─ 코드 패턴 ──────→ knowledge/PATTERNS.md
    └─ 규칙/제약 ──────→ knowledge/RULES.md
    │
    ▼
CACHE.md (CLEAN)
```

**사용 시점**:
- 세션 종료 전 (`/endsession` 전에)
- CACHE가 많이 쌓였을 때
- Step 완료 후

**예시**:
```
User: /flush

Claude: CACHE 상태: DIRTY (5개 항목)

분류 결과:
- BUILD.md로 이동: 2개
  - "dotnet build --configuration Release 필요"
  - "환경변수 DOTNET_ROOT 설정 필요"
- PATTERNS.md로 이동: 2개
  - "Result 타입 체이닝 패턴"
  - "비동기 에러 처리 패턴"
- RULES.md로 이동: 1개
  - "public API는 XML 주석 필수"

CACHE 정리 완료. Status: CLEAN
```

### 왜 CACHE를 사용하는가?

1. **컨텍스트 유지**: 세션이 바뀌어도 발견 사항이 유실되지 않음
2. **지식 축적**: 프로젝트별 노하우가 knowledge 파일에 쌓임
3. **빠른 기록**: 작업 중단 없이 메모 가능
4. **체계적 정리**: `/flush`로 적절한 위치에 자동 분류

---

## TDD 워크플로우

### /tdd 커맨드

TDD (Test-Driven Development) 사이클을 실행합니다.

**사이클**:

```
┌─────────────────────────────────────────────────────┐
│                                                     │
│   ┌─────────┐     ┌─────────┐     ┌──────────┐     │
│   │   Red   │ ──→ │  Green  │ ──→ │ Refactor │     │
│   └─────────┘     └─────────┘     └──────────┘     │
│        │                               │           │
│        └───────────────────────────────┘           │
│                    반복                             │
└─────────────────────────────────────────────────────┘
```

### 1. Red - 실패하는 테스트 작성

```
목표: 테스트가 실패하는 것을 확인

- 구현하려는 기능에 대한 테스트를 먼저 작성
- 테스트 실행하여 실패 확인
- 실패 메시지가 예상대로인지 확인
```

**예시**:
```fsharp
[<Test>]
let ``should validate email format`` () =
    let result = validateEmail "invalid-email"
    Expect.isError result "Invalid email should fail"
```

### 2. Green - 최소한의 구현

```
목표: 테스트를 통과시키는 최소한의 코드 작성

- 완벽한 코드가 아니어도 됨
- 하드코딩도 허용
- 테스트 통과만 확인
```

**예시**:
```fsharp
let validateEmail email =
    if email.Contains("@") then Ok email
    else Error "Invalid email"
```

### 3. Refactor - 리팩토링

```
목표: 코드 품질 개선 (테스트는 계속 통과)

- 중복 제거
- 명확한 이름
- 구조 개선
- 테스트 여전히 통과 확인
```

**예시**:
```fsharp
let private isValidEmailFormat email =
    let emailRegex = Regex(@"^[^@\s]+@[^@\s]+\.[^@\s]+$")
    emailRegex.IsMatch(email)

let validateEmail email =
    if String.IsNullOrWhiteSpace(email) then
        Error EmptyEmail
    elif not (isValidEmailFormat email) then
        Error (InvalidEmailFormat email)
    else
        Ok email
```

### TDD 규칙

| 규칙 | 설명 |
|------|------|
| 테스트 먼저 | 테스트 없이 프로덕션 코드 작성 금지 |
| 하나씩 | 한 번에 하나의 테스트만 작성 |
| 버그 재현 | 버그 수정 시 재현 테스트부터 작성 |
| 리팩토링 집중 | 리팩토링 중에는 새 기능 추가 금지 |

### TDD 사용 예시

```
User: /tdd

Claude: 현재 Step: 1.2 - 이메일 검증

[Red] 테스트 작성:
- tests/ValidationTests.fs에 이메일 검증 테스트 추가
- 테스트 실행... 실패 ✓

[Green] 최소 구현:
- src/Validation.fs에 validateEmail 함수 추가
- 테스트 실행... 통과 ✓

[Refactor] 코드 개선:
- 정규식으로 검증 로직 개선
- 에러 타입 세분화
- 테스트 실행... 통과 ✓

STATE.md 업데이트 완료.
다음 테스트로 진행하시겠습니까?
```

---

## Skills

### F# Expert (`skills/fsharp.md`)

F# 프로젝트에서 자동 활성화되는 전문가 지침:

- **Railway Oriented Programming (ROP)**: 모든 에러 처리에 ROP 패턴 적용
- **Expecto + FsCheck**: 테스트 프레임워크
- **Serilog**: 구조화된 로깅

### 새 Skill 추가

`.claude/skills/` 디렉토리에 마크다운 파일 생성:

```markdown
# Skill Name

## 활성화 조건
- 파일 확장자: *.xx
- 특정 조건

## 핵심 원칙
...

## 코드 스타일
...
```

---

## 커스터마이징

### 새 Command 추가

`.claude/commands/` 디렉토리에 마크다운 파일 생성:

```markdown
# command-name

설명

## 사용법
/command-name [args]

## 절차
1. ...
2. ...

## 규칙
- ...
```

### Knowledge 파일 수정

`.claude/knowledge/` 파일들을 프로젝트에 맞게 수정:

- `ARCHITECTURE.md`: 프로젝트 구조
- `BUILD.md`: 빌드 명령어
- `TESTING.md`: 테스트 전략
- `PATTERNS.md`: 프로젝트 코드 패턴
- `RULES.md`: 팀 규칙

---

## 팁

1. **세션 시작/종료 필수**: 컨텍스트 유지를 위해 `/startsession`으로 시작, `/endsession`으로 종료

2. **Step 크기**: 1~2시간 내 완료 가능한 범위

3. **자주 flush**: CACHE가 쌓이면 `/flush`로 knowledge 파일에 정리

4. **이슈 즉시 기록**: 발견 즉시 `/issue`, 해결 즉시 `/issue resolve`

5. **커밋 전 `/commit`**: 자동으로 gitignore 관리 및 연관 파일 그룹 커밋

---

## 라이선스

MIT License
