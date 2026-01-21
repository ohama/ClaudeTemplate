# Command 사용법 가이드

실제 시나리오별 command 사용 예시입니다.

---

## 시나리오 1: 일반적인 작업 흐름

### 1. 세션 시작

```
/startsession
```

Claude가 PLAN, STATE, CACHE 등을 읽고 현재 상태를 파악합니다.

### 2. 새 Step 시작

```
/nextstep
```

**예시 (PLAN에 Step가 있는 경우):**
```
Claude: PLAN.md를 읽었습니다.
        다음 Step: 1.2 - 사용자 인증 구현

        Tests:
        - [ ] 로그인 테스트
        - [ ] 로그아웃 테스트
        - [ ] 세션 유지 테스트

        TDD 사이클을 시작합니다.
```

**예시 (새 목표로 시작):**
```
User: /nextstep "API 에러 처리"
Claude: Step 1.3을 생성합니다.

        Tests:
        - [ ] 404 에러 처리
        - [ ] 500 에러 처리
        - [ ] 타임아웃 처리
```

### 3. TDD 사이클 반복

```
/tdd
```

**예시:**
```
Claude: [Red] 첫 번째 테스트를 작성합니다...
        테스트 실패 확인 ✓

Claude: [Green] 최소 구현을 작성합니다...
        테스트 통과 ✓

Claude: [Refactor] 코드를 개선합니다...
        테스트 여전히 통과 ✓
```

### 4. Step 완료

```
/endstep
```

**예시:**
```
Claude: Step 1.2 DoD 확인:
        - [x] 모든 테스트 통과
        - [x] 빌드 성공

        PLAN.md, STATE.md 업데이트 완료.
        커밋 메시지: "Step 1.2: User authentication"

        다음 Step: 1.3 - API 에러 처리
```

### 5. 세션 종료

```
/endsession
```

---

## 시나리오 2: 이슈 발생 및 해결

### 1. 이슈 발견 시

```
/issue
```

**예시:**
```
User: /issue
Claude: 이슈 내용을 알려주세요.
User: 빈 입력에서 크래시 발생
Claude: docs/issues/0001-crash-on-empty-input.md 생성 완료
```

### 2. 이슈 해결 시

```
/issue resolve 0001
```

---

## 시나리오 3: 지식 관리

### 1. 임시 발견 사항 정리

```
/flush
```

CACHE에 쌓인 내용을 knowledge 파일로 이동합니다.

### 2. 현재 상태 확인

```
/status
```

**예시 출력:**
```
## 현재 상태

**Phase**: 1 - Core Features
**Step**: 1.2 - 사용자 인증
**Progress**: 3/5 테스트 완료

### 완료된 Steps
- Step 1.1: 프로젝트 설정

### 진행 중
- 세션 유지 테스트

### Blockers
- 없음
```

---

## 시나리오 4: Phase 전환

Phase의 모든 Step가 완료되면 다음 Phase로 전환합니다.

### 1. Phase 상태 확인

```
/phase status
```

**예시:**
```
| Phase | 상태 | 진행률 |
|-------|------|--------|
| Phase 1: Core | Completed | 3/3 ✓ |
| Phase 2: Features | In Progress | 1/2 |
| Phase 3: Polish | Not Started | 0/2 |
```

### 2. Phase 완료

```
/phase complete
```

### 3. 다음 Phase 시작

```
/phase next
```

---

## 시나리오 5: 문서화

### 1. 튜토리얼 작성

```
/howto
```

### 2. 릴리스

```
/release
```

---

## Quick Reference

| 상황 | 커맨드 |
|------|--------|
| 작업 시작 | `/startsession` |
| 작업 종료 | `/endsession` |
| 새 Step 시작 | `/nextstep` |
| TDD 사이클 | `/tdd` |
| Step 완료 | `/endstep` |
| Phase 상태 | `/phase status` |
| Phase 완료 | `/phase complete` |
| Phase 전환 | `/phase next` |
| 현재 상태 | `/status` |
| 이슈 기록 | `/issue` |
| 지식 정리 | `/flush` |
| 튜토리얼 | `/howto` |
| 릴리스 | `/release` |

---

## 팁

1. **세션 시작/종료는 필수**: 컨텍스트 유지를 위해 항상 `/startsession`으로 시작, `/endsession`으로 종료

2. **Step 크기 조절**: 1~2시간 내 완료 가능한 범위로

3. **자주 flush**: CACHE가 쌓이면 `/flush`로 정리

4. **이슈는 즉시 기록**: 발견 즉시 `/issue`, 해결 즉시 `/issue resolve`

5. **Phase 전환 시**: `/phase complete` → `/phase next` 사용, ARCHITECTURE 문서 업데이트
