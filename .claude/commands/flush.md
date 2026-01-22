# flush

CACHE의 내용을 knowledge 파일로 정리합니다.

## 절차

### 1. CACHE 확인
- .claude/CACHE.md 읽기
- Status가 DIRTY인 경우에만 진행
- CLEAN이면 "정리할 내용 없음" 출력 후 종료

### 2. 내용 분류
각 항목을 적절한 knowledge 파일로 분류:

| 내용 유형 | 대상 파일 |
|-----------|-----------|
| 빌드 관련 | .claude/knowledge/BUILD.md |
| 테스트 관련 | .claude/knowledge/TESTING.md |
| 코드 패턴 | .claude/knowledge/PATTERNS.md |
| 규칙/제약 | .claude/knowledge/RULES.md |
| 아키텍처 | .claude/knowledge/ARCHITECTURE.md |

### 3. knowledge 파일 업데이트
- 해당 파일에 내용 추가
- 중복 확인 후 병합

### 4. CACHE 정리
- 이동한 항목 삭제
- Status를 CLEAN으로 변경

## 규칙

- 원본 의미 유지
- 간결하게 정리
- 코드 예제는 보존
