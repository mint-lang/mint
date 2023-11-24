component Test.CSS {
  style root {
    color: red;

    span {
      color: blue;
    }
  }

  fun render : Html {
    <div::root>
      <span/>
    </div>
  }
}

suite "CSS Definition" {
  test "sets css values" {
    <Test.CSS/>
    |> Test.Html.start()
    |> Test.Html.assertCssOf("div", "color", "rgb(255, 0, 0)")
    |> Test.Html.assertCssOf("span", "color", "rgb(0, 0, 255)")
  }
}
