# Claude Code Template - Commands 상세 설명

## 영상 스크립트 가이드 (15-20분)

---

## 1. Commands 개요 (2분)

### Commands란?
`.claude/commands/` 디렉토리에 정의된 **슬래시 명령어**입니다.

```
/명령어 [인자]
```

### 명령어 분류

| 카테고리 | 명령어 | 용도 |
|----------|--------|------|
| **세션 관리** | `/startsession`, `/endsession`, `/status` | 작업 세션 관리 |
| **Step/Phase** | `/nextstep`, `/endstep`, `/phase`, `/nextphase` | 진행 관리 |
| **개발** | `/tdd`, `/commit` | 코딩 & 커밋 |
| **지식 관리** | `/flush`, `/issue`, `/historyupdate`, `/logprompts` | 문서화 |
| **릴리스** | `/release`, `/howto`, `/plan` | 배포 & 문서 |

---

## 2. 세션 관리 명령어 (3분)

### `/startsession` - 세션 시작

**역할**: 프로젝트 상태를 로드하고 작업 준비

**실행 시 읽는 파일**:
```
필수:
- .claude/PLAN.md      # 계획
- .claude/STATE.md     # 현재 상태
- .claude/CACHE.md     # 임시 메모

Knowledge:
- .claude/knowledge/BUILD.md
- .claude/knowledge/TESTING.md
- .claude/knowledge/ARCHITECTURE.md

Skills:
- .claude/skills/tdd.md
- .claude/skills/git.md
- .claude/skills/debugging.md
```

**사용 예시**:
```
User: /startsession
Claude: PLAN.md, STATE.md를 읽었습니다.
        현재 Phase 2, Step 2.3 진행 중입니다.
        다음 목표: API 에러 핸들링 구현
```

---

### `/endsession` - 세션 종료

**역할**: 세션 요약 및 상태 저장

**실행 절차**:
1. 세션 요약 생성
2. `.claude/STATE.md` 업데이트
3. `.claude/CACHE.md` 업데이트
4. `/logprompts` 실행 (세션 로그 저장)
5. 중요 변경 있으면 `/historyupdate` 실행

**사용 예시**:
```
User: /endsession
Claude: 세션 요약:
        - Step 2.3 완료 (API 에러 핸들링)
        - 3개 테스트 추가
        - 2개 커밋 생성

        STATE.md, CACHE.md 업데이트 완료.
        세션 로그: .claude/logs/2025-01-22.md
```

---

### `/status` - 현재 상태 확인

**역할**: 코드 변경 없이 현재 상태만 출력

**출력 형식**:
```markdown
## 현재 상태

**Phase**: 2 - Advanced Features
**Step**: 2.3 - API 에러 핸들링
**Progress**: 3/5 테스트 완료

### 완료된 Steps
- Step 2.1: 기본 API 구현
- Step 2.2: 인증 시스템

### 진행 중
- 에러 응답 포맷팅

### Blockers
- 없음

### Cache 상태
- DIRTY (2개 항목)
```

---

## 3. Step/Phase 관리 명령어 (5분)

### `/nextstep` - 다음 Step 시작

**사용법**:
```
/nextstep              # PLAN에서 다음 Step 자동 선택
/nextstep "API 구현"   # 새 목표로 Step 생성
```

**실행 절차**:
1. PLAN.md에서 다음 미완료 Step 확인
2. STATE.md 업데이트 (Current Step 변경)
3. Step이 너무 크면 분할 제안 (1-2시간 기준)
4. TDD 사이클 시작 준비

**출력 예시**:
```
Claude: 다음 Step: 2.4 - 데이터베이스 연동

        Tests:
        - [ ] 연결 테스트
        - [ ] CRUD 테스트
        - [ ] 트랜잭션 테스트

        TDD 사이클을 시작합니다.
```

---

### `/endstep` - Step 완료

**역할**: DoD(Definition of Done) 확인 후 Step 완료 처리

**실행 절차**:
1. PLAN.md에서 현재 Step의 DoD 확인
2. 모든 테스트 실행 및 통과 확인
3. 미충족 항목 있으면 표시
4. PLAN.md, STATE.md 업데이트
5. 커밋 메시지 제안

**출력 예시**:
```markdown
## Step 2.3 완료

**DoD 확인:**
- [x] 모든 테스트 통과
- [x] 빌드 성공

**변경된 파일:**
- src/api/error-handler.ts
- tests/api/error-handler.test.ts

**커밋 메시지:**
Step 2.3: Implement API error handling

**다음 Step:**
Step 2.4: 데이터베이스 연동
```

