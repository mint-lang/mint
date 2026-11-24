type Test.With.Data {
  name : String
}

type Test.With.Variant {
  Variant1
  Variant2
}

type Test.With.Form {
  get : Function(String, String)
}

type Test.With.Theme {
  color : String
}

module Test.With {
  fun name : String {
    with data : Test.With.Data {
      data.name
    }
  }

  fun shadowed : String {
    with data : Test.With.Data {
      let outer =
        data.name

      provide { data: { name: "Inner" } } {
        "#{outer} #{data.name}"
      }
    }
  }

  fun admin : String {
    provide { data: { name: "Admin" } } {
      name()
    }
  }

  fun decorated : String {
    with data : Test.With.Data {
      provide { data: { name: data.name + "!" } } {
        name()
      }
    }
  }

  fun themeName : String {
    with theme : String {
      theme
    }
  }

  fun themeColor : String {
    with theme : Test.With.Theme {
      theme.color
    }
  }

  fun greet (value : String) : String {
    with data : Test.With.Data {
      data.name + value
    }
  }

  fun awaited : Promise(String) {
    let value =
      provide { data: await Promise.resolve({ name: "Awaited" }) } {
        name()
      }

    value + "!"
  }
}

component Test.With.NestedConsumer {
  fun render {
    <Test.With.Consumer/>
  }
}

component Test.With.Consumer {
  fun render {
    with data : Test.With.Data, variant : Test.With.Variant {
      <div>
        data.name

        case variant {
          Variant1 => "variant1"
          Variant2 => "variant2"
        }
      </div>
    }
  }
}

component Test.With.MemberChild {
  with data : Test.With.Data

  fun render : Html {
    <span>data.name</span>
  }
}

component Test.With.Member {
  with data : Test.With.Data

  fun render : Html {
    <div>
      data.name

      provide { data: { name: "Inner" } } {
        <Test.With.MemberChild/>
      }
    </div>
  }
}

component Test.With.Wrapper {
  property children : Array(Html) = []

  fun render : Html {
    provide { data: { name: "Slot" } } {
      <p>children</p>
    }
  }
}

component Test.With.Shadowed {
  with data : Test.With.Data

  fun render : Html {
    <div>
      <b>data.name</b>

      <i>
        provide { data: { name: "Inner" } } {
          data.name
        }
      </i>

      <Test.With.Wrapper>data.name</Test.With.Wrapper>
    </div>
  }
}

component Test.With.Provider {
  fun render : Html {
    provide { data: { name: "Joe" }, variant: Test.With.Variant.Variant2 } {
      <Test.With.NestedConsumer/>
    }
  }
}

component Test.With.Field {
  property name : String

  fun render : Html {
    with form : Test.With.Form {
      <span>form.get(name)</span>
    }
  }
}

component Test.With.Form {
  property children : Array(Html) = []

  fun get (name : String) : String {
    "value of #{name}"
  }

  fun render : Html {
    provide { form: { get: get } } {
      <div>children</div>
    }
  }
}

component Test.With.ConstantConsumer {
  with theme : Test.With.Theme

  const COLOR = theme.color
  const LABEL = COLOR + "!"
  const EXCITED = excited()

  fun excited : String {
    COLOR + "?"
  }

  fun render : Html {
    <div>
      <span>COLOR</span>
      <i>LABEL</i>
      <u>EXCITED</u>
      <b>theme.color</b>
    </div>
  }
}

component Test.With.StateConsumer {
  with theme : Test.With.Theme

  state color : String = theme.color

  fun render : Html {
    <p>color</p>
  }
}

component Test.With.ChangingProvider {
  state color : String = "red"

  fun render : Html {
    <button onClick={() { next { color: "blue" } }}>
      provide { theme: { color: color } } {
        <>
          <Test.With.ConstantConsumer/>
          <Test.With.StateConsumer/>
        </>
      }
    </button>
  }
}

component Test.With.ThemedChild {
  fun color : String {
    with theme : Test.With.Theme {
      theme.color
    }
  }

  fun render : Html {
    <i/>
  }
}

component Test.With.RefCaller {
  state text : String = ""

  fun handleClick : Promise(Void) {
    let name =
      provide { theme: "dark" } {
        Test.With.themeName()
      }

    let color =
      provide { theme: { color: "blue" } } {
        case child {
          Maybe.Just(item) => item.color()
          Maybe.Nothing => ""
        }
      }

    next { text: name + color }
  }

  fun render : Html {
    provide { theme: { color: "red" } } {
      <button onClick={handleClick}>
        text
        <Test.With.ThemedChild as child/>
      </button>
    }
  }
}

