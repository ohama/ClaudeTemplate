# tdd

TDD (Test-Driven Development) 사이클을 실행합니다.

## 참조

- `.claude/skills/tdd.md` - TDD 상세 가이드
- `.claude/skills/property-testing.md` - Property-Based Testing (선택적)

## 실행

`.claude/skills/tdd.md`의 Red-Green-Refactor 사이클을 수행:

1. **Red**: 실패하는 테스트 작성 → 실패 확인
2. **Green**: 최소한의 구현 → 통과 확인
3. **Refactor**: 코드 개선 → 통과 유지 확인

## 완료 후

- `.claude/STATE.md` 업데이트 (Evidence에 테스트 결과)
- `.claude/CACHE.md`에 발견 사항 기록 (필요시)

## 핵심 규칙

> 상세 규칙은 `.claude/skills/tdd.md` 참조

- 테스트 없이 프로덕션 코드 작성 금지
- 한 번에 하나의 테스트만 작성
- 버그 수정 시 재현 테스트부터 작성
- 리팩토링 중에는 새 기능 추가 금지
