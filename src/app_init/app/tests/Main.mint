suite "Main" {
  test "Greets Mint" {
    with Test.Html {
      <Main/>
      |> start()
      |> assertTextOf("a", "Learn Mint")
    }
  }
}
