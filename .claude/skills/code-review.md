# Code Review Expert

효과적인 코드 리뷰 전문가 지침입니다.

## 활성화 조건

- PR 리뷰 요청 시
- 코드 리뷰 체크리스트 필요 시
- "리뷰", "PR", "pull request" 언급 시

---

## 8대 리뷰 항목

### 1. Functionality (기능)

- [ ] 요구사항을 올바르게 구현했는가?
- [ ] 엣지 케이스를 처리하는가?
- [ ] 에러 상황에서 적절히 동작하는가?

```python
# 체크: NULL/빈 입력 처리
def process(data):
    if not data:  # ← 이 체크가 있는가?
        return default_value
    # ...
```

### 2. Readability (가독성)

- [ ] 코드가 자기 설명적인가?
- [ ] 변수/함수 이름이 명확한가?
- [ ] 복잡한 로직에 주석이 있는가?

```python
# 나쁨
def calc(a, b, c):
    return a * b - c

# 좋음
def calculate_discounted_price(quantity, unit_price, discount):
    return quantity * unit_price - discount
```

### 3. Security (보안)

- [ ] 입력 검증이 있는가?
- [ ] SQL Injection 방지?
- [ ] XSS 방지?
- [ ] 민감 정보 노출 없는가?

```python
# 위험: SQL Injection
query = f"SELECT * FROM users WHERE id = {user_id}"

# 안전: 파라미터화
query = "SELECT * FROM users WHERE id = %s"
cursor.execute(query, (user_id,))
```

### 4. Performance (성능)

- [ ] 불필요한 루프/쿼리 없는가?
- [ ] N+1 쿼리 문제 없는가?
- [ ] 적절한 자료구조 사용?
- [ ] 캐싱이 필요한가?

```python
# 나쁨: N+1 쿼리
for user in users:
    orders = db.query(f"SELECT * FROM orders WHERE user_id = {user.id}")

# 좋음: JOIN 또는 batch 쿼리
orders = db.query("SELECT * FROM orders WHERE user_id IN (...)")
```

### 5. Error Handling (에러 처리)

- [ ] 예외가 적절히 처리되는가?
- [ ] 에러 메시지가 유용한가?
- [ ] 리소스 정리가 보장되는가?

```python
# 나쁨
try:
    result = risky_operation()
except:
    pass  # 에러 무시

# 좋음
try:
    result = risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise UserFriendlyError("처리 중 오류가 발생했습니다")
finally:
    cleanup_resources()
```

### 6. Testing (테스트)

- [ ] 새 코드에 테스트가 있는가?
- [ ] 엣지 케이스 테스트?
- [ ] 기존 테스트가 통과하는가?
- [ ] 테스트 커버리지 적절한가?

```python
# 필요한 테스트 케이스
def test_normal_case(): ...
def test_empty_input(): ...
def test_invalid_input(): ...
def test_boundary_values(): ...
```

### 7. Standards (표준)

- [ ] 코딩 스타일 가이드 준수?
- [ ] 네이밍 컨벤션 준수?
- [ ] 프로젝트 패턴과 일관성?

```python
# 프로젝트 컨벤션 체크
# - snake_case vs camelCase
# - 들여쓰기 (spaces vs tabs)
# - import 순서
# - 파일 구조
```

### 8. Architecture (아키텍처)

- [ ] 적절한 레이어에 코드가 있는가?
- [ ] 의존성 방향이 올바른가?
- [ ] 재사용 가능한 설계인가?
- [ ] 확장성 고려?

```
# 의존성 방향 체크
Controller → Service → Repository → Database
     ↓          ↓           ↓
   (OK)       (OK)        (OK)

Repository → Controller  ← 잘못된 방향!
```

---

## 리뷰 프로세스

### PR 크기

| LOC | 권장 |
|-----|------|
| < 200 | 이상적 |
| 200-400 | 적정 |
| 400-800 | 분할 고려 |
| > 800 | 분할 필수 |

