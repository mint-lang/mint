component Test.Provider.Scroll {
  use Provider.Scroll { scrolls: (event : Html.Event) : Promise(Void) { next { position: Window.scrollTop() } } }

  state position : Number = 0

  style base {
    height: 3000px;
    width: 3000px;
  }

  fun render : Html {
    <div::base>
      Number.toString(position)
    </div>
  }
}

suite "Provider.Scroll.scrolls" {
  test "it notifies subscribers about scroll events" {
    <Test.Provider.Scroll/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "0")
    |> Test.Window.setScrollTop(100)
    |> Test.Html.assertTextOf("div", "100")
  }
}
