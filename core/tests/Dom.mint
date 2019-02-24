suite "Dom.createElement" {
  test "returns a Dom element" {
    try {
      element =
        Dom.createElement("div")

      `element.tagName === "DIV"`
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
