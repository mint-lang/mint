suite "ArrayBuffer conversion from/to String" {
  test "round trip converts" {
    ("Hello"
    |> ArrayBuffer.toArrayBuffer()
    |> ArrayBuffer.toString()) == "Hello"
  }
}
