# Rescript + React

우앙 드디어 해본다(설렘)

## 뭐가 무엇인가(OCaml, ReasonML, BuckleScript, Rescript)

- **OCaml** : 강력한 타입시스템을 가진 함수형 프로그래밍 언어
- **Reason(ReasonML)** : OCaml을 바탕으로 여러 개발자들이 친숙하게 사용할 수 있는 형태로 디자인. BuckleScript를 이용해 JS로 컴파일 `.re`를 확장자로 사용
  - ML계열 언어 : 힌들리-밀너 타입 추론 시스템, 안전하고 간편한 타입 시스템, 함수형 프로그래밍
- **BuckleScript** : 컴파일러. OCaml을 JS로 컴파일해준다. Reason은 OCaml을 AST로 변환하므로, BuckleScript를 사용해 Reason을 JS로 컴파일해줄 수 있다
  - Reason -> OCaml -> `BuckleScript` -> JS
- **Rescript** : Reason + BuckleScript, `.res`
  - Reason을 토대로 React를 개발하기에는, 알아야 할 것들이 많고(JS, React, Reason) Reason React라는 Reason -> React 방향의 바인딩, OCaml과 BuckleScript에 대한 지식도 요구한다. 이렇게 할 것이 많아서 JS를 다루는 사람들에게는 어렵다
  - Rescript는 JS가 실행되는 환경만 포커스하는 새로운 언어의 필요성에 의해 나타남. OCaml을 탈피하면서 OCaml과의 호환을 지키기 위해 지켜야 하는 제약조건에서 자유로워지면서 더 JS 개발자에게 친숙한 환경이 되었음
  - 타입스크립트와의 차이점 : 타입스크립트는 슈퍼셋이고 자바스크립트 스펙이 확장되면서 커지지만, 리스크립트는 자바스크립트의 기능 중 특별히 선별된 기능만을 다룬다. 클래스보다는 플레인 데이터와 함수, 패턴매칭, 데이터 모델링
  - 타입은 항상 정확하다(soundness) : nullable인 값을 정확히 인식한다
  - 매우 빠르다
  - 트리쉐이킹에 적합하다 : 리스크립트 자체에서 트리쉐이킹을 시도한다
  - 타입 어노테이션이 필요가 없다.
  - 트러블 슈팅시 Rescript보다도 Reason의 문법으로 검색해서 나온 해결책도 적용이 가능

### Reason의 타입 시스템

- 타입스크립트는 자바스크립트 문법과의 하위 호환이 가능. Rescript는 수퍼셋이 아닌, 자바스크립트의 기능을 선택적으로 가져옴
- 힌들리-밀너 타입추론 시스템(나중에 좀더 알아보쟈)
- null/undefined 런타임 타입 에러 제거
- 개발자가 불필요한 타입 어노테이션을 적을 필요가 없다. 타입 힌트를 제공해야하기 때문에 코드가 왕왕 장황해지는 일이 있음

### ReasonML -> Rescript 리브랜딩의 이유

### 이런 느낌 (거의 비슷)

```js
const myFun = (x, y) => {
  const doubleX = x + x;
  const doubleY = y + y;
  return doubleX + doubleY;
};
```

```reason
let myFun = (x, y) => {
  let doubleX = x + x
  let doubleY = y + y
  doubleX + doubleY
}
```

## Rescript + React

- 가능한 한 자연스로운 JS에 가깝게 컴파일
- JSX가 언어의 일부임(ㄷ)
- React API들 호환
- 함수형 컴포넌트와 훅으로 이루어짐

### 빌드 과정, 빌드 결과물

rescript 빌드 시스템

- bsconfig.json으로 처리
- JS로 빌드 : rescript build
- rescript는 컴파일 단계만 처리한다. 하나의 파일을 하나의 자바스크립트로 만든다.
- dev server사용하기: 데브서버를 제공하는 빌드툴과 함께 사용한다. 여기서는 parcel을 써본다(config할것이 없으므로) 먼저 rescript 빌드하고, 결과물을 한번더 번들링하는 느낌
  - 코드 스플리팅 필요할땐 어떻게..?
- rescript 빌드 결과물 : lib 폴더에 같이 제공되는데, ast등등 여러 부산물들과 함께 제공되는거 같은 느낌
- stale build? 알아보기
- 의존성, 고정 의존성
  - bs-dependencies, bs-dev-dependencies: 리스크립트의 의존성 목록. package.json처럼 작동한다고 보면 되고, node_modules에서 찾는다. rescript용 모듈을 node_modules에 설치했을 때, 여기서도 표시를 해줘야한다.
  - pinned-dependencies : 고정 의존성 목록. 고정 의존성은 rescript로 최상위 패키지를 빌드할때마다 항상 다시 빌드된다.
    - 한개의 메인 프로젝트에 여러개의 독립적인 리스크립트 패키지를 연결하여 빌드하려는 상황에서 사용할 수 있다.
    - 빌드를 시작하면, 최상위 패키지에서 빌드된 고정 의존성은 최종 앱에 반영된다.
