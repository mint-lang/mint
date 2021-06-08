component Test.Provider.AnimationFrame {
  state timestamp : Number = 0

  use Provider.AnimationFrame {
    frames =
      (timestamp : Number) : Promise(Never, Void) {
        next { timestamp = timestamp }
      }
  }

  fun render : Html {
    <div>
      <{ Number.toString(timestamp) }>
    </div>
  }
}

suite "Provider.AnimationFrame.frames" {
  test "called on an animation frame" {
    with Test.Context {
      with Test.Html {
        <Test.Provider.AnimationFrame/>
          |> start()
          |> find("div")
          |> map(Dom.getTextContent)
          |> assertNotEqual("0")
      }
    }
  }
}
