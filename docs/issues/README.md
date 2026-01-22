# Issues

프로젝트에서 발생한 이슈와 해결 내용을 기록합니다.

## 디렉토리 구조

```
docs/issues/
├── README.md        # 이 파일
├── open/            # 미해결 이슈
└── resolved/        # 해결된 이슈
```

## 목적

- 발생한 문제와 해결 방법 기록
- 동일 이슈 재발 시 빠른 참조
- 기술 부채 및 개선 사항 추적

## 사용법

```
/issue                    # 새 이슈 기록 (open/ 에 생성)
/issue build              # 빌드 이슈 기록 (해결 여부에 따라 분류)
/issue resolve <번호>     # 이슈 해결 (resolved/ 로 이동)
/issue list               # 이슈 목록 확인
```

## 파일 명명 규칙

`NNNN-<slug>.md`

- `NNNN`: 4자리 번호 (0001, 0002, ...)
- `<slug>`: 짧은 설명 (kebab-case)
- 예: `0001-api-crash-on-empty-input.md`

## 이슈 템플릿

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

(왜 발생했는가)

## Resolution

(어떻게 해결했는가)

## 관련 파일

- `path/to/file.ts`
```

## 워크플로우

### 일반 이슈

```
이슈 발견
    ↓
/issue → open/0001-xxx.md 생성
    ↓
원인 분석 & 수정
    ↓
/issue resolve 0001 → resolved/0001-xxx.md 로 이동
```

### 빌드 이슈 (`/issue build`)

빌드/테스트 에러 발생 시 해결 여부에 따라 분류:

```
빌드 에러 발생
    ↓
해결 시도
    ↓
┌─────────────────┬─────────────────┐
│    해결됨 ✅     │    미해결 ❌     │
├─────────────────┼─────────────────┤
│ /issue build    │ /issue build    │
│      ↓          │      ↓          │
│ resolved/에     │ open/에 생성    │
│ 직접 생성       │ (도움 요청/추후) │
│ (해결방법 기록) │ (시도한 방법)   │
└─────────────────┴─────────────────┘
```

**등록 시점**:
- ✅ 해결 후: 재발 시 참조용으로 해결 방법 기록
- ❌ 미해결: 도움 요청 또는 나중에 처리하기 위해 기록
