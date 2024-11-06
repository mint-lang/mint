suite "Here Document" {
  test "Preserved Whitespace" {
    <<-TEST
    Hello
    TEST == "    Hello"
  }

  test "Removed Whitespace" {
    <<~TEST
    Hello
    TEST == "Hello"
  }

  test "Interpolation" {
    <<~TEST
    #{"Hello"}
    TEST == "Hello"
  }

  test "Markdown" {
    <<#TEST
    Hello
    TEST
    |> Test.Html.start()
    |> Test.Html.assertTextOf("p", "Hello")
  }
}
