suite "Pipe with await" {
  test "it awaits" {
    let x =
      (value : String) {
        await value
      }

    let y =
      "Hello World!"
      |> await x
      |> await x

    y == "Hello World!"
  }
}
