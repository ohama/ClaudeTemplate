# HISTORY

Major decisions, changes, issues only.

## 2026-01-23

### MCP 통합
- **Decision**: 4개 MCP 서버 사전 구성
  - Context7: 최신 라이브러리 문서
  - Sequential Thinking: 구조화된 문제 해결
  - Memory: 영구 지식 그래프
  - GitHub: GitHub API 통합

- **Change**: MCP 문서 작성
  - `.mcp.json` 설정 파일 추가
  - `.claude/docs/mcp.md` 상세 가이드
  - README에 MCP 섹션 추가

### YouTube 설명 자료
- **Change**: `.claude/youtube/` 디렉토리 생성
  - 01-overview.md: 프로젝트 개요
  - 02-commands.md: 커맨드 상세 설명
  - 03-skills.md: Skills 시스템 설명
  - 04-workflow.md: 워크플로우 가이드

### 스크립트 이름 변경
- **Change**: `scripts/init.sh` → `scripts/clean.sh`
  - 목적을 더 명확히 표현하는 이름으로 변경
  - `.claude/youtube/` 삭제 로직 추가

### 릴리스
- v0.2.4: MCP 통합, YouTube 자료 추가

## 2026-01-22

### Skills 시스템 구축
- **Decision**: knowledge와 prompts의 일부 내용을 skills로 이동
  - `knowledge/TDD.md` → `skills/tdd.md`
  - `prompts/history-summarizer.md` → `skills/claude-behavior/history.md`
  - `prompts/prompt-logger.md` 삭제 (logprompts command와 중복)

- **Change**: 6개 새 skill 추가
  - `git.md` - Conventional Commits, AFTER 원칙
  - `property-testing.md` - Property-based testing
  - `debugging.md` - 7단계 디버깅 프레임워크
  - `logging.md` - 구조화 로깅, OpenTelemetry
  - `code-review.md` - 8대 체크리스트
  - `cicd.md` - 파이프라인, 배포 전략

### Commands-Skills 연결
- **Change**: Commands에서 관련 Skills 참조 추가
  - `commit.md` → `skills/git.md` (perf, ci 타입 추가)
  - `tdd.md` → `skills/tdd.md` (내용 간소화)
  - `historyupdate.md` → `skills/claude-behavior/history.md`
  - `startsession.md` → 다수 skills 참조

### Issue 시스템 개선
- **Decision**: Status 필드 대신 디렉토리 분리 방식 채택
  - `docs/issues/open/` - 미해결 이슈
  - `docs/issues/resolved/` - 해결된 이슈

- **Change**: `/issue build` 명령어 추가
  - 빌드/테스트 에러 전용 템플릿
  - 해결 여부에 따라 자동 분류

- **Change**: 빌드 에러 자동 이슈 기록
  - `skills/claude-behavior/build-issues.md` 추가
  - TDD Red phase는 제외 (의도된 실패)

### README 개선
- **Change**: Quick Start 섹션을 최상단에 배치
  - 템플릿 사용자 관점의 설정 가이드
  - .git 삭제, README 삭제, CLAUDE.md 수정 절차

### Phase 실행 커맨드
- **Change**: `/phase run` - 모든 Phase 자동 실행
  - 초기: 현재 Phase만 → 최종: 모든 Phase 실행
  - `--confirm` 옵션으로 Step별 확인 가능
  - `/phase all` 제거 (phase run으로 통합)

- **Change**: `/nextphase` 커맨드 추가
  - 다음 Phase만 실행 (세분화된 제어)
  - `--confirm` 옵션 지원

### 릴리스
- v0.2.1: /phase run 커맨드 추가
- v0.2.2: /phase all 커맨드 추가
- v0.2.3: /phase run 단순화, /nextphase 추가
