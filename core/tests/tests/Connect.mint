store Test.Store {
  state test : String = "TEST"
  state test2 : String = "TEST2"
}

component Store.Test {
  connect Test.Store exposing { test, test2 as x }

  fun render : Html {
    <>
      <span>
        test
      </span>

      <strong>
        x
      </strong>
    </>
  }
}

suite "Store" {
  test "connections" {
    <Store.Test/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("span", "TEST")
    |> Test.Html.assertTextOf("strong", "TEST2")
  }
}
