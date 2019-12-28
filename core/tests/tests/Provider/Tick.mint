component Test.Provider.Tick {
  state counter : Number = 0

  use Provider.Tick { ticks = () : Promise(Never, Void) { next { counter = counter + 1 } } }

  fun render : Html {
    <div>
      <{ Number.toString(counter) }>
    </div>
  }
}

suite "Provider.Tick.ticks" {
  test "called every second" {
    with Test.Html {
      with Test.Context {
        <Test.Provider.Tick/>
        |> start()
        |> assertTextOf("div", "0")
        |> timeout(1010)
        |> assertTextOf("div", "1")
      }
    }
  }
}
