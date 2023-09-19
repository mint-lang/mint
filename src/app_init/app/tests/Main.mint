suite "Main" {
  test "Greets Mint" {
    <Main/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("a", "Learn Mint")
  }
}
