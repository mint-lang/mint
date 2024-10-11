component Test.Constant {
  const ID = Uid.generate()

  state id : String = ""

  fun componentDidMount {
    next { id: ID }
  }

  fun render : Html {
    <div>
      if id == ID {
        "SAME"
      } else {
        "CHANGED"
      }
    </div>
  }
}

suite "Component constant" {
  test "it stays constant" {
    <Test.Constant/>
    |> Test.Html.start
    |> Test.Html.assertTextOf("div", "SAME")
  }
}
