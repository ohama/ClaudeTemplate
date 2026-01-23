# Claude Code Template - 실전 워크플로우 시연 가이드

## 영상 스크립트 가이드 (10-15분)

---

## 1. 시나리오 소개 (1분)

### 오늘의 미션
> **"간단한 계산기 API를 TDD로 구현하기"**

### 사용할 명령어
```
/startsession → /nextstep → /tdd → /endstep → /commit → /endsession
```

### 프로젝트 구조 (사전 준비)
```
calculator/
├── .claude/
│   ├── PLAN.md          # 계획 작성됨
│   ├── STATE.md         # 초기 상태
│   └── ...
├── src/
└── tests/
```

---

## 2. 세션 시작 (2분)

### `/startsession` 실행

```
User: /startsession
```

**Claude 응답 예시**:
```
PLAN.md, STATE.md를 읽었습니다.

## 현재 프로젝트: Calculator API

**Phase 1**: Core Operations (3 Steps)
  - Step 1.1: 덧셈 구현 (미완료)
  - Step 1.2: 뺄셈 구현 (미완료)
  - Step 1.3: 곱셈/나눗셈 구현 (미완료)

**Phase 2**: Advanced Features (2 Steps)
  - Step 2.1: 괄호 연산 (미완료)
  - Step 2.2: 에러 핸들링 (미완료)

현재 상태: Phase 1, Step 1.1 대기 중
TDD 가이드와 Git 규칙을 로드했습니다.
```

### 포인트
- PLAN.md에서 전체 로드맵 확인
- STATE.md에서 현재 위치 파악
- 필요한 Skills 자동 로드

---

## 3. Step 시작 (1분)

### `/nextstep` 실행

```
User: /nextstep
```

**Claude 응답 예시**:
```
## Step 1.1: 덧셈 구현

**Goal**: 두 숫자를 더하는 add 함수 구현

**Tests to write**:
- [ ] add(1, 2) = 3
- [ ] add(0, 0) = 0
- [ ] add(-1, 1) = 0
- [ ] add(큰 숫자) = 오버플로우 없이 처리

STATE.md 업데이트 완료.
TDD 사이클을 시작합니다.
```

### 포인트
- PLAN에서 다음 Step 자동 선택
- 테스트 목록 미리 계획
- STATE 자동 업데이트

---

## 4. TDD 사이클 시연 (5분)

### `/tdd` 실행 - 첫 번째 사이클

```
User: /tdd
```

---

#### [Red] 실패하는 테스트 작성

**Claude 응답**:
```
## [Red] 첫 번째 테스트 작성

```javascript
// tests/calculator.test.js
describe('Calculator', () => {
  test('add(1, 2) should return 3', () => {
    expect(add(1, 2)).toBe(3);
  });
});
```

테스트 실행 중...

```
FAIL tests/calculator.test.js
  Calculator
    ✕ add(1, 2) should return 3

  ReferenceError: add is not defined
```

✓ 테스트가 예상대로 실패합니다.
Green 단계로 진행합니다.
```

---

#### [Green] 최소 구현

**Claude 응답**:
```
## [Green] 최소 구현

```javascript
// src/calculator.js
function add(a, b) {
  return a + b;
}

module.exports = { add };
```

```javascript
// tests/calculator.test.js (수정)
const { add } = require('../src/calculator');

describe('Calculator', () => {
  test('add(1, 2) should return 3', () => {
    expect(add(1, 2)).toBe(3);
  });
});
```

테스트 실행 중...

```
PASS tests/calculator.test.js
  Calculator
    ✓ add(1, 2) should return 3 (2ms)

Tests: 1 passed, 1 total
```

✓ 테스트 통과!
Refactor 단계로 진행합니다.
```

---

#### [Refactor] 코드 개선

**Claude 응답**:
```
## [Refactor] 코드 검토

현재 코드가 간단하여 리팩토링 필요 없습니다.

✓ 첫 번째 TDD 사이클 완료!

다음 테스트로 진행할까요?
- [ ] add(0, 0) = 0
- [ ] add(-1, 1) = 0
```

---

### `/tdd` 실행 - 두 번째 사이클

```
User: /tdd
```

**Claude 응답 (Red)**:
```
## [Red] 두 번째 테스트

```javascript
test('add(0, 0) should return 0', () => {
  expect(add(0, 0)).toBe(0);
});

test('add(-1, 1) should return 0', () => {
  expect(add(-1, 1)).toBe(0);
});
```

테스트 실행 중...

```
PASS tests/calculator.test.js
  Calculator
    ✓ add(1, 2) should return 3
    ✓ add(0, 0) should return 0
    ✓ add(-1, 1) should return 0
```

✓ 기존 구현이 이미 모든 케이스를 커버합니다!
추가 구현 불필요.
```

---

### 포인트
- Red: 반드시 실패 확인
- Green: 최소한의 코드만
- Refactor: 테스트 유지하며 개선

---

## 5. Step 완료 (2분)

### `/endstep` 실행

```
User: /endstep
```

**Claude 응답**:
```
## Step 1.1 완료 확인

### DoD (Definition of Done) 체크:
- [x] 모든 테스트 통과 (4/4)
- [x] 빌드 성공
- [x] 코드 리뷰 체크리스트 통과

### 변경된 파일:
- src/calculator.js (생성)
- tests/calculator.test.js (생성)

### 테스트 결과:
```
PASS tests/calculator.test.js
  Calculator
    ✓ add(1, 2) should return 3
    ✓ add(0, 0) should return 0
    ✓ add(-1, 1) should return 0
    ✓ add(large numbers) should handle correctly

