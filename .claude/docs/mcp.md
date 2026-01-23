# MCP (Model Context Protocol) 가이드

프로젝트에서 사용하는 MCP 서버들에 대한 상세 문서입니다.

---

## 설정 파일

`.mcp.json` 파일에 MCP 서버들이 정의되어 있습니다.

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
      "description": "Structured problem-solving for complex implementations"
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-memory"],
      "description": "Persistent knowledge graph for project context"
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "<your-github-token>"
      },
      "description": "GitHub API for PRs, issues, repos, and code"
    }
  }
}
```

---

## 1. Context7 (`@upstash/context7-mcp`)

### 개요

Context7은 **최신 라이브러리 문서**를 AI 코딩 어시스턴트에 제공하는 MCP 서버입니다.
버전별 문서와 코드 예제를 실시간으로 가져와 프롬프트에 직접 삽입합니다.

### 주요 기능

- 최신 라이브러리 문서 검색
- 버전별 정확한 API 문서 제공
- 코드 예제 포함
- 30+ MCP 호환 클라이언트 지원 (Cursor, VS Code, Claude Code 등)

### 제공 도구

| 도구 | 설명 |
|------|------|
| `resolve-library-id` | 일반 라이브러리 이름을 Context7 호환 ID로 변환 |
| `query-docs` | 라이브러리 문서 및 코드 예제 검색 |

### 사용법

프롬프트에 **"use context7"** 을 추가하면 자동으로 최신 문서를 가져옵니다.

```
Next.js 미들웨어로 JWT 검증하는 코드 작성해줘. use context7
```

### API 키 (선택)

높은 Rate Limit을 위해 API 키를 발급받을 수 있습니다:
1. https://context7.com/dashboard 접속
2. 무료 계정 생성
3. API 키 발급 (형식: `ctx7sk-...`)

API 키 설정:
```json
{
  "context7": {
    "command": "npx",
    "args": ["-y", "@upstash/context7-mcp@latest"],
    "env": {
      "CONTEXT7_API_KEY": "ctx7sk-..."
    }
  }
}
```

### 성능 (2026년 1월 기준)

| 지표 | 개선 |
|------|------|
| 토큰 사용량 | ↓ 65% (평균 ~3.3k) |
| 지연 시간 | ↓ 38% (15초) |
| 도구 호출 | ↓ 30% (2.96회) |

### 참고

- [GitHub](https://github.com/upstash/context7)
- [npm](https://www.npmjs.com/package/@upstash/context7-mcp)
- [Upstash Blog](https://upstash.com/blog/context7-mcp)

---

## 2. Sequential Thinking (`@modelcontextprotocol/server-sequential-thinking`)

### 개요

Sequential Thinking은 **구조화된 사고 과정**을 통해 복잡한 문제를 해결하는 MCP 서버입니다.
동적이고 반성적인 문제 해결을 지원합니다.

### 주요 기능

- 복잡한 문제를 관리 가능한 단계로 분해
- 이해가 깊어짐에 따라 생각을 수정/개선
- 대안적 추론 경로로 분기
- 총 사고 단계 수를 동적으로 조정

### 사용 시나리오

- 복잡한 알고리즘 설계
- 아키텍처 결정
- 디버깅 전략 수립
- 다단계 구현 계획

### 환경 변수

| 변수 | 설명 |
|------|------|
| `DISABLE_THOUGHT_LOGGING` | `true`로 설정하면 사고 로깅 비활성화 |

### 설정 예시

```json
{
  "sequential-thinking": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
    "env": {
      "DISABLE_THOUGHT_LOGGING": "false"
    }
  }
}
```

### 참고

- [GitHub](https://github.com/modelcontextprotocol/servers/tree/main/src/sequentialthinking)
- [npm](https://www.npmjs.com/package/@modelcontextprotocol/server-sequential-thinking)

---

## 3. Memory (`@modelcontextprotocol/server-memory`)

### 개요

Memory는 **지식 그래프 기반 영구 메모리 시스템**입니다.
세션 간에 정보를 기억하여 개인화된 상호작용을 지원합니다.

### 지식 그래프 구조

```
┌─────────────┐     relation      ┌─────────────┐
│   Entity    │ ────────────────→ │   Entity    │
│  (User A)   │   "works_at"      │ (Company X) │
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

| 구성 요소 | 설명 |
|-----------|------|
| **Entities** | 지식 그래프의 주요 노드 (사람, 프로젝트, 개념 등) |
| **Relations** | 엔티티 간 방향성 연결 (능동태로 저장) |
| **Observations** | 엔티티에 대한 개별 정보 조각 |

### 주요 기능

- 로컬 지식 그래프를 사용한 영구 메모리
- 엔티티 및 관계 CRUD 작업
- 개인화된 메모리를 위한 관찰 추가/제거
- 이름, 타입, 관찰을 기반으로 노드 검색

### 제공 도구

| 도구 | 설명 |
|------|------|
| `create_entities` | 새 엔티티 생성 |
| `read_graph` | 전체 지식 그래프 조회 |
| `search_nodes` | 쿼리로 노드 검색 |
| `create_relations` | 엔티티 간 관계 생성 |
| `add_observations` | 엔티티에 관찰 추가 |
| `delete_entities` | 엔티티 삭제 |
| `delete_observations` | 관찰 삭제 |
| `delete_relations` | 관계 삭제 |