---

### `/phase` - Phase 관리

**사용법**:
```
/phase status       # Phase 상태 확인
/phase complete     # 현재 Phase 완료
/phase next         # 다음 Phase 시작
/phase run          # 모든 Phase 자동 실행
/phase run --confirm  # 각 Step 후 확인
```

#### `/phase status` 출력:
```markdown
| Phase | 상태 | 진행률 | Steps |
|-------|------|--------|-------|
| Phase 1: Core | Completed | 3/3 | 1.1 ✓, 1.2 ✓, 1.3 ✓ |
| Phase 2: Features | In Progress | 2/4 | 2.1 ✓, 2.2 ✓, 2.3 ◐, 2.4 ○ |
| Phase 3: Polish | Not Started | 0/2 | - |

현재: Phase 2, Step 2.3
```

#### `/phase complete` 절차:
1. 모든 Step가 Completed인지 확인
2. PLAN.md Phase 상태 → Completed
3. HISTORY.md에 마일스톤 기록
4. ARCHITECTURE.md 상세화

#### `/phase run` 절차:
```
for each Phase in PLAN:
    for each Step in Phase:
        /nextstep
        (TDD 사이클)
        /endstep

        if --confirm:
            "다음 Step 진행?" 질문

    /phase complete
    /phase next
```

---

### `/nextphase` - 다음 Phase 실행

**역할**: 다음 하나의 Phase만 실행 (vs `/phase run`은 모두 실행)

**사용법**:
```
/nextphase              # 다음 Phase 자동 실행
/nextphase --confirm    # 각 Step 후 확인
```

**진행 상황 표시**:
```
Phase 2: Features [2/4]
├─ Step 2.1: User Auth ✅
├─ Step 2.2: Dashboard ✅ (현재 완료)
├─ Step 2.3: Reports ⏳ (다음)
└─ Step 2.4: Settings ○

다음 Step으로 진행할까요? (Y/n)
```

---

## 4. 개발 명령어 (3분)

### `/tdd` - TDD 사이클 실행

**역할**: Red → Green → Refactor 사이클 수행

**참조 스킬**:
- `.claude/skills/tdd.md`
- `.claude/skills/property-testing.md` (선택)

**실행 흐름**:
```
1. [Red] 실패하는 테스트 작성
   → 테스트 실행 → 실패 확인 ✓

2. [Green] 최소한의 구현
   → 테스트 실행 → 통과 확인 ✓

3. [Refactor] 코드 개선
   → 테스트 실행 → 여전히 통과 확인 ✓
```

**핵심 규칙**:
- 테스트 없이 프로덕션 코드 작성 금지
- 한 번에 하나의 테스트만
- 버그 수정 시 재현 테스트부터
- 리팩토링 중 새 기능 추가 금지

---

### `/commit` - 스마트 커밋

**역할**: 변경사항 분석 후 자동 분류 커밋

**실행 절차**:

1. **상태 확인**
   ```bash
   git status
   git diff --stat
   ```

2. **.gitignore 관리**
   - 불필요한 파일 패턴 감지
   - 추가 제안 및 확인

3. **변경사항 분류**
   | 그룹 | 기준 |
   |------|------|
   | feat | 새 기능 |
   | fix | 버그 수정 |
   | docs | 문서 변경 |
   | refactor | 리팩토링 |
   | test | 테스트 |
   | chore | 설정/빌드 |

4. **그룹별 커밋 실행**
   ```
   feat: add user authentication (3 files)
   fix: resolve login timeout (1 file)
   docs: update README (1 file)
   ```

**참조 스킬**: `.claude/skills/git.md` (Conventional Commits)

---

## 5. 지식 관리 명령어 (3분)

### `/flush` - CACHE 정리

**역할**: CACHE.md의 임시 내용을 knowledge 파일로 이동

**절차**:
1. CACHE.md 상태 확인 (DIRTY/CLEAN)
2. 내용을 분류하여 적절한 파일로 이동:
   ```
   빌드 관련 → BUILD.md
   테스트 관련 → TESTING.md
   코드 패턴 → PATTERNS.md
   규칙/제약 → RULES.md
   아키텍처 → ARCHITECTURE.md
   ```
3. CACHE.md를 CLEAN 상태로 변경

---

### `/issue` - 이슈 기록

