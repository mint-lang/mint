suite "CSV" {
  test "empty CSV returns empty list" {
    CSV.parse("") == Result.Ok([])
  }

  test "simple CSV return an array of items" {
    CSV.parse("a,b,c") == Result.Ok([["a", "b", "c"]])
  }

  test "complex CSV" {
    CSV.parse("Ben, 25,\" TRUE\n\r\"\"\"\nAustin, 25, FALSE") == Result.Ok(
      [["Ben", " 25", " TRUE\n\r\""], ["Austin", " 25", " FALSE"]])
  }

  test "CRLF" {
    CSV.parse("test\ntest\r\ntest") == Result.Ok([["test"], ["test"], ["test"]])
  }

  test "With optional new line ending" {
    CSV.parse("test\ntest\r\ntest\n") == Result.Ok(
      [["test"], ["test"], ["test"]])
  }

  test "Quoting" {
    [
      "first_column,second_column\n\"First row\",Second row\n",
      "first_column,second_column\nFirst row,\"Second row\"\n",
      "\"first_column\",second_column\nFirst row,Second row\n",
      "first_column,\"second_column\"\nFirst row,Second row\n",
      "\"first_column\",second_column\n\"First row\",Second row\n"
    ]
    |> Array.map(
      (item : String) {
        CSV.parse(item) == Result.Ok(
          [["first_column", "second_column"], ["First row", "Second row"]])
      })
    |> Array.reject((item : Bool) { item })
    |> Array.isEmpty
  }

  test "Generate" {
    CSV.generate([["Hello\"", "World"]]) == "\"Hello\"\"\",World"
  }
}
