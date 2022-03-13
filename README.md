# Rescript + React

우앙 드디어 해본다(설렘)

## TODO

- [ ] 환경 빌드(React + Rescript)
- [ ] 문법 공부해보기, Re에서 사용할 수 있는 라이브러리 파악해보기
- [ ] TODO List 만들어보기

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

## Rescript + React 문법

## Rescript(+Reason) 문법

## References

- https://seob.dev/posts/ReScript-%EC%82%AC%EC%9A%A9%EA%B8%B0/
- https://green-labs.github.io/what-is-reason-ml