**사용법**:
```
/issue                    # 새 이슈 기록
/issue build              # 빌드 이슈 기록
/issue resolve <번호>     # 이슈 해결
/issue list               # 이슈 목록
```

**디렉토리 구조**:
```
docs/issues/
├── open/            # 미해결 이슈
│   └── 0001-api-crash.md
└── resolved/        # 해결된 이슈
    └── 0002-login-fix.md
```

**이슈 템플릿**:
```markdown
# Issue NNNN: [제목]

**Status**: Open | Resolved
**Created**: YYYY-MM-DD
**Resolved**: YYYY-MM-DD

## 증상
## 재현 방법
## 원인
## Resolution
## 관련 파일
```

---

### `/historyupdate` - HISTORY 업데이트

**역할**: 주요 이벤트를 HISTORY.md에 기록

**기록 대상**:
- **Decision**: 기술 스택 선택, 아키텍처 결정
- **Change**: 구조적 리팩토링, API 변경
- **Issue**: 발견된 버그, 기술 부채

**기록하지 않는 것**:
- 일반적인 기능 구현
- 작은 버그 수정
- 코드 스타일 변경

**출력 형식**:
```markdown
## 2025-01-22
- Decision: JWT 인증 방식 채택
- Change: API 응답 포맷을 JSON:API 스펙으로 변경
- Issue: N+1 쿼리 문제 발견 (성능 저하)
```

---

### `/logprompts` - 세션 로그 저장

**역할**: 세션의 대화 내용을 로그 파일에 저장

**로그 위치**: `.claude/logs/YYYY-MM-DD.md`

**기록 규칙**:
- 사용자 프롬프트: **원문 그대로** (문법 오류만 수정)
- Claude 응답: **1-3줄로 요약**
- `/plan` 응답: **전체 내용 그대로** (예외)

**로그 형식**:
```markdown
## 14:30

**User**: API 에러 핸들링을 구현해줘

**Claude**: API 에러 핸들링 구현 완료.
- src/api/error-handler.ts 생성
- 3개 테스트 케이스 추가
```

---

## 6. 릴리스 명령어 (2분)

### `/release` - 버전 릴리스

**실행 절차**:
1. VERSION 파일에서 현재 버전 확인
2. 버전 타입 선택 (major/minor/patch)
3. 새 버전 계산 (0.1.0 + patch = 0.1.1)
4. CHANGELOG.md 업데이트 (Added, Changed, Fixed, Removed)
5. VERSION 파일 업데이트
6. 커밋: `chore: release v{버전}`

---

### `/howto` - 튜토리얼 문서 생성

**역할**: 현재 작업을 신입개발자용 튜토리얼로 문서화

**사용법**:
```
/howto              # 현재 작업 문서화
/howto "API 인증"   # 특정 주제로 문서 작성
```

**문서 위치**: `docs/howto/<topic>.md`

---

### `/plan` - 진행 상황 시각화

**사용법**:
```
/plan              # 전체 계획 상태
/plan summary      # 간단 요약
/plan phase N      # 특정 Phase 상세
```

**출력 예시**:
```
## 프로젝트 진행 상황

### 전체 진행률
████████████░░░░░░░░ 35% (6/17 Steps)

### Phase 별 상태
| Phase | 상태 | 진행률 |
|-------|------|--------|
| Phase 1: Core | ✅ Completed | 3/3 |
| Phase 2: Features | 🔄 In Progress | 2/4 |
| Phase 3: Polish | ⏳ Not Started | 0/2 |
```

---

## 7. 명령어 구조 및 확장 (2분)

### 명령어 파일 구조

```markdown
# 명령어이름

설명

## 참조 (선택)
- 관련 skill 파일 링크

## 사용자 입력 (선택)
$ARGUMENTS - 설명

## 절차/실행
1. 단계 1
2. 단계 2

## 규칙
- 규칙 1
- 규칙 2
```

### 새 명령어 추가하기

1. 파일 생성: `.claude/commands/mycommand.md`
2. 템플릿에 맞춰 작성
3. 바로 사용 가능: `/mycommand`

---

## 시각 자료 제안

1. **명령어 분류 다이어그램**: 카테고리별 명령어 맵
2. **워크플로우 플로우차트**: startsession → endsession
3. **TDD 사이클 애니메이션**: Red → Green → Refactor
4. **Phase/Step 트리 구조**: 계층 관계 시각화
5. **터미널 데모**: 실제 명령어 실행 화면
