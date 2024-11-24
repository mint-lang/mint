suite "Test (Async)" {
  test "await Bool" {
    await true
  }

  test "await Test.Context(Bool)" {
    await Test.Context.of(true)
  }
}

suite "Test (Function)" {
  fun test : String {
    ""
  }

  test "function" {
    test() == ""
  }
}

suite "Test with HTML reference" {
  test "it works" {
    <button as button/>
    |> Test.Html.start
    |> Test.Context.map((item : Dom.Element) { button != Maybe.Nothing })
  }
}

component TestReference {
  fun render {
    <div>"TestReference"</div>
  }
}

suite "Test with Component reference" {
  test "it works" {
    <TestReference as button/>
    |> Test.Html.start
    |> Test.Context.map((item : Dom.Element) { button != Maybe.Nothing })
  }
}