component Test.With.RefOwnCaller {
  state text : String = ""

  fun handleClick : Promise(Void) {
    next {
      text:
        Test.With.themeColor() + "/" + case child {
          Maybe.Just(item) => item.color()
          Maybe.Nothing => ""
        }
    }
  }

  fun render : Html {
    <button onClick={handleClick}>
      text

      provide { theme: { color: "red" } } {
        <Test.With.ThemedChild as child/>
      }
    </button>
  }
}

suite "With" {
  test "Test.With.Provider" {
    <Test.With.Provider/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("div", "Joevariant2")
  }

  test "Test.With.Consumer" {
    provide { data: { name: "NAME" }, variant: Test.With.Variant.Variant1 } {
      <Test.With.Consumer/>
      |> Test.Html.start()
      |> Test.Html.assertTextOf("div", "NAMEvariant1")
    }
  }

  test "Test.With.Member" {
    provide { data: { name: "Outer" } } {
      <Test.With.Member/>
      |> Test.Html.start()
      |> Test.Html.assertTextOf("div", "OuterInner")
    }
  }

  test "Reading a shadowed value gives the innermost one" {
    provide { data: { name: "Outer" } } {
      <Test.With.Shadowed/>
      |> Test.Html.start()
      |> Test.Html.assertTextOf("b", "Outer")
      |> Test.Html.assertTextOf("i", "Inner")
      |> Test.Html.assertTextOf("p", "Slot")
    }
  }

  test "Reading a shadowed value of a with block gives the innermost one" {
    provide { data: { name: "Outer" } } {
      Test.With.shadowed() == "Outer Inner"
    }
  }

  test "Injecting a mock into a module function" {
    provide { data: { name: "Mock" } } {
      Test.With.name() == "Mock"
    }
  }

  test "Providing a value inside a module function" {
    Test.With.admin() == "Admin"
  }

  test "Providing a decorated value to the called functions" {
    provide { data: { name: "Joe" } } {
      Test.With.decorated() == "Joe!"
    }
  }

  test "Passing values through functions used as values" {
    provide { data: { name: "Mapped" } } {
      let names =
        Array.map(["a", "b"], (item : String) { Test.With.name() + item })

      names == ["Mappeda", "Mappedb"]
    }
  }

  test "Giving values to the content of a component" {
    <Test.With.Form><Test.With.Field name="email"/></Test.With.Form>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("span", "value of email")
  }

  test "Awaiting in a provided value which is not the last expression" {
    let value =
      await Test.With.awaited()

    value == "Awaited!"
  }

  test "Constants of a component follow the provided value" {
    <Test.With.ChangingProvider/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("span", "red")
    |> Test.Html.assertTextOf("i", "red!")
    |> Test.Html.assertTextOf("u", "red?")
    |> Test.Html.triggerClick("button")
    |> Test.Html.assertTextOf("b", "blue")
    |> Test.Html.assertTextOf("span", "blue")
    |> Test.Html.assertTextOf("i", "blue!")
    |> Test.Html.assertTextOf("u", "blue?")
  }

  test "States of a component only take their initial value from the provided value" {
    <Test.With.ChangingProvider/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("p", "red")
    |> Test.Html.triggerClick("button")
    |> Test.Html.assertTextOf("b", "blue")
    |> Test.Html.assertTextOf("p", "red")
  }

  test "Functions of a referenced component use the value provided around the call" {
    <Test.With.RefCaller/>
    |> Test.Html.start()
    |> Test.Html.triggerClick("button")
    |> Test.Html.assertTextOf("button", "darkblue")
  }

  test "Functions of a referenced component use its own value if nothing is provided around the call" {
    provide { theme: { color: "blue" } } {
      <Test.With.RefOwnCaller/>
      |> Test.Html.start()
      |> Test.Html.triggerClick("button")
      |> Test.Html.assertTextOf("button", "blue/red")
    }
  }

  test "Values are passed to functions called in a pipe" {
    provide { data: { name: "Piped" } } {
      let greeting =
        "!"
        |> Test.With.greet()

      greeting == "Piped!"
    }
  }
}
