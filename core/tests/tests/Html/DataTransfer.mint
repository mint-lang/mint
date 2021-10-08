suite "Html.DataTransfer.getEffectAllowed" {
  test "it returns the value" {
    (`new DataTransfer()`
    |> Html.DataTransfer.getEffectAllowed()) == "none"
  }
}

/*
suite "Html.DataTransfer.setEffectAllowed" {
  test "it returns the value" {
    (`new DataTransfer()`
    |> Html.DataTransfer.setEffectAllowed("copy")
    |> Html.DataTransfer.getEffectAllowed) == "copy"
  }
}
*/

suite "Html.DataTransfer.getDropEffect" {
  test "it returns the value" {
    (`new DataTransfer()`
    |> Html.DataTransfer.getDropEffect()) == "none"
  }
}

/*
suite "Html.DataTransfer.setDropEffect" {
  test "it returns the value" {
    (`new DataTransfer()`
    |> Html.DataTransfer.setDropEffect("copy")
    |> Html.DataTransfer.getDropEffect) == "copy"
  }
}
*/

suite "Html.DataTransfer.getTypes" {
  test "it returns the value" {
    (`new DataTransfer()`
    |> Html.DataTransfer.getTypes()) == []
  }
}

suite "Html.DataTransfer.getFiles" {
  test "it returns the value" {
    (`new DataTransfer()`
    |> Html.DataTransfer.getFiles()) == []
  }
}

suite "Html.DataTransfer.setData && Html.DataTransfer.getData" {
  test "it returns the value" {
    value =
      `new DataTransfer()` as Html.DataTransfer
      |> Html.DataTransfer.setData("text/plain", "Hello!")
      |> Html.DataTransfer.getData("text/plain")

    value == "Hello!"
  }
}

suite "Html.DataTransfer.setDragImage" {
  test "it returns the value" {
    data =
      `new DataTransfer()` as Html.DataTransfer

    Html.DataTransfer.setDragImage(Dom.createElement("div"), 0, 0, data) == data
  }
}
