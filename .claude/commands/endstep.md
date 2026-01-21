# endstep

현재 Step을 완료 처리합니다.

## 절차

### 1. DoD 확인
- .claude/PLAN.md에서 현재 Step의 DoD 읽기
- 모든 조건 충족 여부 확인

### 2. 테스트 확인
- 모든 테스트 실행
- 모든 테스트 통과 필수
- 실패 시 완료 불가

### 3. 미충족 항목 처리

**DoD 미충족 시:**
- 미충족 항목 목록 표시
- 최소한의 수정으로 충족
- 다시 테스트

### 4. 상태 업데이트

**.claude/PLAN.md:**
- 현재 Step Status를 `Completed`로 변경
- 전체 진행률 테이블 업데이트

**.claude/STATE.md:**
- Current Step을 Completed Steps로 이동
- Next Step 설정
- Evidence에 테스트 결과 기록

### 5. 커밋 제안

```
Step X.Y: <간단한 설명>
```

## 출력

```
## Step X.Y 완료

**DoD 확인:**
- [x] 모든 테스트 통과
- [x] 빌드 성공

**변경된 파일:**
- src/module.ts
- tests/module.test.ts

**커밋 메시지:**
Step 1.1: Implement basic module

**다음 Step:**
Step 1.2: 다음 모듈 구현
```

## 규칙

- DoD 미충족 시 완료 불가
- 테스트 실패 시 완료 불가
- 완료 후 바로 다음 Step으로 진행하지 않음 (휴식 또는 검토)
