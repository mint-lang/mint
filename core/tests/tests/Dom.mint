suite "Dom.createElement" {
  test "returns a Dom element" {
    element =
      Dom.createElement("div")

    `#{element}.tagName === "DIV"`
  }
}

suite "Dom.getValue" {
  test "returns the value of the element" {
    Dom.createElement("input").setValue("test").getValue() == "test"
  }

  test "returns an empty string if there is no value" {
    Dom.createElement("div").getValue() == ""
  }
}

suite "Dom.getElementById" {
  test "returns just the element if found" {
    Dom.getElementById("root").isJust()
  }

  test "returns nothing if the element is not found" {
    Dom.getElementById("???").isNothing()
  }
}

suite "Dom.getElementBySelector" {
  test "returns just the element if found" {
    Dom.getElementBySelector("div#root").isJust()
  }

  test "returns nothing the selector is invalid" {
    Dom.getElementBySelector("???").isNothing()
  }

  test "returns nothing if element is not found" {
    Dom.getElementBySelector("blah").isNothing()
  }
}

suite "Dom.getDimensions" {
  test "returns dimensions" {
    Dom.Dimensions.empty() == Dom.createElement("div").getDimensions()
  }

  test "returns actual dimensions" {
    Dom.getElementById("root")
      .withLazyDefault(() { Dom.createElement("div") })
      .getDimensions()
      .width != 0
  }
}

suite "Dom.matches" {
  test "returns true if the selector matches" {
    Dom.createElement("div").matches("div")
  }

  test "returns false for invalid selector" {
    Dom.createElement("div").matches("??") == false
  }

  test "returns false if the selector does not match" {
    Dom.createElement("div").matches("p") == false
  }
}

suite "Dom.contains" {
  test "it returns true if it contains the element" {
    Dom.contains(`document.body`, `document`)
  }

  test "it returns false if it does not contain the element" {
    Dom.contains(`document`, `document.body`) == false
  }
}

component Test.Dom.Focus {
  state shown : Bool = false

  style input {
    display: #{display};
  }

  get display : String {
    if (shown) {
      "inline-block"
    } else {
      "none"
    }
  }

  fun show : Promise(Void) {
    await Timer.timeout(100, "")
    await next { shown = true }
  }

  fun focus : Promise(Void) {
    input.focus()
  }

  fun render : Html {
    <>
      <input::input as input id="input"/>

      <button
        id="show"
        onClick={show}/>

      <button
        id="focus"
        onClick={focus}/>
    </>
  }
}

suite "Dom.focusWhenVisible" {
  test "it waits for the element to be visible" {
    <Test.Dom.Focus/>
      .start()
      .triggerClick("#focus")
      .triggerClick("#show")
    |> Test.Context.timeout(200)
    |> Test.Html.assertCssOf("#input", "display", "inline-block")
    |> Test.Html.assertActiveElement("#input")
  }
}
