# TESTING

프로젝트 테스트 관련 정보입니다.

## 테스트 프레임워크

(사용하는 테스트 프레임워크)

## 기본 명령어

```bash
# 모든 테스트 실행
(테스트 명령어)

# 특정 테스트 필터
(필터 명령어)

# 커버리지
(커버리지 명령어)
```

## 테스트 분류

| 분류 | 설명 | 위치 |
|------|------|------|
| Unit | 단위 테스트 | `tests/unit/` |
| Integration | 통합 테스트 | `tests/integration/` |
| E2E | 전체 파이프라인 | `tests/e2e/` |

## 테스트 작성 가이드

### 명명 규칙

```
<Module>_<Scenario>_<Expected>
예: UserService_InvalidEmail_ThrowsError
```

### 테스트 구조 (AAA)

```
// Arrange
(준비)

// Act
(실행)

// Assert
(검증)
```

## E2E 테스트 구조

```
tests/e2e/
├── cases/
│   ├── (카테고리)/
│   │   ├── (입력 파일)
│   │   └── (기대 출력)
```

## 참고

- 새로운 테스트 정보 발견 시 이 문서에 추가
- `/flush` 명령으로 CACHE에서 이동됨
