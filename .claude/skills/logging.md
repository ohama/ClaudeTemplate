# Structured Logging Expert

구조화된 로깅 및 Observability 전문가 지침입니다.

## 활성화 조건

- 로깅 코드 작성 시
- 디버깅/모니터링 설정 시
- "로그", "트레이싱", "observability" 언급 시

---

## 핵심 원칙

### Unstructured vs Structured Logging

```python
# Unstructured (나쁨)
logger.info(f"User {user_id} logged in from {ip}")
# 출력: "User 123 logged in from 192.168.1.1"
# → 파싱 어려움, 검색 비효율

# Structured (좋음)
logger.info("User logged in", extra={
    "user_id": user_id,
    "ip": ip,
    "event": "login"
})
# 출력: {"message": "User logged in", "user_id": 123, "ip": "192.168.1.1", "event": "login"}
# → 쉬운 쿼리, 필터링, 분석
```

---

## Log Levels

| Level | 용도 | 예시 |
|-------|------|------|
| `DEBUG` | 개발 중 상세 정보 | 변수 값, 함수 진입/종료 |
| `INFO` | 정상 동작 기록 | 요청 처리 완료, 작업 시작 |
| `WARN` | 잠재적 문제 | 재시도 발생, 지연 |
| `ERROR` | 오류 발생 | 예외, 실패한 작업 |
| `FATAL` | 시스템 중단 | 복구 불가능한 오류 |

```python
# 적절한 레벨 사용
logger.debug(f"Processing item {i} of {total}")  # 개발용
logger.info("Order created", extra={"order_id": order_id})  # 운영 이벤트
logger.warning("API rate limit approaching", extra={"remaining": 10})
logger.error("Payment failed", extra={"order_id": order_id, "error": str(e)})
```

### 레벨 선택 가이드

```
DEBUG: 이 정보가 문제 해결에 필요한가?
INFO:  이 이벤트가 비즈니스적으로 중요한가?
WARN:  지금은 괜찮지만 나중에 문제가 될 수 있는가?
ERROR: 작업이 실패했는가?
FATAL: 시스템이 계속 실행될 수 있는가?
```

---

## Correlation ID

분산 시스템에서 요청 추적을 위한 고유 ID.

```
Client → API Gateway → Service A → Service B → Database
           │              │           │
           └──────────────┴───────────┴── 동일한 correlation_id
```

### 구현

```python
import uuid
from contextvars import ContextVar

correlation_id: ContextVar[str] = ContextVar('correlation_id')

# 미들웨어에서 설정
def middleware(request, next):
    cid = request.headers.get('X-Correlation-ID', str(uuid.uuid4()))
    correlation_id.set(cid)
    response = next(request)
    response.headers['X-Correlation-ID'] = cid
    return response

# 로깅 시 자동 포함
class CorrelationFilter(logging.Filter):
    def filter(self, record):
        record.correlation_id = correlation_id.get('')
        return True
```

```json
{"message": "Order created", "correlation_id": "abc-123", "service": "order-api"}
{"message": "Payment processed", "correlation_id": "abc-123", "service": "payment-api"}
{"message": "Email sent", "correlation_id": "abc-123", "service": "notification-api"}
```

---

## 로그 스키마 표준화

### OpenTelemetry Semantic Conventions

```json
{
  "timestamp": "2025-01-22T10:30:00.000Z",
  "severity": "INFO",
  "body": "HTTP request completed",
  "attributes": {
    "http.method": "GET",
    "http.route": "/api/users/:id",
    "http.status_code": 200,
    "http.duration_ms": 45,
    "user.id": "123",
    "trace_id": "abc123",
    "span_id": "def456"
  }
}
```

### 필수 필드

| 필드 | 설명 |
|------|------|
| `timestamp` | ISO 8601 형식 |
| `severity` / `level` | 로그 레벨 |
| `message` / `body` | 로그 메시지 |
| `service.name` | 서비스 식별자 |
| `trace_id` | 분산 추적 ID |

---

## Context Enrichment

로그에 자동으로 컨텍스트 추가.

