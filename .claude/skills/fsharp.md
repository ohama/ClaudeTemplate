# F# Expert

F# 코드 작성 및 리뷰 시 적용되는 전문가 지침입니다.

## 활성화 조건

- 파일 확장자: `*.fs`, `*.fsx`, `*.fsi`, `*.fsproj`
- 사용자가 F# 관련 질문을 할 때

## 핵심 원칙

### 함수형 프로그래밍 우선
- 불변성(Immutability) 기본 사용
- 순수 함수 선호
- 부수 효과는 명시적으로 분리
- 파이프라인 연산자 (`|>`) 적극 활용

### Railway Oriented Programming (ROP)
- **모든 에러 처리는 ROP 패턴으로 구현**
- Result 타입을 통한 성공/실패 경로 분리
- 예외(Exception) 대신 Result 체이닝 사용
- bind (`>>=`), map (`<!>`), apply (`<*>`) 연산자 활용
- 실패는 빠르게, 성공은 끝까지 흐르도록 설계

### 타입 시스템 활용
- Discriminated Union으로 도메인 모델링
- Record 타입으로 데이터 구조화
- Option 타입으로 null 제거
- Result 타입으로 에러 처리 (ROP)

### 코드 스타일

```fsharp
// 좋은 예: 파이프라인과 불변성
let processUsers users =
    users
    |> List.filter (fun u -> u.IsActive)
    |> List.map (fun u -> { u with LastSeen = DateTime.Now })
    |> List.sortBy (fun u -> u.Name)

// 좋은 예: Discriminated Union
type PaymentMethod =
    | CreditCard of number: string * expiry: DateTime
    | BankTransfer of accountNumber: string
    | Cash

// 좋은 예: Result를 이용한 에러 처리
let validateEmail email =
    if String.IsNullOrEmpty(email) then
        Error "Email cannot be empty"
    elif not (email.Contains("@")) then
        Error "Invalid email format"
    else
        Ok email
```

## 피해야 할 패턴

- `mutable` 키워드 남용
- `null` 직접 사용 (Option 사용)
- 예외 기반 흐름 제어 (Result 사용)
- 과도한 클래스/OOP 패턴
- 명시적 타입 선언 과다 (타입 추론 활용)

## 프로젝트 구조

```
src/
├── Domain/           # 도메인 모델 (순수 타입)
├── Application/      # 비즈니스 로직
├── Infrastructure/   # 외부 의존성 (DB, API)
└── Program.fs        # 진입점
tests/
├── Unit/
└── Integration/
```

## 빌드 및 도구

```bash
# 프로젝트 생성
dotnet new console -lang F# -o MyApp

# 빌드
dotnet build

# 실행
dotnet run

# 테스트
dotnet test

# 패키지 추가
dotnet add package <PackageName>
```

## 권장 라이브러리

| 용도 | 라이브러리 |
|------|-----------|
| JSON | Thoth.Json, FSharp.SystemTextJson |
| HTTP | FSharp.Data, Giraffe |
| **테스트** | **Expecto + FsCheck** (필수) |
| **로깅** | **Serilog** (필수) |
| 파싱 | FParsec |
| 비동기 | FSharp.Control.AsyncSeq |
| DI | Microsoft.Extensions.DependencyInjection |

## 로깅 (Serilog)

**Serilog**를 사용하여 구조화된 로깅을 구현합니다.

### 설치

```bash
dotnet add package Serilog
dotnet add package Serilog.Sinks.Console
dotnet add package Serilog.Sinks.File
dotnet add package Destructurama.FSharp
```

### 기본 설정

```fsharp
open Serilog
open Destructurama

// 로거 초기화
let configureLogger () =
    Log.Logger <-
        LoggerConfiguration()
            .MinimumLevel.Debug()
            .Destructure.FSharpTypes()  // F# 타입 지원
            .WriteTo.Console(
                outputTemplate = "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj}{NewLine}{Exception}"
            )
            .WriteTo.File(
                "logs/app-.log",
                rollingInterval = RollingInterval.Day,
                retainedFileCountLimit = 7
            )
            .CreateLogger()

// 종료 시
let closeLogger () =
    Log.CloseAndFlush()
```

### 사용 예제

```fsharp
open Serilog

// 기본 로깅
Log.Information("Application started")
Log.Debug("Processing request {RequestId}", requestId)
Log.Warning("Cache miss for key {Key}", key)
Log.Error("Failed to connect to database")

// 구조화된 로깅 (F# Record)
type User = { Id: int; Name: string; Email: string }

let user = { Id = 1; Name = "John"; Email = "john@example.com" }
Log.Information("User logged in {@User}", user)
// 출력: User logged in { Id: 1, Name: "John", Email: "john@example.com" }

// 예외 로깅
try
    failwith "Something went wrong"
with ex ->
    Log.Error(ex, "Operation failed for {UserId}", userId)
```

### ROP와 Serilog 결합

