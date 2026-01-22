# issue

이슈 발생 및 해결 내용을 기록합니다.

## 사용법

```
/issue                    # 새 이슈 기록 (open/ 에 생성)
/issue build              # 빌드 이슈 기록 (해결 여부에 따라 분류)
/issue resolve <번호>     # 이슈 해결 (resolved/ 로 이동)
/issue list               # 이슈 목록 확인
```

## 디렉토리 구조

```
docs/issues/
├── README.md        # 이슈 가이드
├── open/            # 미해결 이슈
│   └── 0001-xxx.md
└── resolved/        # 해결된 이슈
    └── 0002-yyy.md
```

## 절차

### 새 이슈 기록 (`/issue`)

1. `docs/issues/open/` 과 `docs/issues/resolved/` 에서 다음 번호 확인
2. `docs/issues/open/NNNN-<slug>.md` 파일 생성
3. 템플릿에 맞춰 내용 작성

### 이슈 해결 (`/issue resolve <번호>`)

1. `docs/issues/open/` 에서 해당 이슈 파일 찾기
2. 파일 내 Status를 `Resolved`로 변경
3. Resolution 섹션 작성
4. Resolved 날짜 추가
5. 파일을 `docs/issues/resolved/` 로 이동

### 빌드 이슈 기록 (`/issue build`)

빌드/테스트 중 발생한 에러와 해결 방법을 기록합니다.

**등록 시점**:
- ✅ **해결 후**: 해결 방법을 기록하여 재발 시 참조 → `resolved/`에 직접 생성
- ❌ **미해결**: 해결하지 못한 상태로 도움 요청 또는 나중에 처리 → `open/`에 생성

**절차**:

1. 사용자에게 질문: "이슈가 해결되었나요?"
2. **해결된 경우**:
   - `docs/issues/resolved/NNNN-<slug>.md` 파일 생성
   - Status: `Resolved`, Resolved 날짜 포함
   - Resolution 섹션에 해결 방법 상세 작성
3. **미해결인 경우**:
   - `docs/issues/open/NNNN-<slug>.md` 파일 생성
   - Status: `Open`
   - 시도한 방법, 현재 상태 기록

### 이슈 목록 (`/issue list`)

1. `docs/issues/open/` 의 파일 목록 출력 (Open)
2. `docs/issues/resolved/` 의 파일 목록 출력 (Resolved)

## 파일 형식

```markdown
# Issue NNNN: [제목]

**Status**: Open | Resolved
**Created**: YYYY-MM-DD
**Resolved**: YYYY-MM-DD (해결 시)

## 증상

(어떤 문제가 발생했는가)

## 재현 방법

(어떻게 재현할 수 있는가)

## 원인

(왜 발생했는가 - 알게 되면 기록)

## Resolution

(어떻게 해결했는가 - 해결 시 작성)

## 관련 파일

- `path/to/file.ts`

## 참고

(추가 정보, 링크 등)
```

### 빌드 이슈 템플릿

```markdown
# Issue NNNN: [빌드/테스트 에러 제목]

**Status**: Open | Resolved
**Type**: Build
**Created**: YYYY-MM-DD
**Resolved**: YYYY-MM-DD (해결 시)

## 에러 메시지

```
(전체 에러 메시지 복사)
```

## 환경

- OS:
- 언어/런타임 버전:
- 관련 도구 버전:

## 재현 명령어

```bash
(에러를 재현하는 명령어)
```

## 원인

(왜 발생했는가)

## Resolution

(어떻게 해결했는가 - 구체적인 명령어, 설정 변경 등)

## 시도한 방법 (미해결 시)

1. (시도 1) - 결과
2. (시도 2) - 결과

## 관련 파일

- `path/to/file`

## 참고

- (관련 링크, 문서 등)
```

## 파일 명명 규칙

- `NNNN`: 4자리 번호 (0001, 0002, ...)
- `<slug>`: 짧은 설명 (kebab-case)
- 예: `0001-api-crash-on-empty-input.md`

## 규칙

- 이슈 발견 즉시 기록
- 해결 후 반드시 Resolution 작성
- 원인 분석 포함 (재발 방지)
- 해결 시 `resolved/` 디렉토리로 이동
