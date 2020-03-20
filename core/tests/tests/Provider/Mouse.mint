component Test.Provider.Mouse {
  state clicks : Number = 0
  state moves : Number = 0
  state ups : Number = 0

  use Provider.Mouse {
    clicks = (event : Html.Event) : Promise(Never, Void) { next { clicks = clicks + 1 } },
    moves = (event : Html.Event) : Promise(Never, Void) { next { moves = moves + 1 } },
    ups = (event : Html.Event) : Promise(Never, Void) { next { ups = ups + 1 } }
  }

  fun render : Html {
    <div>
      <clicks>
        <{ Number.toString(clicks) }>
      </clicks>

      <moves>
        <{ Number.toString(moves) }>
      </moves>

      <ups>
        <{ Number.toString(ups) }>
      </ups>
    </div>
  }
}

suite "Provider.Mouse.clicks" {
  test "calls clicks on click" {
    with Test.Html {
      <Test.Provider.Mouse/>
      |> start()
      |> assertTextOf("clicks", "0")
      |> triggerClick("clicks")
      |> assertTextOf("clicks", "1")
    }
  }
}

suite "Provider.Mouse.moves" {
  test "calls moves on mouse move" {
    with Test.Html {
      <Test.Provider.Mouse/>
      |> start()
      |> assertTextOf("moves", "0")
      |> triggerMouseMove("moves")
      |> assertTextOf("moves", "1")
    }
  }
}

suite "Provider.Mouse.ups" {
  test "calls ups on mouse up" {
    with Test.Html {
      <Test.Provider.Mouse/>
      |> start()
      |> assertTextOf("ups", "0")
      |> triggerMouseUp("ups")
      |> assertTextOf("ups", "1")
    }
  }
}
