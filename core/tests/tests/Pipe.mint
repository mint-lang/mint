suite "Pipe with await" {
  test "it awaits" {
    let x =
      (value : String) { await value }

    let y =
      "Hello World!"
      |> await x
      |> await x

    y == "Hello World!"
  }

  test "it awaits #2" {
    let x =
      (value : String) { await value }

    ("Hello World!"
    |> await x
    |> await x) == "Hello World!"
  }

  test "it awaits #3" {
    let x =
      (value : String) { await value }

    [
      ("Hello World!"
      |> await x
      |> await x)
    ] == ["Hello World!"]
  }

  test "with captures" {
    (Math.random() * 10)
    |> Math.floor
    |> String.charAt("Hello World!", _)
    |> String.toUpperCase()
    |> String.isNotEmpty
  }

  test "with labelled captures" {
    (Math.random() * 10)
    |> Math.floor
    |> String.charAt(string: "Hello World!", index: _)
    |> String.toUpperCase()
    |> String.isNotEmpty
  }
}