- 빌드 커맨드
  - `rescript build -w` : 워치모드 빌드
  - `rescript clean` : 프로젝트의 빌드 아티팩트 초기화
  - `rescript build -with-deps` : 의존성의 아티팩트 초기화하여 빌드

## Rescript(+Reason) 문법

### 자바스크립트와의 차이점

- 세미콜론 필요없음
- 변수 선언 키워드는 let만 존재하고, 일반 상수는 let으로, 가변 변수는 `ref()`로 선언 `let x = ref(5); x := x.contents + 1` -> 가변과 불변을 확실히 분리
- 문자열은 큰따옴표만 사용, 백틱 사용 가능, 문자열 붙일때는 `+`대신에 `++`
- `==`의 암시적 캐스팅 없음 `===`, `!==`를 쓸수 있음
- %는 `mod()`
- 타입 선언문이 있음 `type point = {x: int, mutable y: int}`
- 튜플이 있음 `(1, "Bob", true)`
- null, undefined없음 `None`만 있음
- 화살표 함수 선언문만 있음
- 함수 블록은 암시적으로 맨 마지막 값을 리턴함. 함수 바디가 각각의 로컬 스코프를 가지고 있음

```reason
let myFun = (x, y) => {
  let doubleX = x + x
  let doubleY = y + y
  doubleX + doubleY // 리턴하는 값
}
```

- if 분기문, 삼항연산자를 사용할 수 있으나, switch(패턴매칭)을 권장함

```reason
let data = GoodResult("Product shipped!")
switch data {
| GoodResult(theMessage) =>
  Js.log("Success! " ++ theMessage)
| BadResult(errorCode) =>
  Js.log("Something's wrong. The error code is: " ++ Js.Int.toString(errorCode))
| NoResult =>
  Js.log("Bah.")
}
```

- for문이 파이썬같이 생김
  - `for i in 0 to 10{}`
  - `for i in 10 downto 0 {...}`
  - `while true {...}`
- JSX가 문법에 포함되어있으며, boolean 속성 default값이 없어지고 인자와 매개변수 이름이 같은 경우 축약표현을 할 수 있음 -> 오 뭔가 좀 합리적임
  - `<Comp message={message} />` -> `<Comp message />`
  - `<input checked />` -> `<input checked=true />`
  - `<Comp>...children</Comp>` -> 자식 컴포넌트에 대한 스프레드 가능
- throw가 아니라 raise, throw블럭 없고 finally없음(왜없지)
  - `raise(SomeError(...))`
  - `try a catch { | Err => ...}`

### Let 바인딩

변수 선언. 값과 이름 값을 묶는(bind)다. if, while도 함수와 같은 블록 스코프 방식이다.

```reason
if displayGreeting {
  let message = "Enjoying the docs so far?"
  Js.log(message)
}
```

바인딩은 그냥 다 불변이다(오..) 불변성에 대한 보장은 리스크립트의 타입 시스템이 최적화와 추론을 다른 언어보다 잘할 수 있도록 도와준다.

같은 바인딩에 값을 계속 넣고싶을 경우, 이렇게도 된다. 명확성을 해치므로 권장하는 방법은 아니다.

```reason
var result = calculate(0);
var result$1 = calculateSomeMore(result); // 약간 표시자? 같은거같은데
```

private let bindings : 모듈 시스템에서는 기본적으로 모든게 public이고, 어떤 값을 숨기는 방법은 별도의 모듈 선언으로 나누어 Public필드와 그것의 타입을 표시하는 것이다. 밑의 예제에서는 모듈 A의 b에서만 접근이 가능

```reason
module A: {
  let b: int
} = {
  let a = 3
  let b = 4
}

// %%private 키워드로 직접 private 필드 설정
module A = {
  %%private(let a = 3)
  let b = 4
}
```

### 타입시스템

타입시스템의 특징들