```python
# Python - structlog
import structlog

logger = structlog.get_logger()
log = logger.bind(
    service="order-api",
    environment="production",
    version="1.2.3"
)

# 요청 스코프 컨텍스트
with structlog.contextvars.bound_contextvars(
    user_id=current_user.id,
    request_id=request.id
):
    log.info("Processing order")
    # 모든 로그에 user_id, request_id 자동 포함
```

```javascript
// JavaScript - pino
const logger = pino({
  base: {
    service: 'order-api',
    env: process.env.NODE_ENV
  }
});

// 요청별 child logger
app.use((req, res, next) => {
  req.log = logger.child({
    requestId: req.id,
    userId: req.user?.id
  });
  next();
});
```

---

## Best Practices

### 1. 무엇을 로깅할 것인가

**로깅해야 하는 것:**
- 요청 시작/종료 (duration 포함)
- 중요 비즈니스 이벤트 (주문, 결제, 가입)
- 에러 및 예외 (스택 트레이스 포함)
- 외부 서비스 호출
- 보안 이벤트 (로그인, 권한 변경)

**로깅하면 안 되는 것:**
- 비밀번호, API 키, 토큰
- 개인정보 (PII) - 마스킹 필요
- 대용량 데이터 (base64 이미지 등)

```python
# 민감 정보 마스킹
def mask_pii(data):
    return {
        **data,
        "email": data["email"][:3] + "***@***",
        "phone": "***-****-" + data["phone"][-4:]
    }

logger.info("User registered", extra=mask_pii(user_data))
```

### 2. 에러 로깅

```python
try:
    result = risky_operation()
except Exception as e:
    logger.exception(  # 자동으로 스택 트레이스 포함
        "Operation failed",
        extra={
            "operation": "risky_operation",
            "input": sanitize(input_data),
            "error_type": type(e).__name__
        }
    )
    raise
```

### 3. 성능 로깅

```python
import time

start = time.perf_counter()
result = slow_operation()
duration_ms = (time.perf_counter() - start) * 1000

logger.info("Operation completed", extra={
    "operation": "slow_operation",
    "duration_ms": round(duration_ms, 2),
    "result_size": len(result)
})
```

### 4. 샘플링

```python
import random

# 높은 볼륨 로그는 샘플링
if random.random() < 0.1:  # 10% 샘플
    logger.debug("High volume event", extra={...})
```

---

## 도구 및 스택

### 로깅 라이브러리

| 언어 | 라이브러리 |
|------|-----------|
| Python | structlog, loguru |
| JavaScript | pino, winston |
| Go | zap, zerolog |
| Java | Logback + SLF4J |
| .NET | Serilog |

### 중앙 집중화

```
Application → Collector → Storage → Query/Alert
    │            │           │          │
 structlog   Fluentd      Elastic    Kibana
 pino        Logstash     Loki       Grafana
 zap         Vector       ClickHouse
```

### OpenTelemetry 통합

```python
from opentelemetry import trace
from opentelemetry.instrumentation.logging import LoggingInstrumentor

# 자동으로 trace_id, span_id 추가
LoggingInstrumentor().instrument()

tracer = trace.get_tracer(__name__)

with tracer.start_as_current_span("process_order"):
    logger.info("Processing order")  # trace_id 자동 포함
```

---

## 피해야 할 패턴

| 패턴 | 문제 | 대안 |
|------|------|------|
| 과도한 로깅 | 노이즈, 비용 증가 | 의미 있는 이벤트만 |
| 로그 레벨 무시 | 필터링 불가 | 적절한 레벨 사용 |
| 문자열 연결 | 성능, 파싱 어려움 | 구조화된 필드 |
| PII 로깅 | 보안/규정 위반 | 마스킹 또는 제외 |
| 컨텍스트 없음 | 추적 불가 | correlation ID 사용 |

---

## 참고

- [Structured Logging Guide](https://betterstack.com/community/guides/logging/structured-logging/)
- [OpenTelemetry Semantic Conventions](https://opentelemetry.io/docs/specs/semconv/)
- [Logging Best Practices](https://www.kloudfuse.com/blog/logging-best-practices-for-developers)