```fsharp
module Result =
    // 성공/실패 시 로깅
    let logResult context result =
        match result with
        | Ok value ->
            Log.Debug("{Context} succeeded with {@Value}", context, value)
            result
        | Error err ->
            Log.Warning("{Context} failed with {Error}", context, err)
            result

    // 파이프라인에서 사용
    let (|>!) result context =
        logResult context result

// 사용 예
let processOrder order =
    validateOrder order       |>! "Validation"
    >>= calculateTotal        |>! "Calculation"
    >>= applyDiscount         |>! "Discount"
    >>= createInvoice         |>! "Invoice"
```

### 컨텍스트 추가 (LogContext)

```fsharp
open Serilog.Context

let processRequest requestId userId =
    use _ = LogContext.PushProperty("RequestId", requestId)
    use _ = LogContext.PushProperty("UserId", userId)

    Log.Information("Processing started")
    // 모든 로그에 RequestId, UserId 자동 포함
    doSomething()
    Log.Information("Processing completed")
```

### 환경별 설정

```fsharp
let configureLoggerForEnv env =
    let config =
        LoggerConfiguration()
            .Destructure.FSharpTypes()
            .Enrich.FromLogContext()

    let config =
        match env with
        | "Development" ->
            config
                .MinimumLevel.Debug()
                .WriteTo.Console()
        | "Production" ->
            config
                .MinimumLevel.Information()
                .WriteTo.Console()
                .WriteTo.File("logs/app-.log", rollingInterval = RollingInterval.Day)
        | _ -> config

    Log.Logger <- config.CreateLogger()
```

## 테스트 작성 (Expecto + FsCheck)

**Expecto**와 **FsCheck**를 조합하여 테스트를 작성합니다.

### 설치

```bash
dotnet add package Expecto
dotnet add package Expecto.FsCheck
dotnet add package FsCheck
```

### Expecto 기본 테스트

```fsharp
open Expecto

let tests =
    testList "User tests" [
        test "should create valid user" {
            let user = createUser "John" "john@example.com"
            Expect.equal user.Name "John" "Name should match"
        }

        testAsync "should fetch user from API" {
            let! user = fetchUserAsync 1
            Expect.isSome user "User should exist"
        }

        testCase "should validate email format" <| fun _ ->
            let result = validateEmail "test@example.com"
            Expect.isOk result "Valid email should pass"
    ]

// 진입점
[<EntryPoint>]
let main args =
    runTestsWithCLIArgs [] args tests
```

### FsCheck Property-Based Testing

```fsharp
open Expecto
open FsCheck

// 속성 정의: 모든 입력에 대해 항상 참이어야 함
let properties =
    testList "Property tests" [
        testProperty "reverse twice equals original" <| fun (xs: int list) ->
            List.rev (List.rev xs) = xs

        testProperty "sort is idempotent" <| fun (xs: int list) ->
            List.sort xs = List.sort (List.sort xs)

        testProperty "length preserved after map" <| fun (xs: int list) ->
            List.length xs = List.length (List.map ((*) 2) xs)
    ]
```

### Custom Generator (FsCheck)

```fsharp
open FsCheck

// 도메인 타입에 대한 커스텀 생성기
type ValidEmail = ValidEmail of string

type Generators =
    static member ValidEmail() =
        gen {
            let! name = Arb.generate<string> |> Gen.filter (not << String.IsNullOrWhiteSpace)
            let! domain = Gen.elements ["gmail.com"; "example.com"; "test.org"]
            return ValidEmail $"{name}@{domain}"
        }
        |> Arb.fromGen

// 등록
let config = { FsCheckConfig.defaultConfig with arbitrary = [typeof<Generators>] }

let customTests =
    testList "Custom generator tests" [
        testPropertyWithConfig config "valid email always contains @" <| fun (ValidEmail email) ->
            email.Contains("@")
    ]
```

### ROP와 FsCheck 결합

```fsharp
let ropPropertyTests =
    testList "ROP property tests" [
        testProperty "validateName: non-empty string always Ok" <| fun (NonEmptyString name) ->
            match validateName name with
            | Ok _ -> true
            | Error _ -> false

        testProperty "bind preserves Error" <| fun (x: int) ->
            let error = Error "fail"
            (error >>= fun _ -> Ok x) = Error "fail"

        testProperty "map preserves structure" <| fun (x: int) (f: int -> int) ->
            let ok = Ok x
            Result.map f ok = Ok (f x)
    ]
```

### 테스트 구조

```
tests/
├── Tests.fsproj
├── Program.fs           # 진입점
├── Unit/
│   ├── DomainTests.fs   # 도메인 로직 테스트
│   └── ValidationTests.fs
├── Property/
│   ├── Generators.fs    # FsCheck 커스텀 생성기
│   └── PropertyTests.fs # Property-based 테스트
└── Integration/
    └── ApiTests.fs
```

### 실행