- 리스크립트의 타입은 다른 타입으로 바뀌지 않는다. 보통의 JS에서는 코드가 진행될때 변수의 타입이 바뀌기도 한다. Number는 가끔 String으로 바뀌기도 하고, 이런거 때문에 타입스크립트에서는 `as const`를 안쓰면 넓게 추론이 안되기도 하고... 뭐 그렇다. 코드의 이해를 쉽지 않게 만든다.
- 정적 타입 추론: 타입 오류들을 컴파일 중에 알려준다
- 명확 : 절대 틀리지 않는 타입 시스템. 리스트립트는 부정확한 타입 시스템이 기대 불일치에서 발생하는 위험이라 믿으며 절대 틀리지 않음(더 빡세다는 거군)
- 유추 : 타입 유추나 불필요한 단언을 할 필요가 없다
- 어노테이션을 추가해도 개발자를 믿지 않는다
- 타입 별칭문이 있다 (type)
- 제네릭도 사용할 수 있다. 제네릭을 선언할때는 `'`로 시작한다(희한..)

```reason
type coordinates<'a> = ('a, 'a, 'a)

let a: coordinates<int> = (10, 20, 20)
let b: coordinates<float> = (10.5, 20.5, 20.5)
```

- 재귀 타입 : 스스로를 참조하는 타입을 만들 수 있다. 상호 재귀 선언문도 사용할 수 있다.

```reason
type rec student = {taughtBy: teacher}
and teacher = {students: array<student>}
```

- 타입 이스케이프 : 타입 시스템에 예외를 허용하는 함수.

```reason
external convertToFloat : int => float = "%identity"
let age = 10
let gpa = 2.1 +. convertToFloat(age)
```

- 원시타입
  - 문자열 : `"`, 백틱 사용 가능, 유니코드는 백틱으로 핸들링, `Js.string()`
  - 문자(character) : `'`, UTF-8을 지원하지 않음
    - 문자열의 문자 변환 : `"a".[0]`
    - 문자의 문자열 변환 : `String.make(1, 'a')`
  - 정규표현식 : `let r = %re("/b/g")`
  - 불리언
  - 정수 : 32비트범위(JS Number, 8바이트보다 메모리를 적게 차지한다.) `Js.int`
  - 실수 : `Js.Float`
  - 유닛 : `()`라는 단일 값을 가지며 undefined로 컴파일된다. 플레이스홀더로 사용되는 더미 타입이다.
- 튜플 : 불변, 순서가 있음, 생성 시점에 크기가 결정, 다른 타입의 값을 포함함. 크기가 1인 튜플은 없다.

```reason
let ageAndName: (int, string) = (24, "Lil' ReScript")

// 튜플 타입인 타입 어노테이션을 다른 이름의 타입으로 사용
type coord3d = (float, float, float)
let my3dCoordinates: coord3d = (20.0, 30.5, 100.0)
```

### 레코드

자바스크립트 객체와 유사하지만, **불변**이며, 고정된 필드를 가지고 있어 확장이 불가능하다. 반드시 타입선언이 필요하다. 일반적인 객체 문법처럼 선언하면 레코드가 된다. 새 레코드 값을 생성할 때는 리스크립트는 값의 형태가 맞는 레코드 타입선언을 찾으려고 하므로 이어줄 필요가 없다.

```reason
// 타입 선언이 다른 파일이나 모듈에 있는 경우 어떤 파일이나 모듈인지 명시적으로 기재해야합니다.
/* School.res */
type person = {age: int, name: string}

/* Example.res */
let me: School.person = {age: 20, name: "Big ReScript"}
/* or */
let me2 = {School.age: 20, name: "Big ReScript"}
```

레코드의 불변 수정 : 스프레드 연산자를 사용해 이전 레코드에서 새로운 레코드를 만들 수 있고 원본 레코드는 변경되지 않는다.

가변 수정 : 레코드를 선언할 때 mutable 키워드를 앞에 달아두면, 해당 필드는 업데이트 가능해진다. 자바스크립트 객체로 컴파일된다.

```reason
type person = {
  name: string,
  mutable age: int
}

let baby = {name: "Baby ReScript", age: 5}
baby.age = baby.age + 1 /* `baby.age` is now 6. Happy birthday! */
```

덕타이핑처럼 접근할 수 없다. 그리고 필드와 가장 가까운 레코드 타입과 짝을 짓는다. 이러한 접근이 필요할때는 레코드가 아니라 객체를 사용해야 한다.

```reason
type person = {age: int, name: string}
type monster = {age: int, hasTentacles: bool}

let getAge = (entity) => entity.age // 에러, Monster타입으로 추론되어야 함
```

**레코드를 객체보다 먼저 고려하는 것이 권장된다.** 레코드는 명시적으로 타입도 필요하고, 모든 필드가 정확히 일치해야 함수에 전달할 수 있는 등 다루기가 더 불편한 지점이 있다.

이렇게 하는 이유는, 대부분의 앱에서 플레인 객체의 데이터의 형태는 고정되어 잇으며 그렇지 않은 경우 잠재적으로는 배리언트 + 레코드의 조합으로 더 잘 표현될 수 있다.

