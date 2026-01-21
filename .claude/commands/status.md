# status

현재 프로젝트 상태를 요약합니다.

## 절차

### 1. 파일 읽기
- .claude/PLAN.md
- .claude/STATE.md
- .claude/CACHE.md

### 2. 요약 출력

```
## 현재 상태

**Phase**: N - [Phase 이름]
**Step**: N.M - [Step 이름]
**Progress**: X/Y 테스트 완료

### 완료된 Steps
- ...

### 진행 중
- ...

### 다음 Step
- ...

### Blockers
- (없으면 "없음")

### Cache 상태
- CLEAN / DIRTY (N개 항목)
```

## 규칙

- 코드 변경 없음
- 간결하게 현재 상태만 보고
- 문제가 있으면 명시적으로 표시
