suite "Dom.createElement" {
  test "returns a Dom element" {
    try {
      element =
        Dom.createElement("div")

      `#{element}.tagName === "DIV"`
    }
  }
}

suite "Dom.getValue" {
  test "returns the value of the element" {
    (Dom.createElement("input")
    |> Dom.setValue("test")
    |> Dom.getValue()) == "test"
  }

  test "returns an empty string if there is no value" {
    (Dom.createElement("div")
    |> Dom.getValue()) == ""
  }
}

suite "Dom.getElementById" {
  test "returns just the element if found" {
    Dom.getElementById("root")
    |> Maybe.isJust()
  }

  test "returns nothing if the element is not found" {
    Dom.getElementById("???")
    |> Maybe.isNothing()
  }
}

suite "Dom.getElementBySelector" {
  test "returns just the element if found" {
    Dom.getElementBySelector("div#root")
    |> Maybe.isJust()
  }

  test "returns nothing the selector is invalid" {
    Dom.getElementBySelector("???")
    |> Maybe.isNothing()
  }

  test "returns nothing if element is not found" {
    Dom.getElementBySelector("blah")
    |> Maybe.isNothing()
  }
}

suite "Dom.getDimensions" {
  test "returns dimensions" {
    try {
      dimensions =
        Dom.createElement("div")
        |> Dom.getDimensions()

      Dom.Dimensions.empty() == dimensions
    }
  }

  test "returns actual dimensions" {
    try {
      dimensions =
        Dom.getElementById("root")
        |> Maybe.withDefault(Dom.createElement("div"))
        |> Dom.getDimensions()

      dimensions.width != 0
    }
  }
}

suite "Dom.matches" {
  test "returns true if the selector matches" {
    Dom.createElement("div")
    |> Dom.matches("div")
  }

  test "returns false for invalid selector" {
    (Dom.createElement("div")
    |> Dom.matches("??")) == false
  }

  test "returns false if the selector does not match" {
    (Dom.createElement("div")
    |> Dom.matches("p")) == false
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

  fun show : Promise(Never, Void) {
    sequence {
      Timer.timeout(100, "")
      next { shown = true }
    }
  }

  fun focus : Promise(String, Void) {
    input
    |> Maybe.withDefault(Dom.createElement("div"))
    |> Dom.focusWhenVisible()
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
    with Test.Html {
      with Test.Context {
        <Test.Dom.Focus/>
        |> start()
        |> triggerClick("#focus")
        |> triggerClick("#show")
        |> timeout(200)
        |> assertCSSOf("#input", "display", "inline-block")
        |> assertActiveElement("#input")
      }
    }
  }
}