레코드 타입은 단일 명시적 정의(명목적 타이핑)를 통해 해소된다. 레코드 타입의 타입 오류 메시지가 튜플 같은 구조적 타이핑의 오류 메시지보다 더 낫다. 구조적 타이핑에서는 어떤 필드를 바꿨을 때, 선언이 잘못된건지 사용처가 잘못된건지 컴파일러가 추론할 방법이 없다.

### 객체

레코드와 비슷하나, 타입 선언이 필요 없고, 구조적/폴리몰픽, 패턴매칭을 지원하지 않으며, 객체가 JS로부터 전달된 것이 아닐 경우 변경할 수 없다.

```reason
let me = {
  "age": 5,
  "name": "Big ReScript"
}
```

객체의 타입은 값으로부터 추론된다. 타입선언을 굳이 적을 필요가 없다. 필드 타입을 큰따옴표로 감싼 객체를 선언하면 그게 객체다(레코드와의 다른점), 이렇게 선언하면 리스크립트는 타입 선언을 찾아서 비교하려 하지 않고, 객체 타입으로 추론된다.(`{"age": int, "name": string}`) 타입 어노테이션을 적용하고 싶다면, 명시적으로 적용해줘야 한다.

```reason
type person = {
  "age": string
}

let me: person = {
  "age": "hello!"
}
```

타입선언을 해놓고 그에 맞는 객체를 생성하는것 -> 레코드

### Variant

**또는**을 표현할 수 있는 자료구조. 타입스크립트의 유니언 타입과 유사

```reason
type myResponse =
  | Yes
  | No
  | PrettyMuch // 배리언트 생성자는 대문자로 시작

let areYouCrushingIt = Yes
```

배리언트 생성자가 여러 값을 가질때 가독성을 높이기 위해 필드 이름을 지정할 수 있다.

```reason
type user =
  | Number(int)
  | Id({name: string, password: string})

let me = Id({name: "Joe", password: "123"})

// 이런식으로
var me = {
  TAG: /* Id */ 1,
  name: 'Joe',
  password: '123',
};
```

배리언트 값은 페이로드가 없는 생성자일 경우 숫자로 컴파일되며(Enum??) 페이로드가 있으면 TAG필드와 함께 첫번째 페이로드는 `_0`, 두번째는 `_1`과 같이 순서가 적용된 객체로 컴파일됨. 예외로 타입 선언에 페이로드가 있는 생성자가 하나만 있는 경우, 생성자는 TAG필드 없는 객체로 컴파일한다. 클래스 생성자 같은건 아니다

```reason
// 0
type greeting = Hello | Goodbye
let g1 = Hello
let g2 = Goodbye

var g1 = /* Hello */ 0;
var g2 = /* Goodbye */ 1;

// 1
type outcome = Good | Error(string)
let o1 = Good
let o2 = Error("oops!")

var o1 = /* Good */ 0;
var o2 = /* Error */ {
  _0: 'oops!',
};

// 2
type family = Child | Mom(int, string) | Dad (int)
let f1 = Child
let f2 = Mom(30, "Jane")
let f3 = Dad(32)

var f1 = /* Child */ 0;
var f2 = {
  TAG: /* Mom */ 0,
  _0: 30,
  _1: 'Jane',
};
var f3 = {
  TAG: /* Dad */ 1,
  _0: 32,
};
```

리스크립트에는 유니언 타입이 없다. 각각 생성자를 제공해야 한다. `type myType = Int(int) | String(string)`

배리언트는 어디에 써먹을 수 있을까?

option 배리언트는 다른 언어의 주요 버그 원인인 nullable타입의 필요성을 제거한다.

또는 분기문의 잘못된 처리 결과물이 프로그램에 전파되는 것을 안전하게 제거한다. 속도도 높일 수 있음. 패턴매칭에서도 살펴볼것

```js
// 선형적 분기 검사 O(n)
let data = 'dog'
if (data === 'dog') {
  ...
} else if (data === 'cat') {
  ...
} else if (data === 'bird') {
  ...
}
```

```reason
// 이렇게 패턴매칭으로 처리할 경우
// 컴파일러는 배리언트를 확인한 다음, 0|1|2로 변환하고
// switch를 상수 시간에 조회할 수 있게 변환한다.

type animal = Dog | Cat | Bird
let data = Dog

switch data {
| Dog => Js.log("Wof")
| Cat => Js.log("Meow")
| Bird => Js.log("Kashiiin")
}
```

## Rescript + React 문법

## References

- https://seob.dev/posts/ReScript-%EC%82%AC%EC%9A%A9%EA%B8%B0/
- https://green-labs.github.io/what-is-reason-ml
