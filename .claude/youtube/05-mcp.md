# Claude Code Template - MCP 통합 가이드

## 영상 스크립트 가이드 (10-12분)

---

## 1. 오프닝: MCP란? (1.5분)

### 한 줄 정의
> **MCP (Model Context Protocol)**: AI 모델에 외부 도구와 데이터를 연결하는 표준 프로토콜

### 왜 필요한가?
- Claude Code의 **기본 기능 확장**
- **최신 라이브러리 문서** 실시간 접근
- **프로젝트 컨텍스트** 영구 저장
- **GitHub** 직접 연동

### Claude Code Template의 MCP
```
.mcp.json
├── context7         # 최신 문서
├── sequential-thinking  # 구조화된 사고
├── memory           # 영구 기억
└── github           # GitHub API
```

---

## 2. Context7 - 최신 라이브러리 문서 (2.5분)

### 무엇을 하나?
```
"Next.js 미들웨어 작성해줘"
    ↓
❌ 오래된 지식으로 작성 (버전 불일치)

"Next.js 미들웨어 작성해줘. use context7"
    ↓
✅ 최신 문서 참조 후 작성 (정확한 코드)
```

### 사용법

프롬프트 끝에 **"use context7"** 추가:
```
React 19의 use() 훅 사용법 알려줘. use context7
```
```
Prisma에서 트랜잭션 처리하는 코드. use context7
```
```
Next.js 15 App Router로 API 만들어줘. use context7
```

### 제공 도구

| 도구 | 설명 |
|------|------|
| `resolve-library-id` | 라이브러리 이름 → Context7 ID 변환 |
| `query-docs` | 문서 및 코드 예제 검색 |

### 성능 개선 효과

| 지표 | 개선 |
|------|------|
| 토큰 사용량 | ↓ 65% |
| 응답 지연 | ↓ 38% |
| 도구 호출 | ↓ 30% |

### 시연 예시
```
# Before (use context7 없이)
Claude: (2023년 문서 기준으로 답변)

# After (use context7 사용)
Claude: (2026년 최신 문서 기준으로 답변)
```

---

## 3. Sequential Thinking - 구조화된 문제 해결 (2분)

### 무엇을 하나?
```
복잡한 문제
    ↓
단계별 분해
    ↓
각 단계 검증
    ↓
수정/개선
    ↓
최종 솔루션
```

### 사용 시나리오

| 상황 | 효과 |
|------|------|
| 복잡한 알고리즘 설계 | 단계별 검증 |
| 아키텍처 결정 | 대안 비교 분석 |
| 디버깅 전략 | 체계적 원인 분석 |
| 다단계 구현 계획 | 의존성 파악 |

### 동작 원리

```
Step 1: 문제 정의
    ↓
Step 2: 접근 방법 나열
    ↓
Step 3: 각 접근 분석
    ↓
Step 4: 최적안 선택
    ↓
Step 5: 구현 계획
```

- 이전 단계 **수정 가능** (반성적 사고)
- 대안으로 **분기 가능**
- 필요에 따라 **단계 추가/제거**

---

## 4. Memory - 영구 기억 시스템 (2.5분)

### 무엇을 하나?
```
세션 1: "이 프로젝트는 TypeScript strict 모드야"
    ↓
[저장]
    ↓
세션 2: "지난번 얘기한 프로젝트 설정 기억나?"
    ↓
[불러오기]
    ↓
"네, TypeScript strict 모드 프로젝트죠"
```

### 지식 그래프 구조

```
┌─────────────┐     relation      ┌─────────────┐
│   Entity    │ ────────────────→ │   Entity    │
│  (User A)   │   "works_on"      │ (Project X) │
└─────────────┘                   └─────────────┘
      │
      │ observations
      ▼
┌─────────────────────────────────┐
│ - "Prefers TypeScript"          │
│ - "Uses VS Code"                │
│ - "Interested in AI"            │
└─────────────────────────────────┘
```

### 제공 도구

| 도구 | 설명 |
|------|------|
| `create_entities` | 새 엔티티 생성 |
| `create_relations` | 엔티티 간 관계 생성 |
| `add_observations` | 엔티티에 정보 추가 |
| `search_nodes` | 노드 검색 |
| `read_graph` | 전체 그래프 조회 |