Tests: 4 passed, 4 total
```

### 커밋 메시지 제안:
```
feat(calculator): implement add function

- Add basic addition operation
- Include tests for edge cases (zero, negative)
```

PLAN.md, STATE.md 업데이트 완료.

**다음 Step**: 1.2 - 뺄셈 구현
```

---

## 6. 커밋 (1분)

### `/commit` 실행

```
User: /commit
```

**Claude 응답**:
```
## Git 상태 분석

### 변경 파일:
- src/calculator.js (신규)
- tests/calculator.test.js (신규)

### 분류:
- feat: 새 기능 (calculator.js)
- test: 테스트 추가 (calculator.test.js)

### 커밋 계획:
1. feat(calculator): implement add function

커밋 메시지 확인:
```
feat(calculator): implement add function

- Add basic addition operation
- Include tests for edge cases

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

이 메시지로 커밋할까요? (Y/n)
```

```
User: Y
```

**Claude 응답**:
```
## 커밋 완료

```
[main abc1234] feat(calculator): implement add function
 2 files changed, 25 insertions(+)
 create mode 100644 src/calculator.js
 create mode 100644 tests/calculator.test.js
```

Total: 1 commit, 2 files changed
```

---

## 7. 세션 종료 (1분)

### `/endsession` 실행

```
User: /endsession
```

**Claude 응답**:
```
## 세션 요약

### 완료된 작업:
- Step 1.1: 덧셈 구현 ✓

### 생성/수정된 파일:
- src/calculator.js
- tests/calculator.test.js

### 커밋:
- feat(calculator): implement add function

### 다음 세션:
- Step 1.2: 뺄셈 구현

### 상태 업데이트:
- STATE.md 업데이트 완료
- 세션 로그: .claude/logs/2025-01-22.md

---

좋은 작업이었습니다! 다음 세션에서 뵙겠습니다.
```

---

## 8. 추가 시나리오 (선택)

### 시나리오 A: 이슈 발생 시

```
User: /tdd
Claude: [Red] 테스트 작성 중...

(빌드 에러 발생)

빌드 에러 감지:
```
Error: Cannot find module 'jest'
```

해결 시도 중...
→ npm install jest --save-dev

✓ 해결됨!

이슈를 기록했습니다:
- docs/issues/resolved/0001-missing-jest-dependency.md
```

---

### 시나리오 B: Phase 전환

```
User: /phase status
Claude:
| Phase | 상태 | 진행률 |
|-------|------|--------|
| Phase 1: Core | Completed | 3/3 ✓ |
| Phase 2: Advanced | Not Started | 0/2 |

User: /phase complete
Claude: Phase 1 완료 처리 중...
        - PLAN.md 업데이트
        - HISTORY.md에 마일스톤 기록
        - 커밋 제안: "Phase 1 complete: Core Operations"

User: /phase next
Claude: Phase 2 시작!
        다음 Step: 2.1 - 괄호 연산
```

---

### 시나리오 C: 자동 Phase 실행

```
User: /nextphase --confirm
Claude: Phase 2 실행을 시작합니다.

Step 2.1: 괄호 연산
├─ /nextstep 실행...
├─ /tdd 사이클...
├─ /endstep 실행...
└─ 완료 ✓

다음 Step으로 진행할까요? (Y/n)

User: Y

Step 2.2: 에러 핸들링
├─ /nextstep 실행...
├─ /tdd 사이클...
├─ /endstep 실행...
└─ 완료 ✓

Phase 2 완료!
- HISTORY.md 업데이트
- 커밋: "Phase 2 complete: Advanced Features"
```

---

## 9. 시연 팁

### 화면 구성 제안
```
┌─────────────────┬─────────────────┐
│                 │                 │
│   터미널        │   에디터        │
│   (Claude)      │   (코드)        │
│                 │                 │
├─────────────────┴─────────────────┤
│                                   │
│   파일 트리 (.claude/ 구조)        │
│                                   │
└───────────────────────────────────┘
```

### 강조 포인트
1. **자동화**: 상태 파일 자동 업데이트
2. **일관성**: 매번 같은 워크플로우
3. **추적성**: 모든 작업이 기록됨
4. **TDD**: 테스트 먼저, 항상

### 시청자 참여
- "여러분도 직접 따라해보세요!"
- 템플릿 GitHub 링크 제공
- 질문은 댓글로

---

## 10. 클로징 (30초)

### 요약
1. `/startsession` - 컨텍스트 로드
2. `/nextstep` - Step 시작
3. `/tdd` - TDD 사이클 (반복)
4. `/endstep` - Step 완료
5. `/commit` - 스마트 커밋
6. `/endsession` - 상태 저장

### 다음 단계
- 템플릿 다운로드
- 자신의 프로젝트에 적용
- 커스텀 Commands/Skills 추가

---

## 시각 자료 제안

1. **터미널 녹화**: 실제 명령어 실행 화면
2. **분할 화면**: 터미널 + 에디터 + 파일 트리
3. **TDD 사이클 표시**: Red/Green/Refactor 상태 인디케이터
4. **진행률 바**: Phase/Step 진행 상황
5. **파일 변경 하이라이트**: STATE.md, PLAN.md 변경 시점
