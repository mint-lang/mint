component Test.Provider.Tick {
  state counter : Number = 0

  use Provider.Tick { ticks: () : Promise(Void) { next { counter: counter + 1 } } }

  fun render : Html {
    <div>
      Number.toString(counter)
    </div>
  }
}

suite "Provider.Tick.ticks" {
  test "called every second" {
    <Test.Provider.Tick/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "0")
    |> Test.Context.timeout(1010)
    |> Test.Html.assertTextOf("div", "1")
  }
}
