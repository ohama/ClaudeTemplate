# Skills 가이드

`.claude/skills/` 디렉토리는 언어/프레임워크/방법론별 **전문가 지침**을 정의합니다.

Claude가 특정 기술 스택으로 작업할 때 해당 skill이 자동으로 적용됩니다.

---

## 현재 Skills 목록

### 언어/프레임워크

| Skill | 파일 | 활성화 조건 |
|-------|------|-------------|
| F# Expert | `fsharp.md` | `*.fs`, `*.fsx`, `*.fsproj` 파일 작업 시 |

### 방법론

| Skill | 파일 | 활성화 조건 |
|-------|------|-------------|
| TDD | `tdd.md` | `/tdd` 명령, 테스트 작성 시 |
| Git Workflow | `git.md` | `/commit`, Git 작업 시 |
| Property Testing | `property-testing.md` | 랜덤 테스트, fuzzing 작업 시 |
| Debugging | `debugging.md` | 버그 수정, 문제 해결 시 |
| Code Review | `code-review.md` | PR 리뷰, 코드 검토 시 |

### 운영/자동화

| Skill | 파일 | 활성화 조건 |
|-------|------|-------------|
| Structured Logging | `logging.md` | 로깅 코드 작성 시 |
| CI/CD | `cicd.md` | 파이프라인 설정 시 |

### 메타 Skills

| Skill | 파일 | 활성화 조건 |
|-------|------|-------------|
| History | `claude-behavior/history.md` | `/historyupdate`, `/endsession` 시 |
| Build Issues | `claude-behavior/build-issues.md` | 빌드/테스트 에러 발생 시 (자동) |

---

## Skill 분류

```
skills/
├── 언어/프레임워크
│   └── fsharp.md          # F# 전문가 (14KB)
│
├── 방법론
│   ├── tdd.md             # TDD (1KB)
│   ├── git.md             # Git Workflow (5KB)
│   ├── property-testing.md # Property-Based Testing (6KB)
│   ├── debugging.md       # 디버깅 (7KB)
│   └── code-review.md     # 코드 리뷰 (7KB)
│
├── 운영/자동화
│   ├── logging.md         # 구조화 로깅 (8KB)
│   └── cicd.md            # CI/CD (8KB)
│
└── 메타
    └── claude-behavior/
        ├── history.md       # 히스토리 관리
        └── build-issues.md  # 빌드 에러 자동 기록
```

---

## Skill 상세

### `fsharp.md` - F# Expert

| 항목 | 내용 |
|------|------|
| ROP | Railway Oriented Programming 패턴 |
| 테스트 | Expecto + FsCheck |
| 로깅 | Serilog |
| 타입 | Discriminated Union, Record, Option, Result |

### `tdd.md` - TDD

| 항목 | 내용 |
|------|------|
| 사이클 | Red → Green → Refactor |
| 규칙 | 테스트 먼저, 하나씩, 최소 구현 |
| 안티패턴 | 테스트 나중에, 과도한 구현 |

### `git.md` - Git Workflow

| 항목 | 내용 |
|------|------|
| Conventional Commits | feat, fix, docs, style, refactor, perf, test, chore, ci |
| 브랜치 전략 | Trunk-based, GitFlow |
| AFTER 원칙 | Atomic, Frequent, Test, Enforce, Refactoring |

### `property-testing.md` - Property Testing

| 항목 | 내용 |
|------|------|
| Property 유형 | Roundtrip, Invariant, Idempotent, Metamorphic, Oracle |
| Shrinking | 실패 입력 최소화 |
| 도구 | Hypothesis, FsCheck, proptest, fast-check |

### `debugging.md` - Debugging

| 항목 | 내용 |
|------|------|
| 7단계 | Reproduce → Isolate → Hypothesize → Test → Fix → Verify → Document |
| 기법 | Binary Search, 5 Whys, Conditional Breakpoints |

### `code-review.md` - Code Review