```bash
# 모든 테스트 실행
dotnet run

# 필터링
dotnet run -- --filter "User"

# 병렬 실행
dotnet run -- --parallel

# 상세 출력
dotnet run -- --debug
```

## Railway Oriented Programming (ROP)

ROP는 함수를 "두 갈래 철도"처럼 연결하여 에러를 우아하게 처리하는 패턴입니다.

### 기본 개념

```
Success Track:  ----[f1]----[f2]----[f3]----> Ok result
                     |       |       |
Failure Track:  -----+-------+-------+------> Error result
```

### Result 타입 정의

```fsharp
// 도메인 에러 정의
type ValidationError =
    | EmptyName
    | InvalidEmail of string
    | AgeTooYoung of int
    | AgeTooOld of int

type DomainError =
    | ValidationError of ValidationError
    | DatabaseError of string
    | NetworkError of exn
```

### ROP 핵심 함수들

```fsharp
module Result =
    // bind: Result를 받아서 Result를 반환하는 함수 연결
    let bind f result =
        match result with
        | Ok x -> f x
        | Error e -> Error e

    // map: 성공 값에 함수 적용
    let map f result =
        match result with
        | Ok x -> Ok (f x)
        | Error e -> Error e

    // mapError: 에러 값에 함수 적용
    let mapError f result =
        match result with
        | Ok x -> Ok x
        | Error e -> Error (f e)

    // 연산자 정의
    let (>>=) result f = bind f result  // bind
    let (<!>) f result = map f result   // map
    let (>=>) f g x = f x >>= g         // Kleisli composition
```

### ROP 사용 예제

```fsharp
// 개별 검증 함수 (switch function)
let validateName name =
    if String.IsNullOrWhiteSpace(name) then
        Error EmptyName
    else
        Ok name

let validateEmail email =
    if not (email.Contains("@")) then
        Error (InvalidEmail email)
    else
        Ok email

let validateAge age =
    if age < 18 then Error (AgeTooYoung age)
    elif age > 120 then Error (AgeTooOld age)
    else Ok age

// ROP로 검증 체이닝
let validatePerson name email age =
    validateName name
    >>= fun validName ->
        validateEmail email
        >>= fun validEmail ->
            validateAge age
            >>= fun validAge ->
                Ok { Name = validName; Email = validEmail; Age = validAge }

// 또는 Computation Expression 사용
let validatePersonCE name email age =
    result {
        let! validName = validateName name
        let! validEmail = validateEmail email
        let! validAge = validateAge age
        return { Name = validName; Email = validEmail; Age = validAge }
    }
```

### Kleisli Composition (>=>)

```fsharp
// 함수들을 파이프라인처럼 연결
let processOrder =
    validateOrder
    >=> checkInventory
    >=> calculateTotal
    >=> applyDiscount
    >=> createInvoice

// 사용
let result = processOrder orderRequest
```

### 여러 에러 수집 (Applicative)

```fsharp
// 모든 에러를 수집하는 버전
module Validation =
    type Validation<'a, 'e> = Result<'a, 'e list>

    let apply fResult xResult =
        match fResult, xResult with
        | Ok f, Ok x -> Ok (f x)
        | Error e, Ok _ -> Error e
        | Ok _, Error e -> Error e
        | Error e1, Error e2 -> Error (e1 @ e2)

    let (<*>) = apply

// 사용: 모든 검증 에러 수집
let validatePersonAll name email age =
    let createPerson n e a = { Name = n; Email = e; Age = a }
    Ok createPerson
    <*> validateName name
    <*> validateEmail email
    <*> validateAge age
// 결과: Error [EmptyName; InvalidEmail "bad"; AgeTooYoung 15]
```

### 비동기 + ROP (AsyncResult)

```fsharp
type AsyncResult<'T, 'E> = Async<Result<'T, 'E>>

module AsyncResult =
    let bind f asyncResult = async {
        let! result = asyncResult
        match result with
        | Ok x -> return! f x
        | Error e -> return Error e
    }

    let map f = bind (f >> Ok >> async.Return)

    let (>>=) result f = bind f result

// 사용 예
let fetchAndValidateUser userId : AsyncResult<User, DomainError> =
    fetchUserAsync userId
    >>= fun user ->
        validateUser user |> Async.singleton
    >>= fun validUser ->
        saveUserAsync validUser
```

## Computation Expressions

```fsharp
// Result computation expression
let validateUser name email =
    result {
        let! validName = validateName name
        let! validEmail = validateEmail email
        return { Name = validName; Email = validEmail }
    }

// AsyncResult computation expression
let processOrderAsync orderId =
    asyncResult {
        let! order = fetchOrderAsync orderId
        let! validated = validateOrder order
        let! processed = processPaymentAsync validated
        do! sendConfirmationAsync processed
        return processed
    }

// Async workflow
let fetchAndProcess id =
    async {
        let! data = fetchDataAsync id
        let processed = processData data
        do! saveDataAsync processed
        return processed
    }
```