### 저장 위치

기본적으로 메모리는 JSONL 파일에 저장됩니다.
커스텀 경로 설정:

```json
{
  "memory": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-memory"],
    "env": {
      "MEMORY_FILE_PATH": "/path/to/custom/memory.jsonl"
    }
  }
}
```

### 사용 예시

```
이 프로젝트는 F#으로 작성되고 ROP 패턴을 사용한다고 기억해줘.
```

```
이 프로젝트에 대해 기억하고 있는 것들 알려줘.
```

### 참고

- [GitHub](https://github.com/modelcontextprotocol/servers/tree/main/src/memory)
- [npm](https://www.npmjs.com/package/@modelcontextprotocol/server-memory)

---

## 4. GitHub (`@modelcontextprotocol/server-github`)

### 개요

GitHub MCP는 **GitHub API**를 통해 저장소, PR, 이슈, 코드를 직접 조작할 수 있는 서버입니다.
대형 프로젝트에서 협업과 코드 관리에 필수적입니다.

### 주요 기능

- 저장소 파일 읽기/쓰기
- Pull Request 생성, 조회, 머지
- 이슈 생성, 조회, 댓글
- 브랜치 생성/관리
- 커밋 히스토리 조회
- 코드 검색

### 제공 도구

| 도구 | 설명 |
|------|------|
| `create_or_update_file` | 파일 생성 또는 업데이트 |
| `search_repositories` | 저장소 검색 |
| `create_repository` | 새 저장소 생성 |
| `get_file_contents` | 파일 내용 조회 |
| `push_files` | 여러 파일 푸시 |
| `create_issue` | 이슈 생성 |
| `create_pull_request` | PR 생성 |
| `fork_repository` | 저장소 포크 |
| `create_branch` | 브랜치 생성 |
| `list_commits` | 커밋 목록 조회 |
| `list_issues` | 이슈 목록 조회 |
| `update_issue` | 이슈 업데이트 |
| `add_issue_comment` | 이슈에 댓글 추가 |
| `search_code` | 코드 검색 |
| `search_issues` | 이슈/PR 검색 |
| `search_users` | 사용자 검색 |
| `get_issue` | 특정 이슈 조회 |
| `get_pull_request` | 특정 PR 조회 |
| `list_pull_requests` | PR 목록 조회 |
| `create_pull_request_review` | PR 리뷰 생성 |
| `merge_pull_request` | PR 머지 |
| `get_pull_request_files` | PR 변경 파일 조회 |
| `get_pull_request_status` | PR 상태 조회 |

### 설정

**1. GitHub Personal Access Token 발급**

1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. "Generate new token (classic)" 클릭
3. 필요한 권한 선택:
   - `repo` (전체 저장소 접근)
   - `read:org` (조직 읽기)
   - `read:user` (사용자 정보 읽기)

**2. 환경 변수 설정**

```json
{
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxxxxxxxxx"
    }
  }
}
```

### 사용 예시

```
ohama/ClaudeTemplate 저장소의 열린 이슈 목록 보여줘
```

```
이 PR의 변경 파일들을 분석해줘: https://github.com/owner/repo/pull/123
```

```
새 이슈를 생성해줘: 제목 "버그: 로그인 실패", 본문 "..."
```

```
feature/new-api 브랜치에서 main으로 PR 생성해줘
```

### 권한 범위

| 권한 | 용도 |
|------|------|
| `repo` | 비공개 저장소 포함 전체 접근 |
| `public_repo` | 공개 저장소만 접근 |
| `read:org` | 조직 멤버십 읽기 |
| `write:org` | 조직 관리 |
| `read:user` | 사용자 프로필 읽기 |

### 참고

- [GitHub](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- [npm](https://www.npmjs.com/package/@modelcontextprotocol/server-github)

---

## MCP 활성화

### 1. 설정 파일 확인

프로젝트 루트에 `.mcp.json` 파일이 있는지 확인합니다.

### 2. Claude Code 재시작

MCP 서버는 Claude Code 시작 시 로드됩니다.
설정 변경 후 반드시 재시작하세요.

### 3. 상태 확인

```
/mcp
```

### 4. 문제 해결

```
/doctor
```

---

## 사용 팁

### Context7

- 라이브러리 문서가 필요할 때 "use context7" 추가
- 특정 버전 문서가 필요하면 버전 명시
- 예: "React 19 use context7"

### Sequential Thinking

- 복잡한 구현 전에 설계 단계에서 활용
- 여러 접근 방법을 비교할 때 유용
- 디버깅 시 체계적 분석에 활용

### Memory

- 프로젝트 컨텍스트를 영구 저장
- 자주 참조하는 설정, 패턴, 규칙 저장
- 세션 간 연속성 유지

### GitHub

- PR 생성/리뷰 시 변경 파일 분석 요청
- 이슈 목록 조회 후 우선순위 정리
- 코드 검색으로 특정 패턴 사용처 찾기
- 커밋 히스토리로 변경 이력 추적

---

## 라이선스

모든 MCP 서버는 MIT 라이선스로 제공됩니다.
