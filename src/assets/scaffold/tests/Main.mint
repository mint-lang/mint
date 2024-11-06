suite "Main" {
  test "h3 has the correct content" {
    <Main/>
    |> Test.Html.start()
    |> Test.Html.assertTextOf("h3", "Hello there 👋")
  }
}
