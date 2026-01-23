# Claude Code Template - Skills 상세 설명

## 영상 스크립트 가이드 (15-20분)

---

## 1. Skills 개요 (2분)

### Skills란?
`.claude/skills/` 디렉토리에 정의된 **전문가 지침**입니다.
특정 기술 스택이나 방법론으로 작업할 때 **자동으로 활성화**됩니다.

### Commands vs Skills 차이

| 구분 | Commands | Skills |
|------|----------|--------|
| 호출 | `/명령어`로 직접 | 자동 활성화 |
| 목적 | 워크플로우 실행 | 전문 지식 적용 |
| 구조 | 절차적 (단계별) | 선언적 (원칙/패턴) |
| 예시 | `/commit`, `/tdd` | `git.md`, `tdd.md` |

### Skills 분류

```
skills/
├── 언어/프레임워크
│   └── fsharp.md          # F# 전문가
│
├── 방법론
│   ├── tdd.md             # TDD
│   ├── git.md             # Git Workflow
│   ├── property-testing.md # Property-Based Testing
│   ├── debugging.md       # 디버깅
│   └── code-review.md     # 코드 리뷰
│
├── 운영/자동화
│   ├── logging.md         # 구조화 로깅
│   └── cicd.md            # CI/CD
│
└── 메타
    └── claude-behavior/   # Claude 운영 방식
        ├── history.md     # 히스토리 관리
        └── build-issues.md # 빌드 에러 자동 기록
```

---

## 2. 방법론 Skills (8분)

### `tdd.md` - Test-Driven Development

**활성화 조건**: `/tdd` 명령, 테스트 작성 시

#### 기본 사이클

```
Red → Green → Refactor (반복)
 │      │        │
 │      │        └── 코드 개선 (테스트 유지)
 │      └── 최소 구현 (테스트 통과)
 └── 실패하는 테스트 작성
```

#### 상세 절차

**1. Red (실패하는 테스트)**
```javascript
// 먼저 테스트 작성
test("should add two numbers", () => {
    expect(add(1, 2)).toBe(3);
});
```
- 컴파일 에러도 "Red" 상태
- 실패 이유가 명확해야 함

**2. Green (최소 구현)**
```javascript
// 테스트 통과하는 최소 코드
function add(a, b) {
    return a + b;
}
```
- "최소"가 핵심 - 하드코딩도 OK
- 완벽한 코드가 아니어도 됨

**3. Refactor (개선)**
- 중복 제거
- 명확한 이름
- **테스트는 계속 통과해야 함**

#### 핵심 규칙
- 테스트 없이 프로덕션 코드 작성 금지
- 한 번에 하나의 테스트만
- 버그 수정은 재현 테스트부터
- 리팩토링 중 새 기능 추가 금지

#### 안티 패턴
- 테스트 나중에 추가
- 여러 테스트 한꺼번에 작성
- Green 단계에서 과도한 구현
- 리팩토링 건너뛰기

---

### `git.md` - Git Workflow Expert

**활성화 조건**: Git 작업, `/commit` 명령 시

#### Conventional Commits

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

| Type | 설명 | 예시 |
|------|------|------|
| `feat` | 새 기능 | `feat: add user auth` |
| `fix` | 버그 수정 | `fix: resolve timeout` |
| `docs` | 문서 | `docs: update README` |
| `refactor` | 리팩토링 | `refactor: extract logic` |
| `test` | 테스트 | `test: add unit tests` |
| `chore` | 설정/빌드 | `chore: update deps` |

#### 커밋 메시지 규칙
1. 제목 50자 이내
2. 명령형 사용: "Add feature" (O)
3. 마침표 없음
4. **Why** 설명 (무엇보다 왜)

#### 브랜치 전략

**Trunk-Based Development (권장)**:
```
main ─────●─────●─────●─────●─────
           \   /       \   /
feature-a   ●─●    feature-b
         (짧은 수명 1-2일)
```

#### AFTER 원칙

| 원칙 | 설명 |
|------|------|
| **A**tomic | 하나의 논리적 변경만 |
| **F**requent | 자주 커밋 |
| **T**est | 푸시 전 테스트 |
| **E**nforce | 표준 강제 (hooks) |
| **R**efactoring | 기능과 분리 |

---

### `debugging.md` - Debugging Expert

**활성화 조건**: 버그 수정, "에러", "버그" 언급 시

#### 7단계 디버깅 프레임워크

```
1. Reproduce → 2. Isolate → 3. Hypothesize
       ↓             ↓            ↓
    재현하기      격리하기     가설 세우기

4. Test → 5. Fix → 6. Verify → 7. Document
   ↓        ↓         ↓           ↓
테스트    수정하기   검증하기    문서화
```

**1. Reproduce (재현)**
- 버그를 100% 재현 가능하게
- 입력값, 환경, 순서, 빈도 기록

**2. Isolate (격리)**
- Binary Search Debugging
- 코드 절반씩 주석 처리
- 입력 단순화

