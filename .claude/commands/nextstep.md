# nextstep

새로운 Step을 시작합니다.

## 사용법

```
/nextstep              # PLAN에서 다음 Step 시작
/nextstep "목표"       # 새 목표로 Step 시작
```

## 절차

### 1. 현재 상태 확인
- .claude/PLAN.md 읽기
- .claude/STATE.md 읽기
- .claude/DECISIONS.md 읽기

### 2. 다음 Step 결정

**PLAN에 Step이 있는 경우:**
- 다음 미완료 Step 선택
- Step의 Goal과 Tests 확인

**새 목표가 주어진 경우:**
- PLAN.md에 새 Step 추가
- TDD 기반 테스트 목록 생성

### 3. Step 시작

- Step이 너무 크면 분할 제안
  - 1~2시간 내 완료 가능한 범위로
- STATE.md 업데이트:
  - Current Phase
  - Current Step
  - In Progress

### 4. TDD 사이클 시작

첫 번째 테스트부터 Red → Green → Refactor

## 규칙

- 한 번에 하나의 Step만
- 이전 Step 완료 후 다음 Step
- diff는 최소화
- 테스트 목록 먼저, 구현은 나중
