component Test.Provider.AnimationFrame {
  state frames : Number = 0

  use Provider.AnimationFrame {
    frames =
      (timestamp : Number) : Promise(Never, Void) {
        if (timestamp > 0) {
          next { frames = frames + 1 }
        } else {
          next { }
        }
      }
  }

  fun render : Html {
    <div>
      <{ Number.toString(frames) }>
    </div>
  }
}

suite "Provider.AnimationFrame.frames" {
  test "called on an animation frame" {
    with Test.Html {
      <Test.Provider.AnimationFrame/>
      |> start()
      |> assertTextOf("div", "1")
      |> assertTextOf("div", "2")
      |> assertTextOf("div", "3")
    }
  }
}
