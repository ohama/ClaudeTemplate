# Claude Code Template - 프로젝트 개요

## 영상 스크립트 가이드 (5-7분)

---

## 1. 오프닝: Claude Code Template이란? (1분)

### 한 줄 정의
> **대형 프로젝트를 위한 Claude Code 워크플로우 템플릿**

### 무엇을 해결하나?
- Claude Code로 작업할 때 **컨텍스트 유실** 문제
- 복잡한 프로젝트에서 **진행 상황 추적** 어려움
- **반복적인 워크플로우**를 매번 설명해야 하는 번거로움

### 해결책
- 미리 정의된 **Commands** (슬래시 명령어)
- 자동 적용되는 **Skills** (전문가 지침)
- 체계적인 **문서 구조** (PLAN, STATE, HISTORY)

---

## 2. 핵심 철학 3가지 (2분)

### 철학 1: TDD 기반 개발
```
Red → Green → Refactor (반복)
```
- 테스트 먼저 작성 (Red)
- 최소 구현으로 통과 (Green)
- 코드 개선 (Refactor)
- **버그를 방지하고 품질을 보장**

### 철학 2: Phase > Step 구조
```
Phase 1: Core Features
  └─ Step 1.1: 기본 설정
  └─ Step 1.2: 핵심 기능 구현
  └─ Step 1.3: 테스트 작성

Phase 2: Advanced Features
  └─ Step 2.1: 확장 기능
  ...
```
- 큰 프로젝트를 **관리 가능한 단위**로 분할
- 각 Step은 **1-2시간 내 완료** 가능한 크기
- **의존성 관계** 명확히 정의

### 철학 3: 지식 관리 & 문서화
```
작업 중 발견 → CACHE.md (임시)
     ↓
/flush 명령
     ↓
knowledge/*.md (영구 저장)
```
- 발견한 내용을 잃어버리지 않음
- 세션 간 **지식 전달**
- **히스토리 추적** (HISTORY.md)

---

## 3. 디렉토리 구조 (1.5분)

```
.claude/
├── README.md          # 가이드 문서
├── USAGE.md           # 사용법 시나리오
│
├── PLAN.md            # 프로젝트 계획 (Phase/Step)
├── STATE.md           # 현재 진행 상태
├── CACHE.md           # 임시 발견 사항
├── HISTORY.md         # 주요 결정/변경 히스토리
├── DECISIONS.md       # 기술적 결정 기록
│
├── commands/          # 슬래시 명령어 정의
│   ├── startsession.md
│   ├── nextstep.md
│   ├── tdd.md
│   └── ...
│
├── skills/            # 전문가 지침
│   ├── tdd.md
│   ├── git.md
│   ├── fsharp.md
│   └── ...
│
├── knowledge/         # 프로젝트 지식
│   ├── ARCHITECTURE.md
│   ├── BUILD.md
│   ├── TESTING.md
│   ├── PATTERNS.md
│   └── RULES.md
│
└── logs/              # 세션 로그
    └── YYYY-MM-DD.md
```

### 핵심 파일 설명

| 파일 | 역할 | 업데이트 시점 |
|------|------|--------------|
| `PLAN.md` | 전체 로드맵 | 프로젝트 시작, Phase 완료 |
| `STATE.md` | 현재 위치 | 매 Step 시작/완료 |
| `CACHE.md` | 임시 메모 | 작업 중 수시로 |
| `HISTORY.md` | 중요 이벤트 | 세션 종료 시 |

---

## 4. Commands vs Skills (1.5분)

### Commands (명령어)
- **사용자가 직접 호출**: `/명령어` 형태
- **절차적**: 단계별로 실행
- **예시**: `/startsession`, `/tdd`, `/commit`

### Skills (전문가 지침)
- **자동 활성화**: 컨텍스트에 따라 적용
- **선언적**: 원칙과 패턴 정의
- **예시**: F# 파일 작업 시 → `fsharp.md` 자동 적용

### 연결 관계
```
/commit 실행
    │
    ├─ commands/commit.md 의 절차 수행
    │
    └─ skills/git.md 의 Conventional Commits 규칙 적용
```

---

## 5. 기본 워크플로우 미리보기 (1분)

```
/startsession              # 1. 세션 시작
    ↓
/nextstep                  # 2. 다음 Step 선택
    ↓
/tdd (반복)                # 3. TDD 사이클
    ↓
/endstep                   # 4. Step 완료
    ↓
/commit                    # 5. 커밋
    ↓
/endsession                # 6. 세션 종료
```

### 자동화되는 것들
- 상태 파일 업데이트 (STATE.md, PLAN.md)
- 히스토리 기록 (HISTORY.md)
- 세션 로그 저장 (logs/)
- Git 커밋 메시지 생성

---

## 6. 클로징 (30초)

### 이 템플릿으로 얻는 것
1. **일관된 워크플로우** - 매번 같은 패턴으로 작업
2. **컨텍스트 보존** - 세션 간 정보 유실 방지
3. **체계적 진행** - Phase/Step으로 복잡한 프로젝트 관리
4. **자동 문서화** - 히스토리, 로그, 지식 자동 관리

### 다음 영상 예고
- Commands 상세 설명
- Skills 상세 설명
- 실전 워크플로우 시연

---

## 시각 자료 제안

1. **구조도**: .claude/ 디렉토리 트리
2. **플로우차트**: 기본 워크플로우 (startsession → endsession)
3. **비교표**: Commands vs Skills
4. **TDD 다이어그램**: Red → Green → Refactor 순환
