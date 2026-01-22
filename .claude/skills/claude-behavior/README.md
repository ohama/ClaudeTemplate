# Claude Behavior Skills

Claude의 내부 동작 방식을 정의하는 메타 스킬입니다.

## 포함 스킬

| 파일 | 설명 |
|------|------|
| `history.md` | HISTORY.md 요약 및 기록 방식 |
| `build-issues.md` | 빌드/테스트 에러 자동 이슈 기록 |

## 활성화 조건

- `/endsession`, `/historyupdate` 실행 시 → `history.md`
- 빌드/테스트 에러 발생 시 → `build-issues.md`

## 용도

일반 스킬이 "기술 전문성"을 정의한다면,
이 메타 스킬은 "Claude가 자신을 어떻게 운영할지"를 정의합니다.

```
skills/
├── fsharp.md              # F# 코드 작성 방법
├── tdd.md                 # TDD 방법론
└── claude-behavior/       # Claude 운영 방식
    ├── logging.md         # 로깅 규칙
    └── history.md         # 히스토리 관리 규칙
```