**연구 결과:** 200-400 LOC에서 결함 발견율 최고

### Self-Review 먼저

PR 제출 전 저자가 먼저 리뷰:

```markdown
## Self-Review Checklist
- [ ] 코드가 의도대로 동작하는가?
- [ ] 테스트를 작성했는가?
- [ ] 불필요한 console.log/print 제거?
- [ ] TODO 주석 해결?
- [ ] 문서 업데이트?
```

### 리뷰 시간

- **즉시 리뷰**: 4시간 이내 응답 목표
- **리뷰 시간**: PR당 30분-1시간
- **집중**: 한 번에 60분 이상 리뷰 금지 (효율 저하)

---

## 피드백 가이드

### 심리적 안전

```markdown
# 나쁨 (비난)
"이게 뭐야? 왜 이렇게 짰어?"

# 좋음 (건설적)
"이 부분을 `X` 방식으로 변경하면 가독성이 좋아질 것 같아요.
예시: `코드 예시`"
```

### 코멘트 유형

| 접두사 | 의미 | 예시 |
|--------|------|------|
| `[MUST]` | 반드시 수정 | 보안 취약점, 버그 |
| `[SHOULD]` | 강력 권장 | 성능, 가독성 |
| `[NIT]` | 사소한 제안 | 스타일, 네이밍 |
| `[QUESTION]` | 이해 확인 | 의도 질문 |

```markdown
[MUST] SQL Injection 취약점이 있습니다.
파라미터화된 쿼리를 사용해주세요.

[SHOULD] 이 로직을 별도 함수로 분리하면
테스트하기 쉬워질 것 같습니다.

[NIT] `data` 보다 `user_data`가 더 명확할 것 같아요.

[QUESTION] 이 타임아웃 값(5초)의 근거가 있나요?
```

### 칭찬도 포함

```markdown
"깔끔한 구현이네요! 특히 에러 처리 부분이 잘 되어 있어요."

"좋은 테스트 케이스입니다. 엣지 케이스까지 잘 커버했네요."
```

---

## 자동화

### Pre-commit Hooks

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    hooks:
      - id: trailing-whitespace
      - id: check-yaml
  - repo: https://github.com/psf/black
    hooks:
      - id: black
```

### CI 체크

```yaml
# GitHub Actions
name: PR Check
on: [pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm test
```

### 자동 리뷰어 할당

```yaml
# .github/CODEOWNERS
*.py @python-team
*.ts @frontend-team
/api/ @backend-team
```

---

## 체크리스트 템플릿

```markdown
## Code Review Checklist

### Functionality
- [ ] 요구사항 구현 완료
- [ ] 엣지 케이스 처리
- [ ] 에러 상황 처리

### Quality
- [ ] 코드 가독성
- [ ] 적절한 네이밍
- [ ] 중복 코드 없음

### Security
- [ ] 입력 검증
- [ ] 인증/인가 확인
- [ ] 민감 정보 보호

### Testing
- [ ] 단위 테스트 추가
- [ ] 기존 테스트 통과

### Documentation
- [ ] 필요시 문서 업데이트
- [ ] API 변경 시 명세 업데이트
```

---

## 피해야 할 패턴

| 패턴 | 문제 | 대안 |
|------|------|------|
| 큰 PR | 리뷰 품질 저하 | 작은 단위로 분할 |
| LGTM만 | 실질적 리뷰 없음 | 체크리스트 사용 |
| 개인 공격 | 팀 분위기 악화 | 코드에 집중 |
| 지연된 리뷰 | 개발 흐름 방해 | 4시간 내 응답 |
| 스타일 논쟁 | 시간 낭비 | 린터로 자동화 |

---

## 참고

- [Code Review Checklist](https://www.codereviewchecklist.com/)
- [Google Code Review Guidelines](https://google.github.io/eng-practices/review/)
- [Code Review Best Practices 2025](https://www.qodo.ai/blog/code-review-best-practices/)
