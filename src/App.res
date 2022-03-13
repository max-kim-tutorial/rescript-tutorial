module App = {  
  @react.component
  let make = () => {
    <div className="App">
      <h1>("Hello Codesandbox from ReScript" -> React.string)</h1>
      <h2>
        <u>
        ("This template is just a base idea on how to run ReScript on Codesandbox" -> React.string)
        </u>
      </h2>
      <h2>
          ("You'll need to open a secondary terminal tab and run: " -> React.string) 
          <br />
          <code><i>("- yarn re:start" -> React.string)</i></code>
      </h2>
      <h2>
        ("Also will need to update the web view manually after every change: " -> React.string)
        <br />
        <code><i>("- ctrl | cmd + shift + r" -> React.string)</i></code>
      </h2>
      <h2>
        ("Go to the Server control Panel tab and restart the server if your changes don't show up" -> React.string)
      </h2>
    </div>
  }
}
