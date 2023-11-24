suite "@inline" {
  test "inlines the contents" {
    @inline(../../../spec/fixtures/data.txt) == "Hello World!\n"
  }
}

suite "@asset" {
  test "references the file" {
    @asset(../../../spec/fixtures/data.txt) == "/__mint__/data_8ddd8be4b179a529afa5f2ffae4b9858.txt"
  }
}

suite "@svg" {
  test "loads the file" {
    @svg(../../../spec/fixtures/icon.svg)
    |> Test.Html.start()
    |> Test.Html.assertElementExists("svg")
  }
}

suite "@format" {
  test "returns the formatter source" {
    let {value, formatted} =
      @format {
        {
          "Hello World!"
        }
      }

    value == "Hello World!" &&
      formatted == <<~MINT
      {
        "Hello World!"
      }
      MINT
  }
}

suite "@highlight" {
  test "highlights the given code" {
    @highlight {
      "Hello World!"
    }[1]
    |> Test.Html.start()
    |> Test.Html.assertElementExists("span.line")
    |> Test.Html.assertElementExists("span.string")
  }
}

suite "@highlight-file" {
  test "highlights the given file" {
    @highlight-file(../../../spec/fixtures/Test.mint)
    |> Test.Html.start()
    |> Test.Html.assertElementExists("span.line")
    |> Test.Html.assertElementExists("span.namespace")
  }
}
