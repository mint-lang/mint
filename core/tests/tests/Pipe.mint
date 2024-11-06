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
}