| 항목 | 내용 |
|------|------|
| 8대 체크 | Functionality, Readability, Security, Performance, Error Handling, Testing, Standards, Architecture |
| PR 크기 | 200-400 LOC 권장 |
| 피드백 | [MUST], [SHOULD], [NIT], [QUESTION] |

### `logging.md` - Structured Logging

| 항목 | 내용 |
|------|------|
| 형식 | JSON 구조화 로그 |
| 추적 | Correlation ID |
| 레벨 | DEBUG, INFO, WARN, ERROR, FATAL |
| 표준 | OpenTelemetry Semantic Conventions |

### `cicd.md` - CI/CD

| 항목 | 내용 |
|------|------|
| 파이프라인 | Checkout → Install → Lint → Build → Test → Deploy |
| Git Hooks | pre-commit, commit-msg |
| 배포 전략 | Rolling, Blue-Green, Canary |

---

## 포함 내용

각 Skill 파일에는 다음 섹션이 포함됩니다:

| 섹션 | 설명 |
|------|------|
| **활성화 조건** | 언제 이 skill을 적용할지 |
| **핵심 원칙** | 코딩 스타일, 패턴, 철학 |
| **코드 예시** | 좋은 예 / 나쁜 예 |
| **권장 도구** | 라이브러리, 프레임워크 |
| **피해야 할 패턴** | 안티패턴 |
| **참고** | 외부 링크 |

---

## 파일 vs 디렉토리

Skills는 **단일 파일** 또는 **디렉토리** 형태로 구성할 수 있습니다.

| 형태 | 예시 | 용도 |
|------|------|------|
| **단일 파일** | `fsharp.md` | 간단한 skill |
| **디렉토리** | `claude-behavior/` | 복잡한 skill, 주제별 분리 |

### 디렉토리 방식 예시

```
skills/
└── react/                 # 디렉토리 방식
    ├── README.md          # 개요 및 핵심 원칙
    ├── hooks.md           # React Hooks 가이드
    ├── state.md           # 상태 관리
    └── testing.md         # 테스트 전략
```

### 언제 디렉토리 방식을 사용하나?

- 내용이 **500줄 이상**인 경우
- **여러 하위 주제**가 있는 경우
- **팀원별로 다른 부분**을 관리해야 할 때

---

## 새 Skill 추가하기

### 1. 파일 생성

```bash
# 단일 파일
touch .claude/skills/golang.md

# 디렉토리
mkdir -p .claude/skills/nextjs
touch .claude/skills/nextjs/README.md
```

### 2. 템플릿 작성

```markdown
# [언어/프레임워크] Expert

[간단한 설명]

## 활성화 조건

- 파일 확장자: `*.xx`, `*.yy`
- 특정 컨텍스트

## 핵심 원칙

### [원칙 1]
- 설명

### [원칙 2]
- 설명

## 코드 스타일

```[lang]
// 좋은 예
...

// 나쁜 예
...
```

## 피해야 할 패턴

- 패턴 1
- 패턴 2

## 권장 도구

| 용도 | 도구 |
|------|------|
| 테스트 | ... |
| 로깅 | ... |

## 참고

- [링크](url)
```

### 3. 관련 Command에서 참조

```markdown
# commands/mycommand.md

## 참조
- `.claude/skills/newskill.md`
```

---

## Commands와의 관계

| 구분 | Commands | Skills |
|------|----------|--------|
| 호출 | 사용자가 `/명령어` 실행 | 자동 활성화 |
| 목적 | 워크플로우 실행 | 전문 지식 적용 |
| 구조 | 절차적 (단계별) | 선언적 (원칙, 패턴) |

**연결:**
```
/commit 실행
    │
    ├─ commands/commit.md 절차 수행
    │
    └─ skills/git.md 규칙 적용
           │
           └─ Conventional Commits 형식
           └─ AFTER 원칙
           └─ 브랜치 전략
```
