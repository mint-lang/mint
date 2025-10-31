type Test.Context {
  name : String
} context { name: "NAME" }

type Test.ContextADT {
  Variant1
  Variant2
} context Test.ContextADT.Variant1

component Test.NestedConsumer {
  fun render {
    <Test.Consumer/>
  }
}

component Test.Consumer {
  context ctx : Test.Context
  context adt : Test.ContextADT

  fun render {
    <div>
      ctx.name

      case adt {
        Variant1 => "variant1"
        Variant2 => "variant2"
      }
    </div>
  }
}

component Test.Provider {
  provide Test.Context { name: "Joe" }
  provide Test.ContextADT Test.ContextADT.Variant2

  fun render : Html {
    <Test.NestedConsumer/>
  }
}

suite "Context" {
  test "Test.Provider" {
    <Test.Provider/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "Joevariant2")
  }

  test "Test.Consumer" {
    <Test.Consumer/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "NAMEvariant1")
  }
}