**3. Hypothesize (가설)**
- 원인에 대한 가설 목록 작성
- 5 Whys 기법

**4. Test → Fix → Verify → Document**
- 가설 검증 → 최소 변경으로 수정
- 회귀 테스트 추가 → 문서화

#### 디버깅 기법

| 기법 | 용도 |
|------|------|
| Conditional Breakpoint | 특정 조건에서만 중단 |
| Print/Log Debugging | 실행 흐름 추적 |
| Rubber Duck Debugging | 문제를 소리내어 설명 |
| Git Bisect | 버그 도입 커밋 찾기 |

---

### `property-testing.md` - Property-Based Testing

**활성화 조건**: "edge case", "random testing", "fuzzing" 언급 시

#### Unit Test vs Property-Based Test

| 구분 | Unit Test | Property-Based Test |
|------|-----------|---------------------|
| 입력 | 직접 지정 | 자동 생성 (랜덤) |
| 검증 | 특정 출력값 | 속성 만족 확인 |
| 커버리지 | 예상 케이스 | 예상치 못한 케이스 |

```python
# Unit Test
def test_reverse_specific():
    assert reverse([1, 2, 3]) == [3, 2, 1]

# Property-Based Test
@given(lists(integers()))
def test_reverse_property(xs):
    assert reverse(reverse(xs)) == xs  # 두 번 뒤집으면 원본
```

#### Property 유형

| 유형 | 설명 | 예시 |
|------|------|------|
| **Roundtrip** | encode → decode = 원본 | 압축/해제 |
| **Invariant** | 변환 후에도 유지 | 정렬 후 길이 동일 |
| **Idempotent** | f(f(x)) = f(x) | 정렬을 두 번 해도 동일 |
| **Metamorphic** | 입력 변환 관계 | 덧셈 교환법칙 |
| **Oracle** | 참조 구현과 비교 | quicksort vs sorted |

#### Shrinking (축소)
```
실패 입력: [847, -32, 0, 999, ...]  (100개)
          ↓ shrinking
최소 입력: [0, -1]  (2개로 같은 버그 재현)
```

#### 언어별 도구
| 언어 | 라이브러리 |
|------|-----------|
| Python | Hypothesis |
| F# | FsCheck |
| Rust | proptest |
| JavaScript | fast-check |

---

### `code-review.md` - Code Review Expert

**활성화 조건**: PR 리뷰, "리뷰", "PR" 언급 시

#### 8대 리뷰 항목

| 항목 | 체크 포인트 |
|------|------------|
| **Functionality** | 요구사항 구현, 엣지 케이스 |
| **Readability** | 자기 설명적 코드, 명확한 이름 |
| **Security** | 입력 검증, SQL Injection 방지 |
| **Performance** | N+1 쿼리, 불필요한 루프 |
| **Error Handling** | 예외 처리, 리소스 정리 |
| **Testing** | 테스트 존재, 커버리지 |
| **Standards** | 코딩 스타일, 네이밍 컨벤션 |
| **Architecture** | 적절한 레이어, 의존성 방향 |

#### PR 크기 권장
- **200-400 LOC** (결함 발견율 최고)
- 큰 기능은 여러 PR로 분할

#### 피드백 형식

| 접두사 | 의미 |
|--------|------|
| `[MUST]` | 반드시 수정 (보안, 버그) |
| `[SHOULD]` | 강력 권장 (성능, 가독성) |
| `[NIT]` | 사소한 제안 |
| `[QUESTION]` | 이해 확인 |

---

## 3. 운영/자동화 Skills (3분)

### `logging.md` - Structured Logging

**활성화 조건**: 로깅 코드 작성 시

#### Unstructured vs Structured

```python
# Unstructured (나쁨) - 파싱 어려움
logger.info(f"User {user_id} logged in from {ip}")

# Structured (좋음) - 쉬운 쿼리
logger.info("User logged in", extra={
    "user_id": user_id,
    "ip": ip,
    "event": "login"
})
```

#### Log Levels

| Level | 용도 |
|-------|------|
| `DEBUG` | 개발 중 상세 정보 |
| `INFO` | 정상 동작 기록 |
| `WARN` | 잠재적 문제 |
| `ERROR` | 오류 발생 |
| `FATAL` | 시스템 중단 |

#### Correlation ID
분산 시스템에서 요청 추적을 위한 고유 ID

```json
{"message": "Order created", "correlation_id": "abc-123", "service": "order-api"}
{"message": "Payment processed", "correlation_id": "abc-123", "service": "payment-api"}
```

#### 로깅 규칙
- **로깅해야 하는 것**: 요청 시작/종료, 비즈니스 이벤트, 에러
- **로깅하면 안 되는 것**: 비밀번호, API 키, PII (마스킹 필요)

---

### `cicd.md` - CI/CD Expert

**활성화 조건**: 파이프라인 설정, "배포" 언급 시

#### 기본 파이프라인 단계