### 사용 예시

```
# 정보 저장
"이 프로젝트가 F#으로 작성되고 ROP 패턴을 사용한다고 기억해줘"

# 정보 조회
"이 프로젝트에 대해 기억하고 있는 것들 알려줘"

# 관계 저장
"UserService가 AuthModule에 의존한다고 기억해줘"
```

### 저장 위치
- 기본: 로컬 JSONL 파일
- 커스텀 경로 설정 가능

---

## 5. GitHub - GitHub API 통합 (2분)

### 무엇을 하나?
```
"이 저장소의 열린 이슈 보여줘"
    ↓
[GitHub API 호출]
    ↓
이슈 목록 표시
```

### 주요 기능

| 기능 | 도구 | 예시 |
|------|------|------|
| 이슈 관리 | `list_issues`, `create_issue` | "버그 리포트 이슈 생성해줘" |
| PR 관리 | `create_pull_request`, `merge_pull_request` | "main으로 PR 생성해줘" |
| 코드 검색 | `search_code` | "이 패턴 사용하는 곳 찾아줘" |
| 저장소 관리 | `create_repository`, `fork_repository` | "새 저장소 만들어줘" |

### 설정 방법

1. GitHub Personal Access Token 발급
   - Settings → Developer settings → Personal access tokens
   - 필요 권한: `repo`, `read:org`, `read:user`

2. `.mcp.json`에 토큰 설정
```json
{
  "github": {
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_..."
    }
  }
}
```

### 사용 예시

```
# 이슈 조회
"ohama/ClaudeTemplate 저장소의 열린 이슈 보여줘"

# PR 분석
"이 PR의 변경 파일들을 분석해줘"

# 코드 검색
"Result 타입 사용하는 파일들 찾아줘"
```

---

## 6. 설정 및 활성화 (1.5분)

### 설정 파일 (.mcp.json)

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "description": "Up-to-date library documentation"
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "description": "Structured problem-solving"
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "description": "Persistent knowledge graph"
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<your-token>"
      },
      "description": "GitHub API integration"
    }
  }
}
```

### 활성화 절차

1. `.mcp.json` 파일 확인
2. GitHub 토큰 설정 (필요시)
3. Claude Code 재시작
4. `/mcp` 명령으로 상태 확인

### 문제 해결

```
# MCP 상태 확인
/mcp

# 전체 진단
/doctor
```

---

## 7. 실전 활용 팁 (1분)

### Context7
- 새 라이브러리 사용 시 항상 **"use context7"** 추가
- 버전 명시하면 더 정확: "React 19 use context7"

### Memory
- 프로젝트 시작 시 **핵심 컨텍스트 저장**
- 중요 결정사항 **관계로 연결**

### GitHub
- PR 리뷰 전 **변경 파일 분석 요청**
- 이슈 생성 시 **템플릿 형식 요청**

### 조합 활용

```
# Context7 + Memory
"이 프로젝트에서 사용하는 Prisma 버전에 맞는
 트랜잭션 코드 작성해줘. use context7"

# GitHub + Memory
"지난번 논의한 인증 방식으로
 feature/auth 브랜치에서 PR 생성해줘"
```

---

## 8. 클로징 (30초)

### MCP로 얻는 것
1. **최신 정보** - Context7로 항상 최신 문서
2. **연속성** - Memory로 세션 간 컨텍스트 유지
3. **통합** - GitHub으로 워크플로우 통합
4. **품질** - Sequential Thinking으로 체계적 분석

### 참고 문서
- `.claude/docs/mcp.md` - 상세 설정 가이드
- README.md의 MCP 섹션

---

## 시각 자료 제안

1. **MCP 아키텍처**: Claude ↔ MCP Servers 연결 다이어그램
2. **Context7 Before/After**: 문서 참조 유무 비교
3. **Memory 지식 그래프**: Entity-Relation 시각화
4. **설정 화면**: .mcp.json 편집 장면
5. **GitHub 연동**: 이슈/PR 조회 시연
