# phase

Phase 완료 또는 전환을 처리합니다.

## 사용법

```
/phase complete          # 현재 Phase 완료
/phase next              # 다음 Phase 시작
/phase status            # Phase 상태 확인
/phase run               # 모든 Phase 자동 실행
/phase run --confirm     # 각 Step 완료 후 확인 받고 진행
```

## 절차

### /phase complete

현재 Phase를 완료 처리합니다.

1. **완료 조건 확인**
   - .claude/PLAN.md에서 현재 Phase의 완료 조건 확인
   - 모든 Step가 Completed인지 확인
   - 모든 테스트 통과 확인

2. **문서 업데이트**
   - .claude/PLAN.md: Phase 상태를 Completed로
   - .claude/STATE.md: Current Phase 업데이트
   - .claude/HISTORY.md: 마일스톤 기록
   - .claude/knowledge/ARCHITECTURE.md: 해당 모듈 상세화

3. **스펙 문서 확인**
   - docs/spec/ 문서가 구현과 일치하는지 확인
   - 불일치 시 업데이트

4. **커밋 제안**
   ```
   Phase N complete: [Phase 이름]
   ```

### /phase next

다음 Phase를 시작합니다.

1. **이전 Phase 완료 확인**
   - 미완료 시 경고

2. **다음 Phase 준비**
   - PLAN.md에서 다음 Phase 확인
   - 첫 번째 Step 파악

3. **상태 업데이트**
   - STATE.md: Current Phase 변경
   - 다음 Step 준비

### /phase run [--confirm]

PLAN.md의 모든 Phase를 순차적으로 실행합니다.

**기본 모드 (자동)**:
```
/phase run
```
- 모든 Phase의 모든 Step을 연속 실행
- 에러 발생 시만 중단

**확인 모드**:
```
/phase run --confirm
```
- 각 Step 완료 후 사용자 확인
- 중단 가능

**절차**:

1. **전체 Phase 목록 로드**
   - PLAN.md에서 모든 Phase와 Step 파악
   - 이미 완료된 Phase/Step은 건너뜀

2. **Phase 순차 실행**
   ```
   for each Phase in PLAN:
       for each Step in Phase:
           /nextstep (Step 시작)
           (TDD 사이클 또는 작업 수행)
           /endstep (Step 완료)

           if --confirm:
               사용자에게 "다음 Step 진행?" 질문
               No 선택 시 중단

       /phase complete (Phase 완료)
       /phase next (다음 Phase 시작)
   ```

3. **프로젝트 완료 처리**
   - 모든 Phase 완료 시 HISTORY.md에 프로젝트 완료 기록
   - 최종 상태 출력

**진행 상황 표시**:
```
=== Project Execution ===

Phase 1: Core [3/3] ✅
Phase 2: Features [2/4]
├─ Step 2.1 ✅
├─ Step 2.2 ✅ (현재 완료)
├─ Step 2.3 ⏳
└─ Step 2.4 ○
Phase 3: Integration [0/3] ○

전체 진행률: 5/10 Steps (50%)
```

**중단 시 재개**:
- `/phase run` 재실행 시 현재 위치에서 이어서 진행
- 완료된 Phase/Step은 자동으로 건너뜀

### /phase status

Phase 전체 상태를 보여줍니다.

```
## Phase 상태

| Phase | 상태 | 진행률 | Steps |
|-------|------|--------|-------|
| Phase 1: Core | Completed | 3/3 | 1.1 ✓, 1.2 ✓, 1.3 ✓ |
| Phase 2: Features | In Progress | 1/4 | 2.1 ✓, 2.2 ◐, 2.3 ○, 2.4 ○ |
| Phase 3: Integration | Not Started | 0/3 | - |

현재: Phase 2, Step 2.2
```

## 규칙

- Phase 완료 조건 미충족 시 complete 불가
- Phase 전환 시 반드시 HISTORY 업데이트
- ARCHITECTURE 문서 상세화 필수