```yaml
1. Checkout     # 코드 체크아웃
2. Install      # 의존성 설치
3. Lint         # 코드 스타일 검사
4. Build        # 빌드
5. Test         # 테스트
6. Security     # 보안 스캔
7. Package      # 아티팩트 생성
8. Deploy       # 배포
```

#### 테스트 피라미드

```
        /\  E2E (느림, 비쌈)
       /--\
      /    \  Integration
     /------\
    /        \  Unit (빠름, 저렴)
   /____________\
```

#### 배포 전략

| 전략 | 설명 |
|------|------|
| **Rolling** | 점진적 교체 |
| **Blue-Green** | 두 환경 전환 |
| **Canary** | 일부 트래픽만 새 버전 |

#### Git Hooks 예시

```bash
# pre-commit
npm run lint && npm test

# commit-msg
npx commitlint --edit "$1"
```

---

## 4. 언어/프레임워크 Skills (3분)

### `fsharp.md` - F# Expert

**활성화 조건**: `*.fs`, `*.fsx`, `*.fsproj` 파일 작업 시

#### 핵심 원칙

**1. 함수형 프로그래밍 우선**
- 불변성(Immutability) 기본
- 순수 함수 선호
- 파이프라인 연산자 `|>` 활용

```fsharp
// 파이프라인 스타일
let processUsers users =
    users
    |> List.filter (fun u -> u.IsActive)
    |> List.map (fun u -> { u with LastSeen = DateTime.Now })
    |> List.sortBy (fun u -> u.Name)
```

**2. Railway Oriented Programming (ROP)**
- 모든 에러 처리는 ROP 패턴
- Result 타입으로 성공/실패 경로 분리
- 예외(Exception) 대신 Result 체이닝

```fsharp
// ROP 체이닝
let processOrder =
    validateOrder
    >=> checkInventory
    >=> calculateTotal
    >=> createInvoice
```

**3. 타입 시스템 활용**
```fsharp
// Discriminated Union
type PaymentMethod =
    | CreditCard of number: string * expiry: DateTime
    | BankTransfer of accountNumber: string
    | Cash
```

#### 권장 도구

| 용도 | 라이브러리 |
|------|-----------|
| 테스트 | **Expecto + FsCheck** |
| 로깅 | **Serilog** |
| JSON | Thoth.Json |
| HTTP | Giraffe |

#### 피해야 할 패턴
- `mutable` 키워드 남용
- `null` 직접 사용 (Option 사용)
- 예외 기반 흐름 제어 (Result 사용)

---

## 5. 메타 Skills (2분)

### `claude-behavior/` - Claude 운영 방식

일반 스킬이 "기술 전문성"을 정의한다면,
메타 스킬은 **"Claude가 자신을 어떻게 운영할지"** 정의합니다.

#### `history.md` - History Summarizer

**활성화**: `/endsession`, `/historyupdate` 시

**역할**: 주요 이벤트를 HISTORY.md에 요약

**기록 대상**:
- **Decision**: 기술 스택 선택, 아키텍처 결정
- **Change**: 구조적 리팩토링, API 변경
- **Issue**: 버그, 기술 부채

**기록하지 않는 것**:
- 일반 기능 구현, 작은 버그 수정, 스타일 변경

---

#### `build-issues.md` - 빌드 이슈 자동 기록

**활성화**: 빌드/테스트 에러 발생 시

**자동 동작**:
```
빌드/테스트 실행
    ↓
에러 발생 감지
    ↓
해결 시도 (2-3회)
    ↓
┌─────────────┬─────────────┐
│  해결됨 ✅   │  미해결 ❌   │
├─────────────┼─────────────┤
│ resolved/에 │ open/에     │
│ 자동 기록   │ 자동 기록   │
└─────────────┴─────────────┘
```

**TDD와의 구분**:
- TDD Red phase 테스트 실패 → 기록 안함 (의도된 실패)
- 컴파일 에러, 환경 문제 → 기록함

---

## 6. 새 Skill 추가하기 (1분)

### 파일 생성

```bash
# 단일 파일
touch .claude/skills/golang.md

# 디렉토리 (복잡한 skill)
mkdir -p .claude/skills/react
touch .claude/skills/react/README.md
```

### 템플릿

```markdown
# [언어/프레임워크] Expert

[간단한 설명]

## 활성화 조건
- 파일 확장자: `*.xx`
- 특정 컨텍스트

## 핵심 원칙
### [원칙 1]
### [원칙 2]

## 코드 스타일
```[lang]
// 좋은 예
// 나쁜 예
```

## 피해야 할 패턴
- 패턴 1
- 패턴 2

## 권장 도구
| 용도 | 도구 |
|------|------|

## 참고
- [링크](url)
```

---

## 시각 자료 제안

1. **Skills 분류 맵**: 카테고리별 skills 시각화
2. **TDD 사이클 애니메이션**: Red → Green → Refactor
3. **7단계 디버깅 플로우차트**
4. **Property 유형 예시 코드**
5. **ROP 철도 다이어그램**: 성공/실패 경로 분기
6. **CI/CD 파이프라인 다이어그램**
7. **테스트 피라미드 그래픽**
