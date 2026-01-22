# Claude Code 개발자 운영 가이드

> **[USAGE.md](./USAGE.md)** - 커맨드 목록 및 시나리오별 사용 예시

대형 프로젝트를 위한 Claude Code 워크플로우입니다.

- TDD 기반 개발 (Red → Green → Refactor)
- Step 기반 워크플로우 (Phase > Step)
- 문서화 및 지식 관리
- HISTORY 요약 관리

---

## 주요 파일

| 파일 | 설명 |
|------|------|
| `.claude/PLAN.md` | Phase > Step 구조의 프로젝트 계획 |
| `.claude/STATE.md` | 현재 진행 상태 |
| `.claude/CACHE.md` | 임시 발견 사항 |
| `.claude/HISTORY.md` | 주요 결정/전환점 요약 |
| `.claude/DECISIONS.md` | 기술적 결정 기록 |
| `docs/issues/*` | 이슈 기록 |
| `.claude/knowledge/*` | 아키텍처, 규칙, 패턴 |
| `.claude/commands/*` | 모든 운영 커맨드 |

---

## 워크플로우

### Step 작업

```
/startsession → /nextstep → /tdd (반복) → /endstep → /endsession
```

### Phase 전환

```
/nextphase                     # 다음 Phase 자동 실행
/phase run                     # 모든 Phase 자동 실행
/phase status/complete/next    # 수동 관리
```

---

## 구조

```
Phase 1: (Phase 이름)
  └─ Step 1.1: (Step 이름)     (Depends on: -)
  └─ Step 1.2: (Step 이름)     (Depends on: 1.1)
  └─ Step 1.3: (Step 이름)     (Depends on: 1.2)
Phase 2: (Phase 이름)
  └─ Step 2.1: (Step 이름)     (Depends on: 1.3)
```

---

## Knowledge 파일

| 파일 | 내용 |
|------|------|
| `ARCHITECTURE.md` | 프로젝트 구조, 모듈 관계 |
| `BUILD.md` | 빌드 명령어, 환경 |
| `TESTING.md` | 테스트 가이드 |
| `TDD.md` | TDD 사이클 가이드 |
| `PATTERNS.md` | 코드 패턴 |
| `RULES.md` | 개발 규칙 |
