# Debugging Expert

체계적인 디버깅 방법론 전문가 지침입니다.

## 활성화 조건

- 버그 수정 작업 시
- "에러", "버그", "문제", "안됨" 언급 시
- 예상과 다른 동작 분석 시

---

## 7단계 디버깅 프레임워크

```
1. Reproduce  →  2. Isolate  →  3. Hypothesize
      ↓              ↓              ↓
   재현하기       격리하기        가설 세우기

4. Test  →  5. Fix  →  6. Verify  →  7. Document
   ↓          ↓          ↓            ↓
테스트     수정하기    검증하기     문서화
```

### 1. Reproduce (재현)

**목표:** 버그를 100% 재현 가능하게 만들기

```bash
# 재현 조건 기록
- 입력값: ...
- 환경: OS, 버전, 설정
- 순서: 어떤 동작 후 발생?
- 빈도: 항상? 가끔?
```

**체크리스트:**
- [ ] 동일 환경에서 재현 가능?
- [ ] 최소 재현 시나리오 확인?
- [ ] 다른 환경에서도 재현?

### 2. Isolate (격리)

**목표:** 문제 범위를 최소화

**Binary Search Debugging:**
```
전체 코드
    ├── 전반부  ← 문제 있음?
    │     ├── 1/4
    │     └── 2/4  ← 여기!
    └── 후반부
```

**기법:**
- 코드 절반씩 주석 처리
- 기능 하나씩 비활성화
- 입력 단순화

```python
# 복잡한 입력
data = load_complex_json("huge_file.json")

# 단순화된 입력으로 격리
data = {"key": "value"}  # 최소 입력으로 테스트
```

### 3. Hypothesize (가설)

**목표:** 원인에 대한 가설 수립

```markdown
## 가설 목록
1. [ ] NULL 체크 누락
2. [ ] 비동기 타이밍 이슈
3. [ ] 캐시 만료 문제
```

**5 Whys 기법:**
```
문제: 서버가 응답하지 않음
Why 1: 데이터베이스 연결 실패
Why 2: 커넥션 풀 고갈
Why 3: 커넥션 반환 안됨
Why 4: 예외 발생 시 finally 누락
Why 5: 에러 핸들링 패턴 미준수  ← 근본 원인
```

### 4. Test (테스트)

**목표:** 가설 검증

```python
# 가설: NULL 입력 시 크래시
def test_null_input():
    result = process(None)  # 가설 테스트
    assert result is not None
```

**로깅 추가:**
```python
import logging
logging.debug(f"Input: {data}")
logging.debug(f"State before: {state}")
result = suspicious_function(data)
logging.debug(f"State after: {state}")
logging.debug(f"Output: {result}")
```

### 5. Fix (수정)

**목표:** 최소한의 변경으로 수정

**원칙:**
- 한 번에 하나만 변경
- 근본 원인 해결 (증상만 숨기지 않기)
- 사이드 이펙트 최소화

```python
# 나쁨: 증상만 숨김
try:
    result = dangerous_operation()
except:
    pass  # 에러 무시

# 좋음: 근본 원인 해결
if input_data is None:
    raise ValueError("Input cannot be None")
result = dangerous_operation()
```

### 6. Verify (검증)

**목표:** 수정이 올바른지 확인

**체크리스트:**
- [ ] 원래 버그 재현 안됨
- [ ] 기존 테스트 통과
- [ ] 새 회귀 테스트 추가
- [ ] 관련 기능 수동 테스트

```bash
# 회귀 테스트 추가
def test_bug_123_regression():
    """Bug #123: NULL input caused crash"""
    result = process(None)
    assert result == default_value
```

### 7. Document (문서화)

**목표:** 지식 공유 및 재발 방지

```markdown
## Bug #123: NULL 입력 크래시

### 증상
- NULL 입력 시 NullPointerException 발생

### 원인
- process() 함수에서 NULL 체크 누락

### 해결
- NULL 체크 추가 및 기본값 반환

### 예방
- 모든 public API에 입력 검증 추가
- 코드 리뷰 체크리스트에 NULL 체크 항목 추가
```

