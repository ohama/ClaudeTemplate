# Commands 가이드

`.claude/commands/` 디렉토리는 사용자가 `/명령어` 형태로 호출하는 커스텀 명령어를 정의합니다.

---

## 명령어 목록

### 세션 관리

| 명령어 | 설명 | 관련 Skills |
|--------|------|-------------|
| `/startsession` | 작업 세션 시작, 컨텍스트 로드 | tdd, git, debugging |
| `/endsession` | 세션 종료, 상태 저장 | claude-behavior/history |
| `/status` | 현재 상태 확인 | - |

### Step/Phase 관리

| 명령어 | 설명 | 관련 Skills |
|--------|------|-------------|
| `/nextstep` | 다음 Step 시작 | - |
| `/nextstep "목표"` | 새 목표로 Step 생성 | - |
| `/endstep` | 현재 Step 완료 | - |
| `/phase status` | Phase 진행 상태 | - |
| `/phase complete` | 현재 Phase 완료 | - |
| `/phase next` | 다음 Phase 시작 | - |
| `/nextphase` | 다음 Phase 자동 실행 | - |
| `/nextphase --confirm` | 다음 Phase 실행 (각 Step 후 확인) | - |
| `/phase run` | 모든 Phase 자동 실행 | - |
| `/phase run --confirm` | 모든 Phase 실행 (각 Step 후 확인) | - |

### 개발

| 명령어 | 설명 | 관련 Skills |
|--------|------|-------------|
| `/tdd` | TDD 사이클 실행 | tdd, property-testing |
| `/commit` | 스마트 커밋 | git |

### 지식 관리

| 명령어 | 설명 | 관련 Skills |
|--------|------|-------------|
| `/flush` | CACHE → knowledge 정리 | - |
| `/issue` | 이슈 기록 | - |
| `/issue build` | 빌드 이슈 기록 (해결 여부에 따라 분류) | - |
| `/issue resolve <id>` | 이슈 해결 | - |
| `/historyupdate` | HISTORY.md 업데이트 | claude-behavior/history |
| `/logprompts` | 세션 로그 저장 | - |

### 릴리스

| 명령어 | 설명 | 관련 Skills |
|--------|------|-------------|
| `/release` | 버전 업그레이드 + CHANGELOG | git |
| `/howto` | 튜토리얼 문서 생성 | - |
| `/plan` | 프로젝트 진행 상황 | - |

---

## 명령어 구조

각 명령어 파일은 다음 구조를 따릅니다:

```markdown
# 명령어이름

설명

## 참조 (선택)
- 관련 skill 파일 링크

## 사용자 입력 (선택)
$ARGUMENTS - 설명

## 절차/실행
1. 단계 1
2. 단계 2
...

## 규칙
- 규칙 1
- 규칙 2
```

---

## 새 명령어 추가하기

### 1. 파일 생성

```bash
touch .claude/commands/mycommand.md
```

### 2. 템플릿 작성

```markdown
# mycommand

이 명령어의 설명

## 참조

- `.claude/skills/관련skill.md` (있는 경우)

## 사용자 입력

$ARGUMENTS - 인자 설명 (선택사항)

## 절차

1. 첫 번째 단계
2. 두 번째 단계
3. 세 번째 단계

## 규칙

- 규칙 1
- 규칙 2

## 완료 후

- 업데이트할 파일들
```

### 3. 사용

```
/mycommand
/mycommand 인자값
```

---

## 명령어 vs Skills

| 구분 | Commands | Skills |
|------|----------|--------|
| 호출 | 사용자가 명시적으로 `/명령어` | 자동 활성화 (컨텍스트 기반) |
| 목적 | 워크플로우 실행 | 전문 지식 적용 |
| 구조 | 절차적 (단계별) | 선언적 (원칙, 패턴) |
| 예시 | `/commit`, `/tdd` | `git.md`, `tdd.md` |

**관계:**
- 명령어는 관련 skill을 **참조**함
- 명령어 실행 시 skill의 원칙을 **적용**함

```
/commit 실행
    │
    ├─ commands/commit.md 의 절차 수행
    │
    └─ skills/git.md 의 Conventional Commits 규칙 적용
```

---

## 워크플로우 예시

### 기본 작업 흐름

```
/startsession
    ↓
/nextstep "기능 구현"
    ↓
/tdd (반복)
    ↓
/endstep
    ↓
/commit
    ↓
/endsession
```

### Phase 전환

```
/phase status
    ↓
/phase complete
    ↓
/phase next
```

### 릴리스

```
/commit
    ↓
/release
    ↓
git push && git push --tags
```
