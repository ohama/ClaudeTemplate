# Git Workflow Expert

Git 버전 관리 및 협업 워크플로우 전문가 지침입니다.

## 활성화 조건

- Git 관련 작업 시 (commit, branch, merge, rebase)
- `/commit` 커맨드 실행 시
- PR 생성 및 리뷰 시

---

## Conventional Commits

커밋 메시지는 다음 형식을 따릅니다:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### 커밋 타입

| Type | 설명 | 예시 |
|------|------|------|
| `feat` | 새로운 기능 | `feat: add user authentication` |
| `fix` | 버그 수정 | `fix: resolve login timeout` |
| `docs` | 문서 변경 | `docs: update API documentation` |
| `style` | 코드 스타일 (포맷팅) | `style: fix indentation` |
| `refactor` | 리팩토링 | `refactor: extract validation logic` |
| `perf` | 성능 개선 | `perf: optimize database queries` |
| `test` | 테스트 추가/수정 | `test: add unit tests for auth` |
| `chore` | 빌드, 설정 변경 | `chore: update dependencies` |
| `ci` | CI/CD 설정 | `ci: add GitHub Actions workflow` |

### 커밋 메시지 규칙

1. **제목은 50자 이내**
2. **명령형 사용**: "Add feature" (O), "Added feature" (X)
3. **마침표 없음**: "Add feature" (O), "Add feature." (X)
4. **본문은 72자 줄바꿈**
5. **Why 설명**: 무엇을 했는지보다 왜 했는지

```bash
# 좋은 예
git commit -m "feat(auth): add JWT token refresh mechanism

Tokens were expiring during long sessions, causing
users to be logged out unexpectedly.

Closes #123"

# 나쁜 예
git commit -m "fixed stuff"
```

---

## 브랜치 전략

### Trunk-Based Development (권장)

```
main ─────●─────●─────●─────●─────●─────
           \   /       \   /
feature-a   ●─●    feature-b
         (짧은 수명)
```

**원칙:**
- `main` 브랜치는 항상 배포 가능 상태
- Feature 브랜치는 1-2일 내 머지
- 작은 단위로 자주 머지
- Feature Flag로 미완성 기능 숨김

**장점:**
- 머지 충돌 최소화
- 28% 빠른 프로젝트 딜리버리 (연구 결과)

### GitFlow (복잡한 릴리스 관리)

```
main     ─────●───────────────●─────────
              │               │
release  ─────┼───●───────────┼─────────
              │   │           │
develop  ●────●───●───●───●───●─────────
          \       /   \   /
feature    ●─────●     ●─●
```

**브랜치:**
- `main`: 프로덕션 코드
- `develop`: 개발 통합
- `feature/*`: 기능 개발
- `release/*`: 릴리스 준비
- `hotfix/*`: 긴급 수정

---

## AFTER 원칙

| 원칙 | 설명 |
|------|------|
| **A**tomic | 하나의 논리적 변경만 포함 |
| **F**requent | 자주 커밋 (작업 손실 방지) |
| **T**est | 푸시 전 테스트 실행 |
| **E**nforce | 표준 강제 (hooks, linter) |
| **R**efactoring | 리팩토링은 기능과 분리 |

---

## Branch Protection

### main 브랜치 보호 규칙

```yaml
# 권장 설정
- 직접 푸시 금지
- PR 필수
- 최소 1명 승인 필요
- CI 통과 필수
- 브랜치 최신 상태 필수
```

### Git Hooks

```bash
# .git/hooks/commit-msg (commitlint)
#!/bin/sh
npx --no-install commitlint --edit "$1"

# .git/hooks/pre-commit
#!/bin/sh
npm run lint && npm run test
```

---

## 자주 사용하는 명령어

### 브랜치 작업

```bash
# 브랜치 생성 및 이동
git checkout -b feature/user-auth

# 원격 브랜치 추적
git checkout -b feature/x origin/feature/x

# 브랜치 삭제
git branch -d feature/done
git push origin --delete feature/done
```

### Rebase vs Merge

```bash
# Rebase (깔끔한 히스토리)
git checkout feature/x
git rebase main
git checkout main
git merge feature/x

# Merge (히스토리 보존)
git checkout main
git merge --no-ff feature/x
```

### 실수 복구

```bash
# 마지막 커밋 수정 (푸시 전)
git commit --amend

# 스테이징 취소
git reset HEAD <file>

# 커밋 취소 (변경사항 유지)
git reset --soft HEAD~1

# 특정 커밋으로 파일 복원
git checkout <commit> -- <file>
```

---

## PR (Pull Request) 가이드

### PR 크기

- **200-400 LOC** 권장
- 큰 기능은 여러 PR로 분할
- 작은 PR = 빠른 리뷰 = 적은 버그

### PR 템플릿

```markdown
## Summary
- 변경 사항 요약 (1-3줄)

## Changes
- [ ] 변경 1
- [ ] 변경 2

## Test Plan
- [ ] 단위 테스트 추가
- [ ] 수동 테스트 완료

## Screenshots (UI 변경 시)

## Related Issues
Closes #123
```

---

## 피해야 할 패턴

| 패턴 | 문제 | 대안 |
|------|------|------|
| `git add .` | 의도치 않은 파일 포함 | 파일 명시적 추가 |
| `git push -f` | 히스토리 손상 | `--force-with-lease` |
| 큰 커밋 | 리뷰 어려움 | 작은 단위로 분할 |
| "WIP" 커밋 | 불명확한 히스토리 | squash 후 머지 |
| 오래된 브랜치 | 머지 충돌 | 1-2일 내 머지 |

---

## 참고

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Best Practices](https://acompiler.com/git-best-practices/)
