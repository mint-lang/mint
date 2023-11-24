component Test.Provider.Mouse {
  state clicks : Number = 0
  state moves : Number = 0
  state ups : Number = 0

  use Provider.Mouse {
    clicks: (event : Html.Event) : Promise(Void) { next { clicks: clicks + 1 } },
    moves: (event : Html.Event) : Promise(Void) { next { moves: moves + 1 } },
    ups: (event : Html.Event) : Promise(Void) { next { ups: ups + 1 } }
  }

  fun render : Html {
    <div>
      <clicks>
        Number.toString(clicks)
      </clicks>

      <moves>
        Number.toString(moves)
      </moves>

      <ups>
        Number.toString(ups)
      </ups>
    </div>
  }
}

suite "Provider.Mouse.clicks" {
  test "calls clicks on click" {
    <Test.Provider.Mouse/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("clicks", "0")
    |> Test.Html.triggerClick("clicks")
    |> Test.Html.assertTextOf("clicks", "1")
  }
}

suite "Provider.Mouse.moves" {
  test "calls moves on mouse move" {
    <Test.Provider.Mouse/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("moves", "0")
    |> Test.Html.triggerMouseMove("moves")
    |> Test.Html.assertTextOf("moves", "1")
  }
}

suite "Provider.Mouse.ups" {
  test "calls ups on mouse up" {
    <Test.Provider.Mouse/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("ups", "0")
    |> Test.Html.triggerMouseUp("ups")
    |> Test.Html.assertTextOf("ups", "1")
  }
}
