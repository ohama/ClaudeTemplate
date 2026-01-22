# Property-Based Testing Expert

Property-Based Testing (PBT) 및 Fuzzing 전문가 지침입니다.

## 활성화 조건

- 테스트 작성 시 (특히 복잡한 로직)
- "edge case", "random testing", "fuzzing" 언급 시
- 기존 단위 테스트 보완 필요 시

---

## 핵심 개념

### Unit Test vs Property-Based Test

| 구분 | Unit Test | Property-Based Test |
|------|-----------|---------------------|
| 입력 | 개발자가 직접 지정 | 자동 생성 (랜덤) |
| 검증 | 특정 출력값 확인 | 속성(Property) 만족 확인 |
| 커버리지 | 예상 케이스만 | 예상치 못한 케이스 발견 |
| 장점 | 명확, 빠름 | 버그 발견력 높음 |

```python
# Unit Test
def test_reverse_specific():
    assert reverse([1, 2, 3]) == [3, 2, 1]

# Property-Based Test
@given(lists(integers()))
def test_reverse_property(xs):
    assert reverse(reverse(xs)) == xs  # 속성: 두 번 뒤집으면 원본
```

---

## Property 유형

### 1. Roundtrip (왕복)

```
encode → decode = 원본
serialize → deserialize = 원본
compress → decompress = 원본
```

```python
@given(st.binary())
def test_compression_roundtrip(data):
    assert decompress(compress(data)) == data
```

### 2. Invariant (불변)

```
정렬 후 길이 = 정렬 전 길이
변환 후에도 유지되어야 하는 속성
```

```python
@given(lists(integers()))
def test_sort_preserves_length(xs):
    assert len(sorted(xs)) == len(xs)
```

### 3. Idempotent (멱등)

```
f(f(x)) = f(x)
정렬을 두 번 해도 결과 동일
```

```python
@given(lists(integers()))
def test_sort_idempotent(xs):
    assert sorted(xs) == sorted(sorted(xs))
```

### 4. Metamorphic (변환 관계)

```
f(x) 와 f(transform(x)) 사이의 관계
```

```python
@given(st.integers(), st.integers())
def test_addition_commutative(a, b):
    assert add(a, b) == add(b, a)  # 교환법칙
```

### 5. Oracle (참조 구현)

```
최적화된 구현 vs 단순한 참조 구현
결과가 동일해야 함
```

```python
@given(lists(integers()))
def test_quicksort_matches_builtin(xs):
    assert quicksort(xs) == sorted(xs)
```

---

## Shrinking (축소)

실패 입력을 **최소한으로 축소**하여 디버깅 용이하게 만듦.

```
실패 입력: [847, -32, 0, 999, 42, ...]  (100개 요소)
          ↓ shrinking
최소 입력: [0, -1]  (2개 요소로 같은 버그 재현)
```

**장점:**
- 버그 원인 파악 용이
- 단위 테스트로 변환 가능

---

## Fuzzing vs Property Testing

| 구분 | Fuzzing | Property Testing |
|------|---------|------------------|
| 접근 | Black-box | White-box |
| 입력 생성 | 바이트 뮤테이션 | 타입 기반 생성 |
| 가이드 | 코드 커버리지 | 개발자 정의 속성 |
| 실행 시간 | 장시간 (hours) | 짧음 (unit test급) |
| 발견 버그 | 크래시, 메모리 | 로직 오류 |

### Coverage-Guided Fuzzing

```
1. 랜덤 입력 생성
2. 실행 & 커버리지 측정
3. 새 경로 발견 시 입력 저장
4. 저장된 입력 뮤테이션
5. 반복
```

---

## 언어별 도구

### Python - Hypothesis

```python
from hypothesis import given, strategies as st

@given(st.lists(st.integers()))
def test_reverse_twice(xs):
    assert list(reversed(list(reversed(xs)))) == xs

# 커스텀 전략
@st.composite
def valid_email(draw):
    name = draw(st.text(min_size=1, alphabet=string.ascii_lowercase))
    domain = draw(st.sampled_from(["gmail.com", "test.org"]))
    return f"{name}@{domain}"

@given(valid_email())
def test_email_contains_at(email):
    assert "@" in email
```

### F# - FsCheck

```fsharp
open FsCheck

let ``reverse twice is identity`` (xs: int list) =
    List.rev (List.rev xs) = xs

Check.Quick ``reverse twice is identity``

// 커스텀 생성기
type ValidEmail = ValidEmail of string

type Generators =
    static member ValidEmail() =
        gen {
            let! name = Arb.generate<string> |> Gen.filter (not << String.IsNullOrEmpty)
            let! domain = Gen.elements ["gmail.com"; "test.org"]
            return ValidEmail $"{name}@{domain}"
        } |> Arb.fromGen
```

### Rust - proptest

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn reverse_twice_is_identity(xs: Vec<i32>) {
        let reversed: Vec<_> = xs.iter().rev().rev().cloned().collect();
        prop_assert_eq!(xs, reversed);
    }
}
```

### JavaScript - fast-check

```javascript
const fc = require('fast-check');

test('reverse twice is identity', () => {
  fc.assert(
    fc.property(fc.array(fc.integer()), (xs) => {
      const reversed = [...xs].reverse().reverse();
      return JSON.stringify(xs) === JSON.stringify(reversed);
    })
  );
});
```

---

## Best Practices

### 1. 명확한 속성 정의

```python
# 나쁨: 너무 약한 속성
@given(st.integers())
def test_weak(x):
    assert isinstance(process(x), int)  # 타입만 확인

# 좋음: 강한 속성
@given(st.integers())
def test_strong(x):
    result = process(x)
    assert result >= x  # 의미 있는 관계
    assert result % 2 == 0  # 구체적 속성
```

### 2. Assertion 활용

코드 내부에 assertion 추가 → PBT가 자동 검증

```python
def binary_search(arr, target):
    assert arr == sorted(arr), "Array must be sorted"
    # ... 구현
```

### 3. 기존 테스트와 병행

```python
# 구체적 케이스는 Unit Test
def test_empty_list():
    assert reverse([]) == []

# 일반 속성은 Property Test
@given(lists(integers()))
def test_reverse_property(xs):
    assert reverse(reverse(xs)) == xs
```

### 4. CI/CD 통합

```yaml
# GitHub Actions
- name: Run property tests
  run: pytest --hypothesis-profile=ci

# hypothesis profile (conftest.py)
from hypothesis import settings
settings.register_profile("ci", max_examples=1000)
```

---

## 피해야 할 패턴

| 패턴 | 문제 | 대안 |
|------|------|------|
| 너무 약한 속성 | 버그 못 잡음 | 강한 속성 정의 |
| 너무 복잡한 생성기 | 유지보수 어려움 | 단순하게 시작 |
| 느린 테스트 | CI 지연 | 예제 수 조절 |
| shrinking 무시 | 디버깅 어려움 | shrunk 입력 분석 |

---

## 참고

- [Hypothesis Documentation](https://hypothesis.readthedocs.io/)
- [Property-Based Testing is Fuzzing](https://blog.nelhage.com/post/property-testing-is-fuzzing/)
- [Fuzzing vs Property Testing](https://www.tedinski.com/2018/12/11/fuzzing-and-property-testing.html)
