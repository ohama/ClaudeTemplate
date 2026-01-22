# CI/CD Expert

지속적 통합 및 배포 파이프라인 전문가 지침입니다.

## 활성화 조건

- CI/CD 파이프라인 설정 시
- GitHub Actions, Jenkins 등 작업 시
- "파이프라인", "자동화", "배포" 언급 시

---

## 핵심 개념

### CI (Continuous Integration)

```
코드 변경 → 자동 빌드 → 자동 테스트 → 피드백
     │          │           │          │
   Push      Build       Test     Pass/Fail
```

**원칙:**
- 자주 통합 (하루 여러 번)
- 모든 커밋에 빌드/테스트
- 빠른 피드백 (10분 이내)
- 실패 시 즉시 수정

### CD (Continuous Deployment/Delivery)

```
CI 통과 → 스테이징 배포 → 테스트 → 프로덕션 배포
             │              │           │
         자동/수동       자동 E2E    자동/수동
```

| 구분 | Continuous Delivery | Continuous Deployment |
|------|--------------------|-----------------------|
| 프로덕션 배포 | 수동 승인 | 완전 자동 |
| 적합한 경우 | 규제 산업, 보수적 | 빠른 릴리스 필요 |

---

## 파이프라인 구조

### 기본 단계

```yaml
Pipeline:
  1. Checkout     # 코드 체크아웃
  2. Install      # 의존성 설치
  3. Lint         # 코드 스타일 검사
  4. Build        # 빌드
  5. Test         # 테스트 (unit, integration)
  6. Security     # 보안 스캔
  7. Package      # 아티팩트 생성
  8. Deploy       # 배포
```

### GitHub Actions 예시

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm test -- --coverage
      - uses: codecov/codecov-action@v3

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/

  deploy-staging:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/develop'
    environment: staging
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: build
      - run: ./deploy.sh staging

  deploy-production:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
      - uses: actions/download-artifact@v4
        with:
          name: build
      - run: ./deploy.sh production
```

---

## Git Hooks

로컬에서 커밋/푸시 전 자동 검증.

### Pre-commit

```bash
#!/bin/sh
# .git/hooks/pre-commit

# Lint 검사
npm run lint
if [ $? -ne 0 ]; then
  echo "Lint failed. Fix errors before committing."
  exit 1
fi

# 테스트 실행
npm test
if [ $? -ne 0 ]; then
  echo "Tests failed. Fix tests before committing."
  exit 1
fi
```

### Commit-msg (Conventional Commits)

```bash
#!/bin/sh
# .git/hooks/commit-msg

# commitlint으로 메시지 검증
npx --no-install commitlint --edit "$1"
```

### Husky + lint-staged (Node.js)

```json
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS"
    }
  },
  "lint-staged": {
    "*.{js,ts}": ["eslint --fix", "prettier --write"],
    "*.{json,md}": ["prettier --write"]
  }
}
```

---

## Branch Protection

### GitHub 설정

```yaml
Branch protection rules (main):
  ✓ Require pull request before merging
    - Required approving reviews: 1
    - Dismiss stale reviews
  ✓ Require status checks to pass
    - lint
    - test
    - build
  ✓ Require branches to be up to date
  ✓ Require signed commits (optional)
  ✓ Do not allow bypassing
```

### CODEOWNERS

```
# .github/CODEOWNERS

# 전체 코드 기본 리뷰어
* @team-lead

# 특정 디렉토리
/src/api/ @backend-team
/src/ui/ @frontend-team
/infrastructure/ @devops-team

# 특정 파일
package.json @tech-lead
Dockerfile @devops-team
```

---

## 테스트 전략

### 테스트 피라미드

```
         /\
        /  \  E2E (느림, 비쌈)
       /----\
      /      \  Integration
     /--------\
    /          \  Unit (빠름, 저렴)
   /______________\
```

### CI에서의 테스트

```yaml
test:
  parallel:
    - unit-tests:        # 빠름, 항상 실행
        run: npm run test:unit
        timeout: 5m

    - integration-tests: # 중간, PR에서 실행
        run: npm run test:integration
        timeout: 15m

    - e2e-tests:         # 느림, main 머지 시만
        run: npm run test:e2e
        timeout: 30m
        if: branch == 'main'
```

### 테스트 병렬화

```yaml
# Jest 병렬 실행
test:
  strategy:
    matrix:
      shard: [1, 2, 3, 4]
  steps:
    - run: npm test -- --shard=${{ matrix.shard }}/4
```

---

## 환경 관리

### 환경 분리

```
Development → Staging → Production
     │           │           │
   자동배포    자동배포    수동승인
   테스트DB   스테이징DB  프로덕션DB
```

### 시크릿 관리

```yaml
# GitHub Secrets 사용
steps:
  - run: ./deploy.sh
    env:
      API_KEY: ${{ secrets.API_KEY }}
      DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
```

**절대 하지 말 것:**
```yaml
# 나쁨: 하드코딩
env:
  API_KEY: "sk-abc123..."  # ← 절대 금지!
```

---

## 배포 전략

### Rolling Update

```
v1 [●●●●] → v1 [●●●○] v2 [○] → v1 [●●○○] v2 [○○] → v2 [●●●●]
```

### Blue-Green

```
Blue (v1) [●●●●] ← Traffic
Green (v2) [○○○○]

배포 후:
Blue (v1) [○○○○]
Green (v2) [●●●●] ← Traffic
```

### Canary

```
v1 [●●●●●●●●●] 90%
v2 [●]           10% ← 점진적 증가
```

---

## 모니터링 & 롤백

### 배포 후 확인

```yaml
deploy:
  steps:
    - run: ./deploy.sh
    - name: Health Check
      run: |
        for i in {1..30}; do
          if curl -s $URL/health | grep -q "ok"; then
            echo "Deployment successful"
            exit 0
          fi
          sleep 10
        done
        echo "Health check failed"
        exit 1

    - name: Smoke Test
      run: npm run test:smoke

    - name: Rollback on Failure
      if: failure()
      run: ./rollback.sh
```

### 자동 롤백

```yaml
- name: Monitor Error Rate
  run: |
    ERROR_RATE=$(curl -s $METRICS_URL/error_rate)
    if (( $(echo "$ERROR_RATE > 0.05" | bc -l) )); then
      echo "Error rate too high, rolling back"
      ./rollback.sh
      exit 1
    fi
```

---

## Best Practices

### 파이프라인 속도

| 단계 | 목표 시간 |
|------|----------|
| Lint | < 1분 |
| Unit Test | < 5분 |
| Build | < 5분 |
| Integration Test | < 10분 |
| 전체 | < 15분 |

### 캐싱

```yaml
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: npm-${{ hashFiles('package-lock.json') }}
    restore-keys: npm-
```

### 의존성 업데이트

```yaml
# Dependabot 설정
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: npm
    directory: /
    schedule:
      interval: weekly
    open-pull-requests-limit: 10
```

---

## 피해야 할 패턴

| 패턴 | 문제 | 대안 |
|------|------|------|
| 느린 파이프라인 | 피드백 지연 | 병렬화, 캐싱 |
| 시크릿 하드코딩 | 보안 위험 | 시크릿 관리 도구 |
| 테스트 스킵 | 버그 유입 | 필수 체크 설정 |
| 수동 배포 | 휴먼 에러 | 자동화 |
| 롤백 계획 없음 | 장애 대응 지연 | 자동 롤백 설정 |

---

## 참고

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [CI/CD Best Practices](https://www.atlassian.com/continuous-delivery/principles/continuous-integration-vs-delivery-vs-deployment)
