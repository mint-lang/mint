component Test.Provider.Keyboard {
  state downs : Number = 0
  state ups : Number = 0

  use Provider.Keyboard {
    downs: (event : Html.Event) : Promise(Void) { next { downs: downs + 1 } },
    ups: (event : Html.Event) : Promise(Void) { next { ups: ups + 1 } }
  }

  fun render : Html {
    <div>
      <downs>
        Number.toString(downs)
      </downs>

      <ups>
        Number.toString(ups)
      </ups>
    </div>
  }
}

suite "Provider.Keyboard.downs" {
  test "calls downs on keydown" {
    <Test.Provider.Keyboard/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("downs", "0")
    |> Test.Html.triggerKeyDown("div", "A")
    |> Test.Html.assertTextOf("downs", "1")
  }
}

suite "Provider.Keyboard.ups" {
  test "calls ups on keyup" {
    <Test.Provider.Keyboard/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("ups", "0")
    |> Test.Html.triggerKeyUp("div", "A")
    |> Test.Html.assertTextOf("ups", "1")
  }
}
