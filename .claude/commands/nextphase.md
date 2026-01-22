# nextphase

다음 Phase를 실행합니다. (현재 Phase가 진행 중이면 현재 Phase 완료)

## 사용법

```
/nextphase              # 다음 Phase 자동 실행
/nextphase --confirm    # 각 Step 완료 후 확인 받고 진행
```

## 절차

### 1. 현재 상태 확인

- PLAN.md에서 Phase 목록 파악
- STATE.md에서 현재 Phase/Step 확인
- 이미 완료된 Step은 건너뜀

### 2. Phase 실행

**현재 Phase가 진행 중인 경우:**
- 남은 Step들을 순차 실행
- Phase 완료 후 종료

**현재 Phase가 완료된 경우:**
- 다음 Phase 시작
- 해당 Phase의 모든 Step 실행
- Phase 완료 후 종료

### 3. Step 순차 실행

```
for each Step in Phase:
    /nextstep (Step 시작)
    (TDD 사이클 또는 작업 수행)
    /endstep (Step 완료)

    if --confirm:
        사용자에게 "다음 Step 진행?" 질문
        No 선택 시 중단
```

### 4. Phase 완료 처리

- 모든 Step 완료 시 자동으로 /phase complete 실행
- STATE.md, HISTORY.md 업데이트

## 진행 상황 표시

```
Phase 2: Features [2/4]
├─ Step 2.1: User Auth ✅
├─ Step 2.2: Dashboard ✅ (현재 완료)
├─ Step 2.3: Reports ⏳ (다음)
└─ Step 2.4: Settings ○

다음 Step으로 진행할까요? (Y/n)
```

## 옵션

| 옵션 | 동작 |
|------|------|
| (없음) | 확인 없이 Phase 전체 실행 |
| `--confirm` | 각 Step 완료 후 확인 |

## /phase run 과의 차이

| 명령어 | 범위 |
|--------|------|
| `/nextphase` | 다음 1개 Phase만 실행 |
| `/phase run` | 모든 Phase 실행 |

## 중단 시 재개

- 중단된 위치에서 다시 `/nextphase` 실행 시 이어서 진행
- 완료된 Step은 자동으로 건너뜀

## 규칙

- 한 번에 하나의 Phase만 실행
- Phase 완료 조건 충족 시 자동 complete
- HISTORY.md에 마일스톤 기록
