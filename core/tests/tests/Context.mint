type Test.Context {
  name : String
} context { name: "NAME" }

component Test.NestedConsumer {
  fun render {
    <Test.Consumer/>
  }
}

component Test.Consumer {
  context ctx : Test.Context

  fun render {
    <div>ctx.name</div>
  }
}

component Test.Provider {
  provide Test.Context { name: "Joe" }

  fun render : Html {
    <Test.NestedConsumer/>
  }
}

suite "Context" {
  test "Test.Provider" {
    <Test.Provider/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "Joe")
  }

  test "Test.Consumer" {
    <Test.Consumer/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "NAME")
  }
}
