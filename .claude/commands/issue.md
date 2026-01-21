# issue

이슈 발생 및 해결 내용을 기록합니다.

## 사용법

```
/issue                    # 새 이슈 기록
/issue resolve <번호>     # 이슈 해결 기록
```

## 절차

### 새 이슈 기록

1. `docs/issues/` 디렉토리 확인 (없으면 생성)
2. 다음 이슈 번호 확인 (기존 파일들에서)
3. `docs/issues/NNNN-<slug>.md` 파일 생성
4. 템플릿에 맞춰 내용 작성

### 이슈 해결 기록

1. 해당 이슈 파일 열기
2. Status를 `Resolved`로 변경
3. Resolution 섹션 작성
4. Resolved 날짜 추가

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

(어떻게 해결했는가)

## 관련 파일

- `path/to/file.ts`

## 참고

(추가 정보, 링크 등)
```

## 파일 명명 규칙

- `NNNN`: 4자리 번호 (0001, 0002, ...)
- `<slug>`: 짧은 설명 (kebab-case)
- 예: `0001-api-crash-on-empty-input.md`

## 규칙

- 이슈 발견 즉시 기록
- 해결 후 반드시 Resolution 작성
- 원인 분석 포함 (재발 방지)
