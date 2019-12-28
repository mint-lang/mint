component Test.Provider.Scroll {
  use Provider.Scroll { scrolls = (event : Html.Event) : Promise(Never, Void) { next { position = Window.scrollTop() } } }

  state position : Number = 0

  style base {
    height: 3000px;
    width: 3000px;
  }

  fun render : Html {
    <div::base>
      <{ Number.toString(position) }>
    </div>
  }
}

suite "Provider.Scroll.scrolls" {
  test "it notifies subscribers about scroll events" {
    with Test.Html {
      with Test.Window {
        <Test.Provider.Scroll/>
        |> start()
        |> assertTextOf("div", "0")
        |> setScrollTop(100)
        |> assertTextOf("div", "100")
      }
    }
  }
}
