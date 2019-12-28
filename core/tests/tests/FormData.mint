suite "FormData.equality" {
  test "returns true if equal" {
    FormData.empty() == FormData.empty()
  }
}

suite "FormData.empty" {
  test "returns an empty form data object" {
    FormData.empty()
    |> FormData.keys()
    |> Array.isEmpty()
  }
}

suite "FormData.keys" {
  test "returns the keys of the form data object" {
    (FormData.empty()
    |> FormData.addString("key", "hello")
    |> FormData.keys()
    |> Array.firstWithDefault("")) == "key"
  }
}

suite "FormData.addString" {
  test "adds the given string value to the form data object" {
    (FormData.empty()
    |> FormData.addString("key", "hello")
    |> FormData.keys()
    |> Array.firstWithDefault("")) == "key"
  }
}

suite "FormData.addFile" {
  test "adds the given file value to the form data object" {
    (FormData.empty()
    |> FormData.addFile("file", File.fromString("a", "a", "a"))
    |> FormData.keys()
    |> Array.firstWithDefault("")) == "file"
  }
}
