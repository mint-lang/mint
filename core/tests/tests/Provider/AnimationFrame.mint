component Test.Provider.AnimationFrame {
  state frames : Number = 0

  use Provider.AnimationFrame {
    frames:
      (timestamp : Number) : Promise(Void) {
        if (timestamp > 0) {
          next { frames: frames + 1 }
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
    <Test.Provider.AnimationFrame/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "1")
    |> Test.Html.assertTextOf("div", "2")
    |> Test.Html.assertTextOf("div", "3")
  }
}