---

## 디버깅 기법

### Breakpoints

```python
# 조건부 브레이크포인트 (IDE 설정)
# 조건: user_id == 123 and status == "error"

# 코드 내 브레이크포인트
import pdb; pdb.set_trace()  # Python
debugger;  // JavaScript
```

**브레이크포인트 유형:**
| 유형 | 용도 |
|------|------|
| Line | 특정 줄에서 중단 |
| Conditional | 조건 만족 시만 중단 |
| Exception | 예외 발생 시 중단 |
| Data | 변수 값 변경 시 중단 |

### Print/Log Debugging

```python
# 구조화된 디버그 로그
import logging

logging.debug(f"[ENTRY] func_name(arg1={arg1}, arg2={arg2})")
# ... 코드 ...
logging.debug(f"[EXIT] func_name -> {result}")
```

### Rubber Duck Debugging

1. 문제를 소리내어 설명
2. 코드를 한 줄씩 설명
3. 가정을 명시적으로 말하기
4. 설명 중 모순 발견

### Delta Debugging

```
작동하는 버전 (v1) ←→ 버그 있는 버전 (v2)
                    ↓
           중간 지점 테스트
                    ↓
           버그 도입 커밋 발견
```

```bash
# Git bisect
git bisect start
git bisect bad HEAD
git bisect good v1.0
# Git이 자동으로 중간 커밋 체크아웃
# 테스트 후 good/bad 표시 반복
```

---

## 버그 유형별 접근

### NULL/Undefined 에러

```python
# 디버깅
print(f"Variable is: {var}, Type: {type(var)}")

# 예방
def process(data):
    if data is None:
        raise ValueError("data cannot be None")
```

### 비동기/타이밍 이슈

```javascript
// 디버깅: 타임스탬프 로깅
console.log(`[${Date.now()}] Before async call`);
await asyncOperation();
console.log(`[${Date.now()}] After async call`);

// 예방: 명시적 대기
await Promise.all([task1, task2]);
```

### 메모리 누수

```python
# 디버깅
import tracemalloc
tracemalloc.start()
# ... 코드 실행 ...
snapshot = tracemalloc.take_snapshot()
top_stats = snapshot.statistics('lineno')
for stat in top_stats[:10]:
    print(stat)
```

### 성능 문제

```python
# 프로파일링
import cProfile
cProfile.run('slow_function()')

# 시간 측정
import time
start = time.time()
result = slow_function()
print(f"Elapsed: {time.time() - start:.3f}s")
```

---

## 도구

### 일반

| 도구 | 용도 |
|------|------|
| IDE Debugger | 브레이크포인트, 스텝 실행 |
| Git bisect | 버그 도입 커밋 찾기 |
| Logging | 실행 흐름 추적 |

### 언어별

| 언어 | 도구 |
|------|------|
| Python | pdb, ipdb, pudb |
| JavaScript | Chrome DevTools, node --inspect |
| Java | JDB, IntelliJ Debugger |
| C/C++ | GDB, LLDB, Valgrind |

---

## 피해야 할 패턴

| 패턴 | 문제 | 대안 |
|------|------|------|
| 랜덤 수정 | 문제 악화 가능 | 체계적 접근 |
| 에러 무시 | 근본 원인 숨김 | 적절히 처리 |
| 과도한 로깅 | 노이즈 | 전략적 로깅 |
| 재현 없이 수정 | 검증 불가 | 먼저 재현 |

---

## 참고

- [Effective Debugging](https://www.amazon.com/Effective-Debugging-Specific-Software-Development/dp/0134394798)
- [Debugging Techniques](https://www.cisin.com/coffee-break/mastering-debugging-proven-strategies-and-techniques-for-successful-software-troubleshooting.html)
